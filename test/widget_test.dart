import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:jangyan/main.dart';
import 'package:jangyan/services/auth_service.dart';
import 'package:jangyan/services/data_repository.dart';
import 'package:jangyan/services/gemini_service.dart';

void main() {
  testWidgets('JanGyan app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthService()),
          ChangeNotifierProvider(create: (_) => DataRepository()),
          ChangeNotifierProvider(create: (_) => GeminiService()),
        ],
        child: const JanGyanApp(),
      ),
    );

    // Verify app renders with title and tagline
    expect(find.text('JanGyan'), findsOneWidget);
    expect(find.text('Learn Without Limits.'), findsOneWidget);

    // Pump past splash timer
    await tester.pump(const Duration(milliseconds: 2500));
    await tester.pump();
  });
}
