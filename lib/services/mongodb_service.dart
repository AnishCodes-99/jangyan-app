import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/question_model.dart';

class MongoDbService {
  /// Dynamically resolves the MongoDB REST service URL so it works on any PC/mobile on the network
  static String get baseUrl {
    const envUrl = String.fromEnvironment('MONGODB_API_URL', defaultValue: '');
    if (envUrl.isNotEmpty) return envUrl;
    if (kIsWeb) {
      final host = Uri.base.host;
      if (host.isNotEmpty && host != 'localhost' && host != '127.0.0.1') {
        return '${Uri.base.scheme}://$host:5001';
      }
    }
    return 'http://127.0.0.1:5001';
  }

  /// Check whether the MongoDB REST service is reachable
  static Future<bool> isAvailable() async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/api/health'))
          .timeout(const Duration(seconds: 2));
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// Fetch questions from MongoDB for a specific category and count
  static Future<List<QuestionModel>?> fetchQuestions({
    required String categoryId,
    int count = 500,
  }) async {
    try {
      final uri = Uri.parse(
        '$baseUrl/api/questions?category=$categoryId&count=$count',
      );
      final res = await http.get(uri).timeout(const Duration(seconds: 5));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final rawList = data['questions'] as List<dynamic>? ?? [];
        return rawList
            .map((q) => QuestionModel.fromJson(q as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('[MongoDbService] Notice: using local asset cache: $e');
    }
    return null;
  }

  /// Get direct PDF stream URL from MongoDB / backend
  static String getPdfUrl(String filename) {
    return '$baseUrl/api/pdf/$filename';
  }

  /// Sync user profile to MongoDB backend
  static Future<bool> syncUser(Map<String, dynamic> userData) async {
    try {
      final res = await http
          .post(
            Uri.parse('$baseUrl/api/users/sync'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(userData),
          )
          .timeout(const Duration(seconds: 3));
      return res.statusCode == 200;
    } catch (e) {
      debugPrint('[MongoDbService] Sync user notice: $e');
      return false;
    }
  }

  /// Fetch user profile from MongoDB backend
  static Future<Map<String, dynamic>?> fetchUser(String email) async {
    try {
      final encoded = Uri.encodeComponent(email.trim().toLowerCase());
      final res = await http
          .get(Uri.parse('$baseUrl/api/user?email=$encoded'))
          .timeout(const Duration(seconds: 3));
      if (res.statusCode == 200) {
        return jsonDecode(res.body) as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('[MongoDbService] Fetch user notice: $e');
    }
    return null;
  }

  /// Submit feedback to MongoDB backend
  static Future<bool> submitFeedback(Map<String, dynamic> feedbackData) async {
    try {
      final res = await http
          .post(
            Uri.parse('$baseUrl/api/feedback'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(feedbackData),
          )
          .timeout(const Duration(seconds: 3));
      return res.statusCode == 200;
    } catch (e) {
      debugPrint('[MongoDbService] Submit feedback notice: $e');
      return false;
    }
  }
}
