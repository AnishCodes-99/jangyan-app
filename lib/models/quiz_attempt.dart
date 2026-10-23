import 'question_model.dart';

class QuizAttempt {
  final String attemptId;
  final String userId;
  final String categoryId;
  final String categoryTitle;
  final int totalQuestions;
  final int score;
  final int correctCount;
  final int incorrectCount;
  final double accuracy;
  final DateTime timestamp;
  final Map<int, int> userAnswers; // questionId -> selectedOptionIndex (0-3)
  final List<QuestionModel> questions;

  QuizAttempt({
    required this.attemptId,
    required this.userId,
    required this.categoryId,
    required this.categoryTitle,
    required this.totalQuestions,
    required this.score,
    required this.correctCount,
    required this.incorrectCount,
    required this.accuracy,
    required this.timestamp,
    required this.userAnswers,
    this.questions = const [],
  });

  bool get isPassed => accuracy >= 60.0;

  Map<String, dynamic> toMap() {
    return {
      'attemptId': attemptId,
      'userId': userId,
      'categoryId': categoryId,
      'categoryTitle': categoryTitle,
      'totalQuestions': totalQuestions,
      'score': score,
      'correctCount': correctCount,
      'incorrectCount': incorrectCount,
      'accuracy': accuracy,
      'timestamp': timestamp.toIso8601String(),
      'userAnswers': userAnswers.map((k, v) => MapEntry(k.toString(), v)),
    };
  }

  factory QuizAttempt.fromMap(
    Map<String, dynamic> map, {
    List<QuestionModel> questions = const [],
  }) {
    final rawAnswers = map['userAnswers'] as Map<String, dynamic>? ?? {};
    final answers = rawAnswers.map(
      (k, v) => MapEntry(int.tryParse(k) ?? 0, (v as num).toInt()),
    );
    return QuizAttempt(
      attemptId: map['attemptId'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      categoryId: map['categoryId'] as String? ?? '',
      categoryTitle: map['categoryTitle'] as String? ?? '',
      totalQuestions: (map['totalQuestions'] as num?)?.toInt() ?? 0,
      score: (map['score'] as num?)?.toInt() ?? 0,
      correctCount: (map['correctCount'] as num?)?.toInt() ?? 0,
      incorrectCount: (map['incorrectCount'] as num?)?.toInt() ?? 0,
      accuracy: (map['accuracy'] as num?)?.toDouble() ?? 0.0,
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
      userAnswers: answers,
      questions: questions,
    );
  }
}
