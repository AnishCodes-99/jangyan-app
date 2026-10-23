import 'app_secrets.dart';

class AppConfig {
  /// Priority order:
  /// 1. `--dart-define=GEMINI_API_KEY=...` or `--dart-define-from-file=.env`
  /// 2. Local gitignored `AppSecrets.defaultGeminiApiKey`
  static String get geminiApiKey {
    const envKey = String.fromEnvironment('GEMINI_API_KEY');
    if (envKey.isNotEmpty) {
      return envKey;
    }
    return AppSecrets.defaultGeminiApiKey;
  }

  /// Official active Gemini model endpoint (Verified live with user key)
  static const String geminiModel = 'gemini-3.5-flash';
  static const String geminiFallbackModel = 'gemini-flash-latest';
  static const String geminiTertiaryModel = 'gemini-flash-lite-latest';
}
