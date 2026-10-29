import 'dart:io' as io;
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../core/app_colors.dart';
import '../models/quiz_attempt.dart';
import '../services/certificate_saver.dart';

/// Reusable High-Resolution JanGyan Citizen Certificate Dialog with Direct Download & Share.
class JanGyanCertificateDialog extends StatefulWidget {
  final String citizenName;
  final String categoryTitle;
  final int score;
  final int totalQuestions;
  final double accuracy;
  final String serialNumber;
  final DateTime issuedAt;
  final bool autoDownload;

  const JanGyanCertificateDialog({
    super.key,
    required this.citizenName,
    required this.categoryTitle,
    required this.score,
    required this.totalQuestions,
    required this.accuracy,
    required this.serialNumber,
    required this.issuedAt,
    this.autoDownload = false,
  });

  /// Static helper to display the certificate modal from any screen.
  static Future<void> show(
    BuildContext context, {
    required String citizenName,
    required String categoryTitle,
    required int score,
    required int totalQuestions,
    required double accuracy,
    required String serialNumber,
    DateTime? issuedAt,
    bool autoDownload = false,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => JanGyanCertificateDialog(
        citizenName: citizenName,
        categoryTitle: categoryTitle,
        score: score,
        totalQuestions: totalQuestions,
        accuracy: accuracy,
        serialNumber: serialNumber,
        issuedAt: issuedAt ?? DateTime.now(),
        autoDownload: autoDownload,
      ),
    );
  }

  /// Helper to display directly from a QuizAttempt.
  static Future<void> fromAttempt(
    BuildContext context, {
    required QuizAttempt attempt,
    required String citizenName,
    bool autoDownload = false,
  }) {
    final rawId = attempt.attemptId.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    final shortId = rawId.length >= 8
        ? rawId.substring(0, 8).toUpperCase()
        : 'CERT${DateTime.now().millisecondsSinceEpoch % 1000000}';
    final serial = 'JGYN-${attempt.timestamp.year}-$shortId';

    return show(
      context,
      citizenName: citizenName,
      categoryTitle: attempt.categoryTitle,
      score: attempt.score,
      totalQuestions: attempt.totalQuestions,
      accuracy: attempt.accuracy,
      serialNumber: serial,
      issuedAt: attempt.timestamp,
      autoDownload: autoDownload,
    );
  }

  @override
  State<JanGyanCertificateDialog> createState() => _JanGyanCertificateDialogState();
}

class _JanGyanCertificateDialogState extends State<JanGyanCertificateDialog> {
  final GlobalKey _certKey = GlobalKey();
  bool _isDownloading = false;
  bool _hasDownloaded = false;

  @override
  void initState() {
    super.initState();
    if (widget.autoDownload) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 350), () {
          if (mounted) _handleDownload();
        });
      });
    }
  }

  Future<Uint8List?> _captureCertificate() async {
    try {
      await WidgetsBinding.instance.endOfFrame;
      var boundary =
          _certKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        await Future.delayed(const Duration(milliseconds: 150));
        boundary = _certKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      }
      if (boundary == null) return null;
      if (boundary.debugNeedsPaint) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('[JanGyanCertificateDialog] Capture error: $e');
      return null;
    }
  }

  Future<void> _handleDownload() async {
    if (_isDownloading) return;
    setState(() => _isDownloading = true);
    try {
      final pngBytes = await _captureCertificate();
      if (pngBytes == null) {
        throw Exception('Failed to generate high-resolution certificate image. Please try again.');
      }

      final savedResult = await CertificateSaver.saveCertificate(
        pngBytes: pngBytes,
        title: widget.categoryTitle,
        serialNumber: widget.serialNumber,
      );

      if (savedResult == null) {
        throw Exception('Failed to save certificate to downloads.');
      }

      if (mounted) {
        setState(() {
          _isDownloading = false;
          _hasDownloaded = true;
        });

        final fileName = savedResult.split(RegExp(r"[/\\]")).last;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Certificate Downloaded Directly! 🎉',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      Text(
                        kIsWeb
                            ? 'Saved to browser Downloads ($fileName)'
                            : 'Saved to Downloads: $fileName',
                        style: const TextStyle(fontSize: 11, color: Colors.white70),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
            action: (!kIsWeb && io.Platform.isAndroid)
                ? SnackBarAction(
                    label: 'SHARE',
                    textColor: Colors.white,
                    onPressed: _handleShare,
                  )
                : null,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isDownloading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Download failed: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _handleShare() async {
    setState(() => _isDownloading = true);
    try {
      final pngBytes = await _captureCertificate();
      if (pngBytes != null) {
        await CertificateSaver.shareCertificate(
          pngBytes: pngBytes,
          title: widget.categoryTitle,
          serialNumber: widget.serialNumber,
        );
      }
    } finally {
      if (mounted) setState(() => _isDownloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateStr =
        '${widget.issuedAt.day.toString().padLeft(2, '0')}/${widget.issuedAt.month.toString().padLeft(2, '0')}/${widget.issuedAt.year}';

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
                              'for completing the official ${widget.categoryTitle} assessment with demonstrated proficiency in Indian civic laws and citizen responsibilities.',
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
                                'Score: ${widget.score}/${widget.totalQuestions} • Accuracy: ${widget.accuracy.toStringAsFixed(1)}%',
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
                                  'SERIAL NO: ${widget.serialNumber}',
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                    color: Color(0xFFB45309),
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

              // Action buttons (Direct Download & Share)
              Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _hasDownloaded
                            ? AppColors.success
                            : AppColors.primary,
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
                          : Icon(
                              _hasDownloaded
                                  ? Icons.check_circle_outline
                                  : Icons.file_download_outlined,
                              size: 20,
                            ),
                      label: Text(
                        _isDownloading
                            ? 'Downloading...'
                            : (_hasDownloaded
                                ? 'Downloaded (Download Again)'
                                : 'Download Certificate'),
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
