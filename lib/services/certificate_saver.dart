import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class CertificateSaver {
  /// Saves the rendered PNG certificate directly to device storage.
  /// Returns the saved absolute file path on mobile or a success message on Web.
  static Future<String?> saveCertificate({
    required Uint8List pngBytes,
    required String title,
  }) async {
    final sanitizedTitle = title.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
    final filename =
        'JanGyan_Certificate_${sanitizedTitle}_${DateTime.now().millisecondsSinceEpoch}.png';

    if (kIsWeb) {
      try {
        final uri = Uri.dataFromBytes(pngBytes, mimeType: 'image/png');
        await launchUrl(uri);
        return 'Certificate downloaded in browser!';
      } catch (e) {
        debugPrint('[CertificateSaver] Web download notice: $e');
        return null;
      }
    }

    try {
      // 1. Android public Download folder (/storage/emulated/0/Download)
      if (io.Platform.isAndroid) {
        final publicDownload = io.Directory('/storage/emulated/0/Download');
        if (await publicDownload.exists()) {
          final target = io.File('${publicDownload.path}/$filename');
          await target.writeAsBytes(pngBytes, flush: true);
          return target.path;
        }
      }

      // 2. Standard downloads directory
      final downloadsDir = await getDownloadsDirectory();
      if (downloadsDir != null) {
        final target = io.File('${downloadsDir.path}/$filename');
        await target.writeAsBytes(pngBytes, flush: true);
        return target.path;
      }

      // 3. Application Documents Directory fallback
      final appDir = await getApplicationDocumentsDirectory();
      final target = io.File('${appDir.path}/$filename');
      await target.writeAsBytes(pngBytes, flush: true);
      return target.path;
    } catch (e) {
      debugPrint('[CertificateSaver] Error saving certificate: $e');
      return null;
    }
  }

  /// Opens the system share sheet with the rendered Certificate PNG.
  static Future<void> shareCertificate({
    required Uint8List pngBytes,
    required String title,
  }) async {
    final sanitizedTitle = title.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
    final filename = 'JanGyan_Certificate_$sanitizedTitle.png';

    if (kIsWeb) {
      final uri = Uri.dataFromBytes(pngBytes, mimeType: 'image/png');
      await launchUrl(uri);
      return;
    }

    try {
      final tempDir = await getTemporaryDirectory();
      final file = io.File('${tempDir.path}/$filename');
      await file.writeAsBytes(pngBytes, flush: true);
      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'image/png', name: filename)],
        text:
            'I proudly earned the JanGyan Official Citizen Certificate in $title! 🇮🇳 Check your civic literacy on JanGyan.',
      );
    } catch (e) {
      debugPrint('[CertificateSaver] Error sharing certificate: $e');
    }
  }
}
