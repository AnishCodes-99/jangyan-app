import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/category_model.dart';
import '../models/question_model.dart';
import 'firebase_service.dart';

class DataRepository extends ChangeNotifier {
  List<CategoryModel> _categories = [];
  final Map<String, List<QuestionModel>> _questionsCache = {};
  bool _isLoading = false;
  String? _error;

  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  DataRepository() {
    loadCategories();
  }

  Future<void> loadCategories() async {
    if (_categories.isNotEmpty) return;
    _isLoading = true;
    notifyListeners();

    try {
      final jsonString = await rootBundle.loadString(
        'assets/data/modules_metadata.json',
      );
      final list = jsonDecode(jsonString) as List<dynamic>;
      _categories = list
          .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
          .toList();
      debugPrint(
        '[DataRepository] Loaded ${_categories.length} categories from asset metadata.',
      );
    } catch (e) {
      _error = 'Failed to load categories: $e';
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  CategoryModel? getCategoryById(String id) {
    try {
      return _categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<QuestionModel>> getQuestionsForCategory(String categoryId) async {
    if (_questionsCache.containsKey(categoryId) &&
        _questionsCache[categoryId]!.isNotEmpty) {
      return _questionsCache[categoryId]!;
    }

    try {
      final assetPath = 'assets/data/mcqs/$categoryId.json';
      final jsonString = await rootBundle.loadString(assetPath);
      final map = jsonDecode(jsonString) as Map<String, dynamic>;
      final rawList = map['questions'] as List<dynamic>? ?? [];

      final questions = rawList
          .map((q) => QuestionModel.fromJson(q as Map<String, dynamic>))
          .toList();

      _questionsCache[categoryId] = questions;
      debugPrint(
        '[DataRepository] Loaded ${questions.length} authentic MCQs for $categoryId',
      );
      return questions;
    } catch (e) {
      debugPrint('[DataRepository] Error loading category $categoryId: $e');
      // Fallback: try loading from all_extracted_mcqs.json
      try {
        final allString = await rootBundle.loadString(
          'assets/data/all_extracted_mcqs.json',
        );
        final allMap = jsonDecode(allString) as Map<String, dynamic>;
        if (allMap.containsKey(categoryId)) {
          final catData = allMap[categoryId] as Map<String, dynamic>;
          final rawList = catData['questions'] as List<dynamic>? ?? [];
          final questions = rawList
              .map((q) => QuestionModel.fromJson(q as Map<String, dynamic>))
              .toList();
          _questionsCache[categoryId] = questions;
          return questions;
        }
      } catch (err) {
        debugPrint('[DataRepository] Secondary fallback error: $err');
      }
      return [];
    }
  }

  Future<List<QuestionModel>> getRandomizedQuestions({
    required String categoryId,
    int count = 20,
  }) async {
    List<QuestionModel> pool = [];

    if (categoryId == 'all_mixed') {
      // Pick balanced slice across all 6 categories
      for (final cat in _categories) {
        final catQs = await getQuestionsForCategory(cat.id);
        if (catQs.isNotEmpty) {
          final shuffled = List<QuestionModel>.from(catQs)..shuffle();
          final takeCount = (count / _categories.length).ceil();
          pool.addAll(shuffled.take(takeCount));
        }
      }
    } else {
      pool = await getQuestionsForCategory(categoryId);
    }

    final shuffled = List<QuestionModel>.from(pool)..shuffle();
    if (shuffled.length > count) {
      return shuffled.sublist(0, count);
    }
    return shuffled;
  }

  /// Cloud Firestore Sync helper for Admin
  Future<int> syncAllQuestionsToFirestore() async {
    final fs = FirebaseService.firestore;
    if (fs == null) return 0;

    int syncedCount = 0;
    try {
      final allString = await rootBundle.loadString(
        'assets/data/all_extracted_mcqs.json',
      );
      final allMap = jsonDecode(allString) as Map<String, dynamic>;

      final batch = fs.batch();
      for (final entry in allMap.entries) {
        final catId = entry.key;
        final catObj = entry.value as Map<String, dynamic>;
        final qs = catObj['questions'] as List<dynamic>? ?? [];

        // Save Category document
        final catDoc = fs.collection('categories').doc(catId);
        batch.set(catDoc, {
          'id': catId,
          'title': catObj['title'] ?? catId,
          'count': catObj['count'] ?? qs.length,
          'updatedAt': DateTime.now().toIso8601String(),
        });

        // Batch upload sample questions to Firestore
        for (final q in qs.take(25)) {
          final qDoc = fs.collection('questions').doc('${catId}_${q['id']}');
          batch.set(qDoc, q);
          syncedCount++;
        }
      }
      await batch.commit();
      debugPrint(
        '[DataRepository] Synced $syncedCount questions to Cloud Firestore.',
      );
    } catch (e) {
      debugPrint('[DataRepository] Firestore sync error: $e');
    }
    return syncedCount;
  }
}
