import 'package:flutter_test/flutter_test.dart';
import 'package:jangyan/models/category_model.dart';
import 'package:jangyan/models/feedback_model.dart';
import 'package:jangyan/models/module_model.dart';
import 'package:jangyan/models/question_model.dart';
import 'package:jangyan/models/quiz_attempt.dart';
import 'package:jangyan/models/user_profile.dart';

void main() {
  group('JanGyan Core Models & Civic Engine Unit Tests', () {
    test('QuestionModel JSON parsing and validation', () {
      final json = {
        'id': 101,
        'question':
            'What is the National Cyber Crime Helpline Number in India?',
        'options': ['100', '112', '1930', '1098'],
        'answer': 2,
        'explanation': '1930 is the dedicated Citizen Financial Cyber Fraud Reporting helpline.',
        'category_id': 'cyber_safety',
        'category_title': 'Cyber Safety & Digital Security',
      };

      final q = QuestionModel.fromJson(json);
      expect(q.id, 101);
      expect(q.options.length, 4);
      expect(q.answer, 2);
      expect(q.correctAnswerText, '1930');
      expect(q.answerLetter, 'C');
      expect(q.categoryId, 'cyber_safety');
    });

    test('CategoryModel structure and fields', () {
      final cat = CategoryModel(
        id: 'cyber_safety',
        title: 'Cyber Safety & Digital Security',
        tagline: 'Phishing, OTP protection, Cyber Helpline 1930 & DPDP Act',
        colorHex: '#0284C7',
        iconName: 'security',
        folder: '1-Cyber Safety & Digital Security',
        mcqPdf: 'JanGyan_CyberSafety_MCQ_Handbook.pdf',
        mcqRelativePath: '1-Cyber Safety & Digital Security/JanGyan_CyberSafety_MCQ_Handbook.pdf',
        moduleCount: 10,
        modules: const [],
      );

      expect(cat.id, 'cyber_safety');
      expect(cat.moduleCount, 10);
      expect(cat.mcqPdf, isNotEmpty);
    });

    test('ModuleModel structure', () {
      final m = ModuleModel(
        moduleNumber: 1,
        title: 'Introduction to Cyber Security',
        subtitle: 'Core principles and digital safety',
        fileName: 'Jangyan_Catg 01_M1.pdf',
        relativePath:
            '1-Cyber Safety & Digital Security/Jangyan_Catg 01_M1.pdf',
        categoryId: 'cyber_safety',
        categoryTitle: 'Cyber Safety & Digital Security',
      );

      expect(m.moduleNumber, 1);
      expect(m.fileName, endsWith('.pdf'));
    });

    test('QuizAttempt scoring and accuracy calculations', () {
      final attempt = QuizAttempt(
        attemptId: 'attempt_001',
        userId: 'citizen_123',
        categoryId: 'cyber_safety',
        categoryTitle: 'Cyber Safety & Digital Security',
        score: 18,
        totalQuestions: 20,
        correctCount: 18,
        incorrectCount: 2,
        accuracy: 90.0,
        timestamp: DateTime.now(),
        userAnswers: {1: 2, 2: 0},
      );

      expect(attempt.score, 18);
      expect(attempt.totalQuestions, 20);
      expect(attempt.accuracy, 90.0);
      expect(attempt.isPassed, true);
    });

    test('UserProfile role and stats', () {
      final user = UserProfile(
        uid: 'user_001',
        fullName: 'Rajesh Kumar',
        email: 'rajesh@example.in',
        isAdmin: false,
        attemptedCount: 50,
        correctCount: 42,
        incorrectCount: 8,
      );

      expect(user.isAdmin, false);
      expect(user.accuracy, 84.0);

      final admin = UserProfile(
        uid: 'admin_001',
        fullName: 'JanGyan Administrator',
        email: 'admin@jangyan.gov.in',
        isAdmin: true,
      );

      expect(admin.isAdmin, true);
    });

    test('FeedbackModel serialization', () {
      final fb = FeedbackModel(
        id: 'fb_1',
        userId: 'citizen_1',
        userName: 'Citizen Tester',
        userEmail: 'citizen@example.in',
        category: 'Cyber Safety',
        message: 'Excellent content on 1930 helpline!',
        rating: 5,
        timestamp: DateTime.now(),
      );

      final map = fb.toMap();
      expect(map['rating'], 5);
      expect(map['category'], 'Cyber Safety');
      expect(map['message'], isNotEmpty);
    });
  });
}
