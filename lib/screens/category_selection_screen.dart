import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../services/data_repository.dart';
import 'knowledge_hub_screen.dart';
import 'quiz_screen.dart';
import '../widgets/assessment_mode_dialog.dart';

class CategorySelectionScreen extends StatelessWidget {
  final bool isRootTab;
  const CategorySelectionScreen({super.key, this.isRootTab = false});

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'security':
        return Icons.security;
      case 'account_balance':
        return Icons.account_balance;
      case 'traffic':
        return Icons.traffic;
      case 'local_hospital':
        return Icons.local_hospital;
      case 'payments':
        return Icons.payments;
      case 'eco':
        return Icons.eco;
      default:
        return Icons.book;
    }
  }

  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<DataRepository>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('6 Educational Domains'),
        leading: isRootTab ? null : const BackButton(),
      ),
      body: repo.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: repo.categories.length,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final cat = repo.categories[index];
                final color = AppColors.getCategoryColor(cat.id);

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                _getIconData(cat.iconName),
                                color: color,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Domain 0${index + 1}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: color,
                                    ),
                                  ),
                                  Text(
                                    cat.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          cat.tagline,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            _buildInfoPill(
                              Icons.menu_book,
                              '${cat.moduleCount} Modules',
                            ),
                            const SizedBox(width: 8),
                            _buildInfoPill(Icons.help_outline, '500 MCQs'),
                            const SizedBox(width: 8),
                            _buildInfoPill(Icons.picture_as_pdf, '11 PDFs'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(height: 1, color: AppColors.border),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.library_books, size: 16),
                                label: const Text(
                                  '10 Modules',
                                  style: TextStyle(fontSize: 13),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          KnowledgeHubScreen(category: cat),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.play_arrow, size: 16),
                                label: const Text(
                                  'Take Quiz',
                                  style: TextStyle(fontSize: 13),
                                ),
                                onPressed: () async {
                                  final config = await AssessmentModeDialog.show(
                                    context,
                                    categoryTitle: cat.title,
                                  );
                                  if (config != null && context.mounted) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => QuizScreen(
                                          categoryId: cat.id,
                                          categoryTitle: cat.title,
                                          questionCount: config.questionCount,
                                          solutionMode: config.solutionMode,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildInfoPill(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.textMuted),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
