import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../models/quiz_attempt.dart';
import '../services/auth_service.dart';
import '../services/certificate_saver.dart';
import '../widgets/assessment_mode_dialog.dart';
import 'home_screen.dart';
import 'quiz_screen.dart';

class QuizResultsScreen extends StatelessWidget {
  final QuizAttempt attempt;
  final QuizSolutionMode solutionMode;

  const QuizResultsScreen({
    super.key,
    required this.attempt,
    this.solutionMode = QuizSolutionMode.instant,
  });

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
      builder: (ctx) => _CertificateDialog(
        attempt: attempt,
        citizenName: citizenName,
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

            if (solutionMode == QuizSolutionMode.afterTest) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryTint,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.assignment_turned_in,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'After Test Result: Complete test solutions revealed below with correct answers and official explanations.',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],

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
                    onPressed: () async {
                      final config = await AssessmentModeDialog.show(
                        context,
                        categoryTitle: attempt.categoryTitle,
                        initialCount: attempt.totalQuestions,
                        initialMode: solutionMode,
                      );
                      if (config != null && context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QuizScreen(
                              categoryId: attempt.categoryId,
                              categoryTitle: attempt.categoryTitle,
                              questionCount: config.questionCount,
                              solutionMode: config.solutionMode,
                            ),
                          ),
                        );
                      }
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

class _CertificateDialog extends StatefulWidget {
  final QuizAttempt attempt;
  final String citizenName;

  const _CertificateDialog({
    required this.attempt,
    required this.citizenName,
  });

  @override
  State<_CertificateDialog> createState() => _CertificateDialogState();
}

class _CertificateDialogState extends State<_CertificateDialog> {
  final GlobalKey _certKey = GlobalKey();
  bool _isDownloading = false;

  Future<Uint8List?> _captureCertificate() async {
    try {
      final boundary =
          _certKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('[_CertificateDialog] Capture error: $e');
      return null;
    }
  }

  Future<void> _handleDownload() async {
    setState(() => _isDownloading = true);
    try {
      final pngBytes = await _captureCertificate();
      if (pngBytes == null) throw Exception('Failed to generate high-resolution certificate image');

      final savedPath = await CertificateSaver.saveCertificate(
        pngBytes: pngBytes,
        title: widget.attempt.categoryTitle,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    savedPath != null
                        ? 'Certificate saved to Downloads: ${savedPath.split(RegExp(r"[/\\]")).last}'
                        : 'Certificate downloaded successfully!',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Download failed: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isDownloading = false);
    }
  }

  Future<void> _handleShare() async {
    setState(() => _isDownloading = true);
    try {
      final pngBytes = await _captureCertificate();
      if (pngBytes != null) {
        await CertificateSaver.shareCertificate(
          pngBytes: pngBytes,
          title: widget.attempt.categoryTitle,
        );
      }
    } finally {
      if (mounted) setState(() => _isDownloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final certId = widget.attempt.attemptId.length >= 8
        ? widget.attempt.attemptId.substring(0, 8).toUpperCase()
        : 'JG${DateTime.now().millisecondsSinceEpoch % 100000}';
    final dateStr =
        '${widget.attempt.timestamp.day.toString().padLeft(2, '0')}/${widget.attempt.timestamp.month.toString().padLeft(2, '0')}/${widget.attempt.timestamp.year}';

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.workspace_premium_rounded,
                          color: Color(0xFFD4AF37), size: 26),
                      SizedBox(width: 8),
                      Text(
                        'Verified Citizen Certificate',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Captured High-Res Certificate Widget
              RepaintBoundary(
                key: _certKey,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCFDFE),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFD4AF37), width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Sub-border inside
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.35),
                              width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            // Logo and Title
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/logo.png',
                                  width: 44,
                                  height: 44,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(width: 10),
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'JANGYAN 🇮🇳',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.primaryDark,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                    Text(
                                      'National Civic Literacy Initiative',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'CERTIFICATE OF CIVIC MASTERY',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                                color: Color(0xFFB45309),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'This is proudly presented to',
                              style: TextStyle(
                                fontSize: 11,
                                fontStyle: FontStyle.italic,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.citizenName.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: AppColors.primaryDark,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'for completing the official ${widget.attempt.categoryTitle} assessment with demonstrated proficiency in Indian civic laws and citizen responsibilities.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 11,
                                height: 1.35,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Score & Accuracy Pill
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primaryTint,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: AppColors.primary.withValues(alpha: 0.3)),
                              ),
                              child: Text(
                                'Score: ${widget.attempt.score}/${widget.attempt.totalQuestions} • Accuracy: ${widget.attempt.accuracy.toStringAsFixed(1)}%',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            // Verification Footer
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Date: $dateStr',
                                  style: const TextStyle(
                                    fontSize: 9,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                                Text(
                                  'ID: JAN-GYAN-$certId',
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.success,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Action buttons (Direct Download without Screenshot!)
              Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: _isDownloading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.file_download_outlined, size: 20),
                      label: Text(
                        _isDownloading ? 'Saving...' : 'Download Certificate',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: _isDownloading ? null : _handleDownload,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 4,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryDark,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.share_outlined, size: 18),
                      label: const Text(
                        'Share',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: _isDownloading ? null : _handleShare,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
