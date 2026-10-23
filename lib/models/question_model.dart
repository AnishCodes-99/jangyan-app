class QuestionModel {
  final int id;
  final String question;
  final List<String> options;
  final int answer; // 0 for A, 1 for B, 2 for C, 3 for D
  final String explanation;
  final String categoryId;
  final String categoryTitle;

  const QuestionModel({
    required this.id,
    required this.question,
    required this.options,
    required this.answer,
    required this.explanation,
    required this.categoryId,
    required this.categoryTitle,
  });

  String get answerLetter {
    if (answer >= 0 && answer <= 3) {
      return String.fromCharCode(65 + answer);
    }
    return 'A';
  }

  String get correctAnswerText {
    if (answer >= 0 && answer < options.length) {
      return options[answer];
    }
    return '';
  }

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      question: json['question'] as String? ?? '',
      options:
          (json['options'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      answer: (json['answer'] as num?)?.toInt() ?? 0,
      explanation:
          json['explanation'] as String? ??
          'Official JanGyan verified citizen concept.',
      categoryId: json['category_id'] as String? ?? '',
      categoryTitle: json['category_title'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'answer': answer,
      'explanation': explanation,
      'category_id': categoryId,
      'category_title': categoryTitle,
    };
  }
}
