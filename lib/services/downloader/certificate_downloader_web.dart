// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/foundation.dart';

/// Downloads the certificate file directly to the user's browser Downloads directory.
Future<String?> downloadCertificateFile({
  required Uint8List bytes,
  required String filename,
}) async {
  try {
    // 1. Primary method: Blob Object URL + invisible HTML anchor tag
    final blob = html.Blob([bytes], 'image/png');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', filename)
      ..style.display = 'none';

    html.document.body?.children.add(anchor);
    anchor.click();
    html.document.body?.children.remove(anchor);

    // Keep object URL active briefly to ensure browser stream finishes
    Future.delayed(const Duration(seconds: 4), () {
      try {
        html.Url.revokeObjectUrl(url);
      } catch (_) {}
    });

    debugPrint('[CertificateDownloaderWeb] Triggered direct browser download: $filename');
    return filename;
  } catch (e) {
    debugPrint('[CertificateDownloaderWeb] Blob download notice: $e');
    try {
      // 2. Secondary fallback: Base64 data URI anchor
      final base64String = base64Encode(bytes);
      final anchor = html.AnchorElement(
        href: 'data:image/png;base64,$base64String',
      )
        ..setAttribute('download', filename)
        ..style.display = 'none';

      html.document.body?.children.add(anchor);
      anchor.click();
      html.document.body?.children.remove(anchor);
      return filename;
    } catch (e2) {
      debugPrint('[CertificateDownloaderWeb] Base64 download error: $e2');
      return null;
    }
  }
}
