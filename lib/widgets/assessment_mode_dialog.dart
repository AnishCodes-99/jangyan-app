import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/quiz_mode.dart';

export '../models/quiz_mode.dart';

class AssessmentModeDialog extends StatefulWidget {
  final String categoryTitle;
  final int initialCount;
  final QuizSolutionMode initialMode;

  const AssessmentModeDialog({
    super.key,
    required this.categoryTitle,
    this.initialCount = 20,
    this.initialMode = QuizSolutionMode.instant,
  });

  static Future<QuizConfig?> show(
    BuildContext context, {
    required String categoryTitle,
    int initialCount = 20,
    QuizSolutionMode initialMode = QuizSolutionMode.instant,
  }) {
    return showDialog<QuizConfig>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AssessmentModeDialog(
        categoryTitle: categoryTitle,
        initialCount: initialCount,
        initialMode: initialMode,
      ),
    );
  }

  @override
  State<AssessmentModeDialog> createState() => _AssessmentModeDialogState();
}

class _AssessmentModeDialogState extends State<AssessmentModeDialog> {
  late QuizSolutionMode _solutionMode;
  late int _questionCount;

  @override
  void initState() {
    super.initState();
    _solutionMode = widget.initialMode;
    _questionCount = widget.initialCount;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480),
        padding: const EdgeInsets.all(22),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTint,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.quiz_rounded,
                      color: AppColors.primary,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Configure Assessment',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          widget.categoryTitle,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Section 1: Solution Mode (User's primary requirement)
              Row(
                children: const [
                  Icon(Icons.tune_rounded, size: 16, color: AppColors.primary),
                  SizedBox(width: 6),
                  Text(
                    '1. Choose Solution Mode',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Option 1: Instant Solutions
              _buildModeOption(
                mode: QuizSolutionMode.instant,
                icon: Icons.bolt_rounded,
                iconColor: const Color(0xFFD97706),
                title: 'Instant Solutions (Learning Mode)',
                subtitle:
                    'Tap karne par wrong answer ho toh right answer reveal hoga with explanation.',
                badge: 'Live Feedback',
                badgeColor: AppColors.warningLight,
                badgeTextColor: const Color(0xFFB45309),
              ),
              const SizedBox(height: 10),

              // Option 2: After Test Result
              _buildModeOption(
                mode: QuizSolutionMode.afterTest,
                icon: Icons.assignment_turned_in_rounded,
                iconColor: AppColors.primary,
                title: 'After Test Result (Exam Mode)',
                subtitle:
                    'Test ke dauran instant solutions nahi honge. Pura test submit karne ke baad sabhi answers with explanations show honge.',
                badge: 'Final Review',
                badgeColor: AppColors.primaryTint,
                badgeTextColor: AppColors.primaryDark,
              ),
              const SizedBox(height: 20),

              // Section 2: Question Count
              Row(
                children: const [
                  Icon(Icons.format_list_numbered_rounded,
                      size: 16, color: AppColors.primary),
                  SizedBox(width: 6),
                  Text(
                    '2. Select Number of Questions',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: _buildCountChip(
                      count: 20,
                      label: '20 MCQs',
                      subLabel: 'Quick',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildCountChip(
                      count: 50,
                      label: '50 MCQs',
                      subLabel: 'Standard',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildCountChip(
                      count: 500,
                      label: '500 MCQs',
                      subLabel: 'Full Exam',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // Begin Quiz Action Button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                icon: const Icon(Icons.play_arrow_rounded, size: 22),
                label: Text(
                  _solutionMode == QuizSolutionMode.instant
                      ? 'Begin Instant Solutions Quiz ($_questionCount MCQs)'
                      : 'Begin Exam Mode Quiz ($_questionCount MCQs)',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(
                    context,
                    QuizConfig(
                      questionCount: _questionCount,
                      solutionMode: _solutionMode,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeOption({
    required QuizSolutionMode mode,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String badge,
    required Color badgeColor,
    required Color badgeTextColor,
  }) {
    final isSelected = _solutionMode == mode;

    return InkWell(
      onTap: () {
        setState(() {
          _solutionMode = mode;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryTint.withValues(alpha: 0.35)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? iconColor.withValues(alpha: 0.2)
                    : iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? AppColors.primaryDark
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: badgeColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          badge,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: badgeTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? AppColors.primary : AppColors.border,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountChip({
    required int count,
    required String label,
    required String subLabel,
  }) {
    final isSelected = _questionCount == count;

    return InkWell(
      onTap: () {
        setState(() {
          _questionCount = count;
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 1.2,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subLabel,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? Colors.white70 : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
