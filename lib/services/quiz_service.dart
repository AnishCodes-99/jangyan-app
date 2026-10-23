import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/question_model.dart';
import '../models/quiz_attempt.dart';
import 'auth_service.dart';
import 'data_repository.dart';
import 'firebase_service.dart';

class QuizService extends ChangeNotifier {
  final DataRepository dataRepository;
  final AuthService authService;

  List<QuestionModel> _questions = [];
  int _currentIndex = 0;
  final Map<int, int> _userAnswers =
      {}; // questionIndex -> selectedOptionIndex (0..3)
  bool _isLoading = false;
  bool _isFinished = false;
  String _activeCategoryId = '';
  String _activeCategoryTitle = '';
  int _secondsElapsed = 0;
  Timer? _timer;

  final Set<int> _markedForReview = {};

  List<QuestionModel> get questions => _questions;
  int get currentIndex => _currentIndex;
  Map<int, int> get userAnswers => _userAnswers;
  Set<int> get markedForReview => _markedForReview;
  bool isMarkedForReview(int index) => _markedForReview.contains(index);
  bool get isLoading => _isLoading;
  bool get isFinished => _isFinished;
  String get activeCategoryId => _activeCategoryId;
  String get activeCategoryTitle => _activeCategoryTitle;
  int get secondsElapsed => _secondsElapsed;

  void toggleMarkForReview(int index) {
    if (_markedForReview.contains(index)) {
      _markedForReview.remove(index);
    } else {
      _markedForReview.add(index);
    }
    notifyListeners();
  }

  QuestionModel? get currentQuestion {
    if (_questions.isEmpty || _currentIndex >= _questions.length) return null;
    return _questions[_currentIndex];
  }

  int? get currentAnswer => _userAnswers[_currentIndex];
  bool get hasAnsweredCurrent => _userAnswers.containsKey(_currentIndex);


  int get totalQuestions => _questions.length;

  int get correctCount {
    int count = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_userAnswers[i] == _questions[i].answer) {
        count++;
      }
    }
    return count;
  }

  int get incorrectCount {
    int count = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_userAnswers.containsKey(i) &&
          _userAnswers[i] != _questions[i].answer) {
        count++;
      }
    }
    return count;
  }

  double get accuracy {
    if (_userAnswers.isEmpty) return 0.0;
    return (correctCount / _userAnswers.length) * 100.0;
  }

  QuizService({required this.dataRepository, required this.authService});

  Future<void> startQuiz({
    required String categoryId,
    required String categoryTitle,
    int count = 20,
  }) async {
    _isLoading = true;
    _isFinished = false;
    _currentIndex = 0;
    _userAnswers.clear();
    _secondsElapsed = 0;
    _activeCategoryId = categoryId;
    _activeCategoryTitle = categoryTitle;
    notifyListeners();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!_isFinished) {
        _secondsElapsed++;
        notifyListeners();
      }
    });

    try {
      _questions = await dataRepository.getRandomizedQuestions(
        categoryId: categoryId,
        count: count,
      );
      debugPrint(
        '[QuizService] Started quiz for $categoryTitle with ${_questions.length} questions.',
      );
    } catch (e) {
      debugPrint('[QuizService] Error initializing quiz: $e');
      _questions = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectAnswer(int optionIndex) {
    if (_isFinished || optionIndex < 0 || optionIndex > 3) return;
    _userAnswers[_currentIndex] = optionIndex;
    notifyListeners();
  }

  void nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (_currentIndex > 0) {
      _currentIndex--;
      notifyListeners();
    }
  }

  void jumpToQuestion(int index) {
    if (index >= 0 && index < _questions.length) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  Future<QuizAttempt> finishQuiz() async {
    _isFinished = true;
    _timer?.cancel();

    final user = authService.currentUser;
    final userId = user?.uid ?? 'guest_citizen';

    final attempt = QuizAttempt(
      attemptId: const Uuid().v4(),
      userId: userId,
      categoryId: _activeCategoryId,
      categoryTitle: _activeCategoryTitle,
      totalQuestions: totalQuestions,
      score: correctCount,
      correctCount: correctCount,
      incorrectCount: incorrectCount,
      accuracy: accuracy,
      timestamp: DateTime.now(),
      userAnswers: Map<int, int>.from(_userAnswers),
      questions: List<QuestionModel>.from(_questions),
    );

    // Update user profile statistics
    await authService.recordQuizResult(
      attempted: _userAnswers.length,
      correct: correctCount,
      incorrect: incorrectCount,
    );

    // Save to Firestore & Local Storage
    await _persistAttempt(attempt);

    notifyListeners();
    return attempt;
  }

  Future<void> _persistAttempt(QuizAttempt attempt) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyKey = 'jangyan_attempts_history';
      final existing = prefs.getStringList(historyKey) ?? [];
      existing.insert(0, jsonEncode(attempt.toMap()));
      if (existing.length > 50) existing.removeLast();
      await prefs.setStringList(historyKey, existing);

      // Firestore persistence
      final fs = FirebaseService.firestore;
      if (fs != null) {
        await fs
            .collection('quizProgress')
            .doc(attempt.attemptId)
            .set(attempt.toMap());
        debugPrint('[QuizService] Persisted quiz attempt to Firestore.');
      }
    } catch (e) {
      debugPrint('[QuizService] Error saving quiz progress: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
