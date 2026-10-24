enum QuizSolutionMode {
  instant,
  afterTest,
}

class QuizConfig {
  final int questionCount;
  final QuizSolutionMode solutionMode;

  const QuizConfig({
    required this.questionCount,
    this.solutionMode = QuizSolutionMode.instant,
  });
}
