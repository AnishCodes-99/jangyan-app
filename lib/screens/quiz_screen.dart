import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../models/quiz_mode.dart';
import '../services/auth_service.dart';
import '../services/data_repository.dart';
import '../services/quiz_service.dart';
import 'quiz_results_screen.dart';

class QuizScreen extends StatefulWidget {
  final String categoryId;
  final String categoryTitle;
  final int questionCount;
  final QuizSolutionMode solutionMode;

  const QuizScreen({
    super.key,
    required this.categoryId,
    required this.categoryTitle,
    this.questionCount = 20,
    this.solutionMode = QuizSolutionMode.instant,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late QuizService _quizService;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final repo = Provider.of<DataRepository>(context, listen: false);
      final auth = Provider.of<AuthService>(context, listen: false);
      _quizService = QuizService(dataRepository: repo, authService: auth);
      _quizService.startQuiz(
        categoryId: widget.categoryId,
        categoryTitle: widget.categoryTitle,
        count: widget.questionCount,
      );
    }
  }

  @override
  void dispose() {
    _quizService.dispose();
    super.dispose();
  }

  String _formatTimer(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Future<void> _handleFinish() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Submit Assessment?'),
        content: Text(
          'You have answered ${_quizService.userAnswers.length} of ${_quizService.totalQuestions} questions. Do you want to submit your assessment and view your certified results?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Review Answers'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Submit Now'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final attempt = await _quizService.finishQuiz();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => QuizResultsScreen(
              attempt: attempt,
              solutionMode: widget.solutionMode,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<QuizService>.value(
      value: _quizService,
      child: Consumer<QuizService>(
        builder: (context, quiz, _) {
          final color = AppColors.getCategoryColor(widget.categoryId);

          if (quiz.isLoading) {
            return Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(title: Text(widget.categoryTitle)),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Preparing official question bank...',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (quiz.questions.isEmpty) {
            return Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(title: Text(widget.categoryTitle)),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: AppColors.warning,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'No questions found for this domain.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Return to Domains'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          final q = quiz.currentQuestion!;
          final qIndex = quiz.currentIndex;
          final selectedOption = quiz.currentAnswer;
          final isAnswered = selectedOption != null;

          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.categoryTitle,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.solutionMode == QuizSolutionMode.instant
                        ? '⚡ Instant Solutions • ${quiz.totalQuestions} Questions'
                        : '📝 After Test Result • ${quiz.totalQuestions} Questions',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              actions: [
                // Question Palette Button
                IconButton(
                  tooltip: 'Question Palette (${quiz.totalQuestions} Questions)',
                  icon: const Icon(Icons.grid_view_rounded),
                  onPressed: () => _showQuestionPalette(context, quiz, color),
                ),
                // Bookmark / Mark for Review
                IconButton(
                  tooltip: quiz.isMarkedForReview(qIndex)
                      ? 'Remove Review Flag'
                      : 'Mark for Review',
                  icon: Icon(
                    quiz.isMarkedForReview(qIndex)
                        ? Icons.bookmark
                        : Icons.bookmark_border_rounded,
                    color: quiz.isMarkedForReview(qIndex)
                        ? AppColors.warning
                        : null,
                  ),
                  onPressed: () => quiz.toggleMarkForReview(qIndex),
                ),
                // Timer Chip
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTint,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.timer_outlined,
                          size: 14,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatTimer(quiz.secondsElapsed),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                // Progress Bar
                LinearProgressIndicator(
                  value: (qIndex + 1) / quiz.totalQuestions,
                  backgroundColor: AppColors.border,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 4,
                ),

                // Question Navigator Scroll
                Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  color: Colors.white,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: quiz.totalQuestions,
                    separatorBuilder: (_, _) => const SizedBox(width: 6),
                    itemBuilder: (context, idx) {
                      final isCurrent = idx == qIndex;
                      final isAnsweredIdx = quiz.userAnswers.containsKey(idx);

                      Color bg = AppColors.background;
                      Color textCol = AppColors.textSecondary;
                      BorderSide border = const BorderSide(
                        color: AppColors.border,
                      );

                      if (isCurrent) {
                        bg = AppColors.primary;
                        textCol = Colors.white;
                        border = const BorderSide(color: AppColors.primary);
                      } else if (isAnsweredIdx) {
                        bg = AppColors.primaryTint;
                        textCol = AppColors.primaryDark;
                        border = const BorderSide(
                          color: AppColors.primaryLight,
                        );
                      }

                      return InkWell(
                        onTap: () => quiz.jumpToQuestion(idx),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 34,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: bg,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.fromBorderSide(border),
                          ),
                          child: Text(
                            '${idx + 1}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: textCol,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Scrollable Question & Options Body
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Question Header Pill
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Question ${qIndex + 1} of ${quiz.totalQuestions}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: color,
                                ),
                              ),
                            ),
                            const Spacer(),
                            if (isAnswered)
                              widget.solutionMode == QuizSolutionMode.instant
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: selectedOption == q.answer
                                            ? AppColors.successLight
                                            : AppColors.errorLight,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        selectedOption == q.answer
                                            ? 'CORRECT'
                                            : 'INCORRECT',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: selectedOption == q.answer
                                              ? AppColors.success
                                              : AppColors.error,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryTint,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'ANSWERED',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryDark,
                                        ),
                                      ),
                                    ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Question Text Card
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              q.question,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Four Options (A, B, C, D)
                        ...List.generate(q.options.length, (optIdx) {
                          final optLetter = String.fromCharCode(65 + optIdx);
                          final optText = q.options[optIdx];
                          final isSelected = selectedOption == optIdx;
                          final isInstant =
                              widget.solutionMode == QuizSolutionMode.instant;

                          Color cardBg = Colors.white;
                          Color borderCol = AppColors.border;
                          Color badgeBg = AppColors.background;
                          Color badgeText = AppColors.textPrimary;

                          if (isInstant && isAnswered) {
                            if (optIdx == q.answer) {
                              // Highlight correct option in green
                              cardBg = AppColors.successLight.withValues(
                                alpha: 0.4,
                              );
                              borderCol = AppColors.success;
                              badgeBg = AppColors.success;
                              badgeText = Colors.white;
                            } else if (isSelected && optIdx != q.answer) {
                              // Highlight wrong selected in red
                              cardBg = AppColors.errorLight.withValues(
                                alpha: 0.4,
                              );
                              borderCol = AppColors.error;
                              badgeBg = AppColors.error;
                              badgeText = Colors.white;
                            }
                          } else if (isSelected) {
                            cardBg = AppColors.primaryTint;
                            borderCol = AppColors.primary;
                            badgeBg = AppColors.primary;
                            badgeText = Colors.white;
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: InkWell(
                              onTap: () {
                                quiz.selectAnswer(optIdx);
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: cardBg,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: borderCol,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 28,
                                      height: 28,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: badgeBg,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        optLetter,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: badgeText,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          optText,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.textPrimary,
                                            height: 1.35,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),

                        // Instant Official JanGyan Explanation Card (Only in Instant Solutions Mode)
                        if (widget.solutionMode == QuizSolutionMode.instant &&
                            isAnswered) ...[
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.primaryTint.withValues(
                                alpha: 0.6,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.primaryLight.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.lightbulb_outline,
                                      size: 18,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Official JanGyan Explanation',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryDark,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  q.explanation,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textPrimary,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ] else if (widget.solutionMode ==
                            QuizSolutionMode.afterTest) ...[
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.info_outline,
                                  size: 16,
                                  color: AppColors.textMuted,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'After Test Result Mode: Complete solutions & explanations will be revealed after submission.',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // Bottom Action Bar
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: AppColors.border)),
                  ),
                  child: Row(
                    children: [
                      OutlinedButton.icon(
                        icon: const Icon(Icons.chevron_left, size: 18),
                        label: const Text('Previous'),
                        onPressed: qIndex > 0 ? quiz.previousQuestion : null,
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: quiz.isMarkedForReview(qIndex)
                            ? 'Marked for Review'
                            : 'Mark for Review',
                        icon: Icon(
                          quiz.isMarkedForReview(qIndex)
                              ? Icons.bookmark
                              : Icons.bookmark_border_rounded,
                          color: quiz.isMarkedForReview(qIndex)
                              ? AppColors.warning
                              : AppColors.textSecondary,
                        ),
                        onPressed: () => quiz.toggleMarkForReview(qIndex),
                      ),
                      IconButton(
                        tooltip: 'View Question Palette (${quiz.totalQuestions})',
                        icon: const Icon(
                          Icons.grid_view_rounded,
                          color: AppColors.primary,
                        ),
                        onPressed: () => _showQuestionPalette(context, quiz, color),
                      ),
                      const Spacer(),
                      if (qIndex < quiz.totalQuestions - 1)
                        ElevatedButton.icon(
                          icon: const Icon(Icons.chevron_right, size: 18),
                          label: const Text('Next'),
                          onPressed: quiz.nextQuestion,
                        )
                      else
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                          ),
                          icon: const Icon(Icons.check, size: 18),
                          label: const Text('Submit Assessment'),
                          onPressed: _handleFinish,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showQuestionPalette(
    BuildContext context,
    QuizService quiz,
    Color categoryColor,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _QuestionPaletteSheet(
        quiz: quiz,
        categoryColor: categoryColor,
        onSelectQuestion: (idx) {
          quiz.jumpToQuestion(idx);
          Navigator.pop(ctx);
        },
      ),
    );
  }
}

class _QuestionPaletteSheet extends StatefulWidget {
  final QuizService quiz;
  final Color categoryColor;
  final ValueChanged<int> onSelectQuestion;

  const _QuestionPaletteSheet({
    required this.quiz,
    required this.categoryColor,
    required this.onSelectQuestion,
  });

  @override
  State<_QuestionPaletteSheet> createState() => _QuestionPaletteSheetState();
}

class _QuestionPaletteSheetState extends State<_QuestionPaletteSheet> {
  String _filter = 'all'; // 'all', 'answered', 'review', 'unanswered'

  @override
  Widget build(BuildContext context) {
    final quiz = widget.quiz;
    final total = quiz.totalQuestions;
    final answeredCount = quiz.userAnswers.length;
    final reviewCount = quiz.markedForReview.length;
    final unattemptedCount = total - answeredCount;

    final List<int> filteredIndices = [];
    for (int i = 0; i < total; i++) {
      final isAnswered = quiz.userAnswers.containsKey(i);
      final isReview = quiz.isMarkedForReview(i);
      if (_filter == 'answered' && !isAnswered) continue;
      if (_filter == 'review' && !isReview) continue;
      if (_filter == 'unanswered' && isAnswered) continue;
      filteredIndices.add(i);
    }

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.78,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question Palette ($total MCQs)',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Status Badges Row
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _buildStatusPill(
                'Answered: $answeredCount',
                AppColors.success,
                AppColors.successLight,
              ),
              _buildStatusPill(
                'Review: $reviewCount',
                AppColors.warning,
                AppColors.warningLight,
              ),
              _buildStatusPill(
                'Unattempted: $unattemptedCount',
                AppColors.textSecondary,
                AppColors.background,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Filter Segmented Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('all', 'All ($total)'),
                const SizedBox(width: 6),
                _buildFilterChip('answered', 'Answered ($answeredCount)'),
                const SizedBox(width: 6),
                _buildFilterChip('review', 'Review ($reviewCount)'),
                const SizedBox(width: 6),
                _buildFilterChip('unanswered', 'Unattempted ($unattemptedCount)'),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Grid of Question Numbers
          Expanded(
            child: filteredIndices.isEmpty
                ? const Center(
                    child: Text(
                      'No questions match this filter.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  )
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 52,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: filteredIndices.length,
                    itemBuilder: (context, idx) {
                      final qIdx = filteredIndices[idx];
                      final isCurrent = qIdx == quiz.currentIndex;
                      final isAnswered = quiz.userAnswers.containsKey(qIdx);
                      final isReview = quiz.isMarkedForReview(qIdx);

                      Color bg = AppColors.background;
                      Color textCol = AppColors.textPrimary;
                      Border border = Border.all(color: AppColors.border);

                      if (isAnswered) {
                        bg = AppColors.successLight;
                        textCol = AppColors.success;
                        border = Border.all(color: AppColors.success);
                      }
                      if (isReview) {
                        bg = AppColors.warningLight;
                        textCol = const Color(0xFFB45309);
                        border = Border.all(
                          color: AppColors.warning,
                          width: 1.5,
                        );
                      }
                      if (isCurrent) {
                        border = Border.all(
                          color: AppColors.primary,
                          width: 2.0,
                        );
                      }

                      return InkWell(
                        onTap: () => widget.onSelectQuestion(qIdx),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: bg,
                            borderRadius: BorderRadius.circular(8),
                            border: border,
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Text(
                                '${qIdx + 1}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: textCol,
                                ),
                              ),
                              if (isReview)
                                const Positioned(
                                  top: 2,
                                  right: 2,
                                  child: Icon(
                                    Icons.bookmark,
                                    size: 10,
                                    color: AppColors.warning,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPill(String text, Color color, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildFilterChip(String key, String label) {
    final isSelected = _filter == key;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => setState(() => _filter = key),
      selectedColor: AppColors.primaryTint,
      labelStyle: TextStyle(
        fontSize: 11,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
      ),
    );
  }
}

