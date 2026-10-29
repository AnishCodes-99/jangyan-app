import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Saves the certificate file directly on Android/iOS/Desktop storage.
Future<String?> downloadCertificateFile({
  required Uint8List bytes,
  required String filename,
}) async {
  // Strategy 1: Public Download folder on Android (/storage/emulated/0/Download)
  if (io.Platform.isAndroid) {
    try {
      final publicDownload = io.Directory('/storage/emulated/0/Download');
      if (await publicDownload.exists()) {
        final target = io.File('${publicDownload.path}/$filename');
        await target.writeAsBytes(bytes, flush: true);
        if (await target.exists()) {
          debugPrint('[CertificateDownloaderIO] Saved to public Download folder: ${target.path}');
          return target.path;
        }
      }
    } catch (e) {
      debugPrint('[CertificateDownloaderIO] Public Download folder notice (scoped storage): $e');
    }
  }

  // Strategy 2: App external downloads directory on Android (accessible without scoped storage restrictions)
  try {
    final extDownloads = await getExternalStorageDirectories(type: StorageDirectory.downloads);
    if (extDownloads != null && extDownloads.isNotEmpty) {
      for (final dir in extDownloads) {
        try {
          if (!await dir.exists()) {
            await dir.create(recursive: true);
          }
          final target = io.File('${dir.path}/$filename');
          await target.writeAsBytes(bytes, flush: true);
          if (await target.exists()) {
            debugPrint('[CertificateDownloaderIO] Saved to external storage downloads: ${target.path}');
            return target.path;
          }
        } catch (dirErr) {
          debugPrint('[CertificateDownloaderIO] Error saving in dir ${dir.path}: $dirErr');
        }
      }
    }
  } catch (e) {
    debugPrint('[CertificateDownloaderIO] External storage downloads notice: $e');
  }

  // Strategy 3: Standard OS Downloads directory (Windows, macOS, Linux, and Android when supported)
  try {
    final downloadsDir = await getDownloadsDirectory();
    if (downloadsDir != null) {
      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }
      final target = io.File('${downloadsDir.path}/$filename');
      await target.writeAsBytes(bytes, flush: true);
      if (await target.exists()) {
        debugPrint('[CertificateDownloaderIO] Saved to downloads directory: ${target.path}');
        return target.path;
      }
    }
  } catch (e) {
    debugPrint('[CertificateDownloaderIO] Standard downloads directory notice: $e');
  }

  // Strategy 4: External storage directory (Android)
  try {
    final extDir = await getExternalStorageDirectory();
    if (extDir != null) {
      final downloadSub = io.Directory('${extDir.path}/Download');
      if (!await downloadSub.exists()) {
        await downloadSub.create(recursive: true);
      }
      final target = io.File('${downloadSub.path}/$filename');
      await target.writeAsBytes(bytes, flush: true);
      if (await target.exists()) {
        debugPrint('[CertificateDownloaderIO] Saved to extDir/Download: ${target.path}');
        return target.path;
      }
    }
  } catch (e) {
    debugPrint('[CertificateDownloaderIO] External directory notice: $e');
  }

  // Strategy 5: Application Documents Directory (Universal fallback on all platforms)
  try {
    final appDir = await getApplicationDocumentsDirectory();
    final target = io.File('${appDir.path}/$filename');
    await target.writeAsBytes(bytes, flush: true);
    if (await target.exists()) {
      debugPrint('[CertificateDownloaderIO] Saved to application documents: ${target.path}');
      return target.path;
    }
  } catch (e) {
    debugPrint('[CertificateDownloaderIO] Application documents directory notice: $e');
  }

  return null;
}
