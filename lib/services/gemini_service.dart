import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../core/app_config.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({required this.text, required this.isUser, DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() => {
    'text': text,
    'isUser': isUser,
    'timestamp': timestamp.toIso8601String(),
  };

  factory ChatMessage.fromMap(Map<String, dynamic> map) => ChatMessage(
    text: map['text'] as String? ?? '',
    isUser: map['isUser'] as bool? ?? false,
    timestamp: map['timestamp'] != null
        ? DateTime.tryParse(map['timestamp'].toString()) ?? DateTime.now()
        : DateTime.now(),
  );
}

class GeminiService extends ChangeNotifier {
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _error;
  String _apiKey = '';

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get apiKey => _apiKey;

  static const String _geminiKeyPrefs = 'jangyan_gemini_api_key';

  GeminiService() {
    _loadKeyAndInitialMessage();
  }

  Future<void> _loadKeyAndInitialMessage() async {
    final prefs = await SharedPreferences.getInstance();
    _apiKey = prefs.getString(_geminiKeyPrefs) ?? '';
    if (_apiKey.isEmpty && AppConfig.geminiApiKey.isNotEmpty) {
      _apiKey = AppConfig.geminiApiKey;
    }


    // Welcome message from JanGyan AI
    _messages.add(
      ChatMessage(
        text:
            "Namaste! 🙏 I am your JanGyan Citizen AI Assistant.\n\n"
            "I can answer your questions across all 6 civic domains:\n"
            "• Cyber Safety & Reporting Frauds (Helpline 1930)\n"
            "• Government Schemes, DigiLocker & Citizen Rights\n"
            "• Road Rules, Good Samaritan Law & Golden Hour Care\n"
            "• Emergency 112, First Aid & Ayushman Bharat\n"
            "• Safe UPI Payments & Budgeting\n"
            "• Waste Segregation & Environmental Rules\n\n"
            "How can I assist you today?",
        isUser: false,
      ),
    );
    notifyListeners();
  }

  Future<void> setApiKey(String key) async {
    _apiKey = key.trim();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_geminiKeyPrefs, _apiKey);
    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(text: text.trim(), isUser: true);
    _messages.add(userMessage);
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      String reply;

      if (_apiKey.isNotEmpty) {
        try {
          reply = await _callGeminiApi(text.trim());
        } catch (apiErr) {
          debugPrint('[GeminiService] Gemini call notice: $apiErr. Using offline Civic Knowledge fallback.');
          reply = _resolveCivicKnowledge(text.trim());
        }
      } else {
        reply = _resolveCivicKnowledge(text.trim());
      }

      _messages.add(ChatMessage(text: reply, isUser: false));
    } catch (e) {
      final fallbackReply = _resolveCivicKnowledge(text.trim());
      _messages.add(ChatMessage(text: fallbackReply, isUser: false));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> _callGeminiApi(String prompt) async {
    final models = [
      AppConfig.geminiModel,
      AppConfig.geminiFallbackModel,
      AppConfig.geminiTertiaryModel,
    ];
    String? lastError;

    final contents = [
      {
        'role': 'user',
        'parts': [
          {
            'text':
                'System Prompt: You are JanGyan, the official civic literacy AI assistant for Indian citizens. '
                'Provide polite, accurate, concise, citizen-friendly advice citing official Indian laws '
                '(e.g., IT Act, DPDP Act 2023, Motor Vehicles Act 2019, RTI Act 2005) and emergency helplines '
                '(112 Unified Emergency, 1930 Cyber Fraud Helpline). Answer in clear points.',
          },
        ],
      },
      ..._messages.map(
        (m) => {
          'role': m.isUser ? 'user' : 'model',
          'parts': [
            {'text': m.text},
          ],
        },
      ),
      {
        'role': 'user',
        'parts': [
          {'text': prompt},
        ],
      },
    ];

    for (final model in models) {
      try {
        final url = Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$_apiKey',
        );

        final response = await http
            .post(
              url,
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({'contents': contents}),
            )
            .timeout(const Duration(seconds: 25));

        if (response.statusCode == 200) {
          final json = jsonDecode(response.body);
          final candidates = json['candidates'] as List<dynamic>?;
          if (candidates != null && candidates.isNotEmpty) {
            final content = candidates[0]['content'];
            final parts = content['parts'] as List<dynamic>?;
            if (parts != null && parts.isNotEmpty) {
              return parts[0]['text'] as String;
            }
          }
          throw 'Empty response payload from Gemini API.';
        } else {
          final errJson = jsonDecode(response.body);
          final message =
              errJson['error']?['message'] ?? 'HTTP ${response.statusCode}';
          lastError = message;
          // Continue to next model if 404 or 503
          continue;
        }
      } catch (e) {
        lastError = e.toString();
      }
    }
    throw lastError ?? 'Failed to communicate with Gemini AI service.';
  }


  String _resolveCivicKnowledge(String query) {
    final q = query.toLowerCase();

    if (q.contains('1930') ||
        q.contains('cyber') ||
        q.contains('fraud') ||
        q.contains('scam') ||
        q.contains('phish')) {
      return "🛡️ **Cyber Crime & Online Fraud Guidance:**\n\n"
          "1. **National Cybercrime Helpline:** Immediately call **1930** if you have lost money to an online fraud.\n"
          "2. **The Golden Window:** Report within the first **2–3 hours** so police and banks can freeze the fraudulent transactions.\n"
          "3. **Official Portal:** Register formal evidence and complaints on **cybercrime.gov.in**.\n"
          "4. **Golden Rule:** Never share an OTP, UPI PIN, or CVV. Entering a UPI PIN is strictly for *deducting* money from your account, never for receiving money!";
    }

    if (q.contains('112') ||
        q.contains('emergency') ||
        q.contains('police') ||
        q.contains('ambulance')) {
      return "🚨 **Emergency Response & Dial 112:**\n\n"
          "• **112** is India's all-in-one Single Emergency Helpline connecting you to Police, Fire, and Ambulance services across all states.\n"
          "• **National Emergency Numbers:**\n"
          "  - **112:** Unified All Emergencies\n"
          "  - **108:** Medical Ambulance\n"
          "  - **1091:** Women Helpline\n"
          "  - **1098:** Childline India\n"
          "  - **14444:** Financial Fraud Redressal";
    }

    if (q.contains('cpr') ||
        q.contains('heart') ||
        q.contains('first aid') ||
        q.contains('choking')) {
      return "❤️ **First Aid & Hands-Only CPR Protocol:**\n\n"
          "1. **Check Responsiveness:** Tap the shoulders and ask loudly, 'Are you okay?'. Check for normal breathing.\n"
          "2. **Call for Help:** Immediately direct someone to call **112** or **108**.\n"
          "3. **Chest Compressions:** Place the heel of one hand in the center of the chest, interlock the other hand on top.\n"
          "4. **Rate & Depth:** Push hard and fast at **100–120 compressions per minute** (to the rhythm of 'Stayin Alive') at a depth of 2 inches (5 cm).\n"
          "5. Continue until emergency medical services arrive.";
    }

    if (q.contains('good samaritan') ||
        q.contains('accident') ||
        q.contains('golden hour') ||
        q.contains('traffic') ||
        q.contains('helmet')) {
      return "🚦 **Road Safety & Good Samaritan Law:**\n\n"
          "• **Section 134A (Motor Vehicles Act):** Legally protects any Good Samaritan who assists an accident victim from civil or criminal liability, police harassment, and forced disclosure.\n"
          "• **Golden Hour Care:** The first 60 minutes after severe traumatic injury where immediate medical care maximizes survival.\n"
          "• **Cashless Treatment Scheme 2025:** Provides up to ₹1.5 lakh cashless treatment for road accident victims during the first 7 days at empanelled trauma hospitals.";
    }

    if (q.contains('digilocker') ||
        q.contains('rti') ||
        q.contains('constitution') ||
        q.contains('scheme') ||
        q.contains('pm-jay')) {
      return "🏛️ **Citizen Rights & Digital Services:**\n\n"
          "• **DigiLocker Validity:** Under Rule 9A of the IT Rules 2016, digital certificates and driving licenses shown from DigiLocker have the exact same legal validity as physical documents.\n"
          "• **RTI Act 2005:** Citizens can request public documents with a mandatory response timeline of 30 days (48 hours for life and liberty issues).\n"
          "• **Ayushman Bharat (PM-JAY):** Provides ₹5 Lakh cashless health cover per eligible family per year at public and private network hospitals.";
    }

    if (q.contains('budget') ||
        q.contains('50-30-20') ||
        q.contains('cibil') ||
        q.contains('upi') ||
        q.contains('invest')) {
      return "💰 **Financial Literacy Essentials:**\n\n"
          "• **50-30-20 Rule:** 50% for Needs, 30% for Wants, 20% for Savings, Emergency Funds, and Debt reduction.\n"
          "• **Emergency Fund:** Keep 3–6 months of mandatory living expenses in liquid deposits.\n"
          "• **Credit Score (CIBIL):** Maintain 750+ for optimal loan terms.\n"
          "• **Ponzi Warning:** Any investment guaranteeing '15-20% monthly returns' is an illegal, unregulated scam. Always check SEBI/RBI registration.";
    }

    return "JanGyan is designed to help every Indian citizen master the 6 pillars of civic awareness:\n\n"
        "1. Cyber Safety (OTP, Phishing, Helpline 1930)\n"
        "2. Government Services (DigiLocker, RTI, Constitution)\n"
        "3. Road Safety (Sec 134A, Golden Hour, 112)\n"
        "4. Health & Emergency (CPR, Ayushman Bharat)\n"
        "5. Financial Literacy (UPI, 50-30-20, CIBIL)\n"
        "6. Environment (Waste Segregation, AQI, Green Habits)\n\n"
        "Ask me anything specific about any of these domains, or enter your Gemini API Key in the top bar to enable dynamic generative AI responses!";
  }

  void clearChat() {
    _messages.clear();
    _loadKeyAndInitialMessage();
  }
}
