import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'mongodb_service.dart';

class StorageService {
  /// Returns the PDF URL for Web rendering (assets or MongoDB GridFS stream)
  static String getPdfWebUrl(String relativePath) {
    final filename = relativePath.split('/').last;
    return 'assets/assets/pdfs/$filename';
  }

  /// Returns the MongoDB PDF stream URL from official database
  static String getMongoPdfUrl(String relativePath) {
    final filename = relativePath.split('/').last;
    return MongoDbService.getPdfUrl(filename);
  }

  /// Prepares an in-app PDF file for viewing.
  /// Works across all platforms without any hardcoded local PC paths.
  static Future<String?> getPdfFilePath(String relativePath) async {
    final filename = relativePath.split('/').last;

    if (kIsWeb) {
      return getPdfWebUrl(relativePath);
    }

    try {
      final dir = await getTemporaryDirectory();
      final targetFile = io.File('${dir.path}/$filename');

      if (await targetFile.exists()) {
        return targetFile.path;
      }

      // 1. Load from bundled app assets (works offline on any PC / Mobile device)
      try {
        final assetData = await rootBundle.load('assets/pdfs/$filename');
        final bytes = assetData.buffer.asUint8List();
        await targetFile.writeAsBytes(bytes, flush: true);
        return targetFile.path;
      } catch (_) {}

      // 2. Fetch from Official MongoDB GridFS Database
      try {
        final mongoUrl = MongoDbService.getPdfUrl(filename);
        final res = await http.get(Uri.parse(mongoUrl)).timeout(const Duration(seconds: 8));
        if (res.statusCode == 200 && res.bodyBytes.isNotEmpty) {
          await targetFile.writeAsBytes(res.bodyBytes, flush: true);
          return targetFile.path;
        }
      } catch (_) {}

      // 3. Fallback to relative local path if running from source
      final relativeFile = io.File(relativePath);
      if (await relativeFile.exists()) {
        final bytes = await relativeFile.readAsBytes();
        await targetFile.writeAsBytes(bytes, flush: true);
        return targetFile.path;
      }

      return null;
    } catch (e) {
      debugPrint('[StorageService] Error preparing PDF file: $e');
      return null;
    }
  }
}
