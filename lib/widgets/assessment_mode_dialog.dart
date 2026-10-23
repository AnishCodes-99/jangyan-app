import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class AssessmentModeDialog extends StatelessWidget {
  final String categoryTitle;

  const AssessmentModeDialog({
    super.key,
    required this.categoryTitle,
  });

  static Future<int?> show(BuildContext context, {required String categoryTitle}) {
    return showDialog<int>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AssessmentModeDialog(categoryTitle: categoryTitle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 440),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryTint,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.quiz_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Assessment Mode',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        categoryTitle,
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
            const SizedBox(height: 16),
            const Text(
              'Choose how you want to test your civic knowledge:',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 14),

            // Option 1: Quick Practice (20 MCQs)
            _buildOptionCard(
              context: context,
              count: 20,
              icon: Icons.flash_on_rounded,
              iconColor: AppColors.warning,
              title: 'Quick Practice (20 MCQs)',
              subtitle: '15 mins • Ideal for quick daily revision and spot-checks.',
              badge: 'Fast',
              badgeColor: AppColors.warningLight,
              badgeTextColor: const Color(0xFFB45309),
            ),
            const SizedBox(height: 10),

            // Option 2: Standard Assessment (50 MCQs)
            _buildOptionCard(
              context: context,
              count: 50,
              icon: Icons.timer_outlined,
              iconColor: AppColors.primary,
              title: 'Standard Assessment (50 MCQs)',
              subtitle: '35 mins • Balanced evaluation with official explanations.',
              badge: 'Popular',
              badgeColor: AppColors.primaryTint,
              badgeTextColor: AppColors.primaryDark,
            ),
            const SizedBox(height: 10),

            // Option 3: Full Category Exam (All 500 MCQs!)
            _buildOptionCard(
              context: context,
              count: 500,
              icon: Icons.military_tech_rounded,
              iconColor: AppColors.success,
              title: 'Full Examination (All 500 MCQs!)',
              subtitle: 'Mastery Exam • Complete domain coverage with 500-question grid navigator & review flags.',
              badge: 'Complete 500',
              badgeColor: AppColors.successLight,
              badgeTextColor: AppColors.success,
              isHighlight: true,
            ),

            const SizedBox(height: 14),
            Row(
              children: const [
                Icon(Icons.info_outline, size: 14, color: AppColors.textMuted),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'All modes feature instant verified explanations and citizen scoring.',
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required BuildContext context,
    required int count,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String badge,
    required Color badgeColor,
    required Color badgeTextColor,
    bool isHighlight = false,
  }) {
    return InkWell(
      onTap: () => Navigator.pop(context, count),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isHighlight
              ? AppColors.primaryTint.withValues(alpha: 0.3)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isHighlight ? AppColors.primary : AppColors.border,
            width: isHighlight ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
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
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
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
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
