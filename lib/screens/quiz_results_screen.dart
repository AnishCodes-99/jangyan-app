import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../models/quiz_attempt.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'quiz_screen.dart';

class QuizResultsScreen extends StatelessWidget {
  final QuizAttempt attempt;

  const QuizResultsScreen({super.key, required this.attempt});

  String _getBadge(double acc) {
    if (acc >= 90) return 'Citizen Champion 🌟';
    if (acc >= 75) return 'Civic Scholar 🏅';
    if (acc >= 50) return 'Aware Citizen 🎖️';
    return 'Active Learner 📚';
  }

  Color _getBadgeColor(double acc) {
    if (acc >= 90) return AppColors.success;
    if (acc >= 75) return AppColors.primary;
    if (acc >= 50) return AppColors.warning;
    return AppColors.textSecondary;
  }

  void _showCertificateDialog(BuildContext context, String citizenName) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Certificate Header
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'JanGyan Citizen Certificate',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    const Text(
                      'CERTIFICATE OF CITIZEN LITERACY',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'This is proudly awarded to:',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      citizenName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'For successfully completing the ${attempt.categoryTitle} National Civic Assessment with an accuracy score of ${attempt.accuracy.toStringAsFixed(1)}%.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Date: ${attempt.timestamp.day}/${attempt.timestamp.month}/${attempt.timestamp.year}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const Text(
                          'Verified: JAN-GYAN-IND',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.share, size: 16),
                label: const Text('Share / Save Certificate'),
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'JanGyan Verified Certificate copied to clipboard!',
                      ),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: AppColors.success,
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

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final citizenName = auth.currentUser?.fullName ?? 'Citizen';
    final badge = _getBadge(attempt.accuracy);
    final badgeColor = _getBadgeColor(attempt.accuracy);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Assessment Results'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: 'Home',
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Score Summary Hero Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: badgeColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    '${attempt.score} / ${attempt.totalQuestions}',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryDark,
                      letterSpacing: -1,
                    ),
                  ),
                  Text(
                    'Accuracy: ${attempt.accuracy.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: badgeColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: AppColors.border, height: 1),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetric(
                        Icons.check_circle,
                        '${attempt.correctCount}',
                        'Correct',
                        AppColors.success,
                      ),
                      _buildMetric(
                        Icons.cancel,
                        '${attempt.incorrectCount}',
                        'Incorrect',
                        AppColors.error,
                      ),
                      _buildMetric(
                        Icons.category,
                        attempt.categoryTitle.split(' ').first,
                        'Domain',
                        AppColors.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Certificate Generator Action Banner
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.card_membership, size: 20),
              label: const Text('View & Download JanGyan Certificate'),
              onPressed: () => _showCertificateDialog(context, citizenName),
            ),
            const SizedBox(height: 20),

            // Question Review Accordion Header
            const Text(
              'Detailed Question Review',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Review official handbook explanations for every question.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),

            // Review Items List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: attempt.questions.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, idx) {
                final q = attempt.questions[idx];
                final userAns = attempt.userAnswers[idx];
                final isCorrect = userAns == q.answer;

                return Card(
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 4,
                    ),
                    leading: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isCorrect
                            ? AppColors.successLight
                            : AppColors.errorLight,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isCorrect ? Icons.check : Icons.close,
                        color: isCorrect ? AppColors.success : AppColors.error,
                        size: 16,
                      ),
                    ),
                    title: Text(
                      'Q${idx + 1}: ${q.question}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              q.question,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...List.generate(q.options.length, (optIdx) {
                              final optLetter = String.fromCharCode(
                                65 + optIdx,
                              );
                              final optText = q.options[optIdx];
                              final isUserChoice = userAns == optIdx;
                              final isActualAnswer = optIdx == q.answer;

                              Color optBg = Colors.transparent;
                              Color optBorder = AppColors.border;
                              FontWeight fw = FontWeight.normal;

                              if (isActualAnswer) {
                                optBg = AppColors.successLight.withValues(
                                  alpha: 0.5,
                                );
                                optBorder = AppColors.success;
                                fw = FontWeight.bold;
                              } else if (isUserChoice && !isActualAnswer) {
                                optBg = AppColors.errorLight.withValues(
                                  alpha: 0.5,
                                );
                                optBorder = AppColors.error;
                              }

                              return Container(
                                margin: const EdgeInsets.only(bottom: 6),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: optBg,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: optBorder),
                                ),
                                child: Text(
                                  '$optLetter. $optText ${isActualAnswer ? ' (Correct Answer)' : ''} ${isUserChoice ? ' [Your Choice]' : ''}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: fw,
                                  ),
                                ),
                              );
                            }),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.primaryTint.withValues(
                                  alpha: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '💡 Explanation: ${q.explanation}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textPrimary,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Actions Row
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuizScreen(
                            categoryId: attempt.categoryId,
                            categoryTitle: attempt.categoryTitle,
                            questionCount: attempt.totalQuestions,
                          ),
                        ),
                      );
                    },
                    child: const Text('Retake Quiz'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false,
                      );
                    },
                    child: const Text('Back to Home'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
