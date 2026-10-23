import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/app_theme.dart';
import 'screens/splash_screen.dart';
import 'services/auth_service.dart';
import 'services/data_repository.dart';
import 'services/firebase_service.dart';
import 'services/gemini_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (with resilient local fallback)
  await FirebaseService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => DataRepository()),
        ChangeNotifierProvider(create: (_) => GeminiService()),
      ],
      child: const JanGyanApp(),
    ),
  );
}

class JanGyanApp extends StatelessWidget {
  const JanGyanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JanGyan',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
