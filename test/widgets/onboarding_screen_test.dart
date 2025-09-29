import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:restoguh_dicoding_fundamentl/screens/onboarding_screen.dart';
import 'package:restoguh_dicoding_fundamentl/providers/onboarding_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    // Mock SharedPreferences agar tidak error
    SharedPreferences.setMockInitialValues({});
  });

  Widget createWidgetUnderTest() => ChangeNotifierProvider<OnboardingProvider>(
    create: (_) => OnboardingProvider(),
    child: MaterialApp(
      routes: {
        "/home": (context) =>
            const Scaffold(body: Text("Home", key: Key("home_screen"))),
      },
      home: OnboardingScreen(),
    ),
  );

  testWidgets('renders first page by default', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.text('Nearby restaurants'), findsOneWidget);
  });

  testWidgets('tapping next moves page', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.tap(find.byIcon(Icons.arrow_forward));
    await tester.pumpAndSettle();
    expect(find.text('Select the Favorites Menu'), findsOneWidget);
  });

  testWidgets('tapping Skip navigates to /home', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    // Cek apakah Home screen muncul
    expect(find.byKey(const Key("home_screen")), findsOneWidget);
    expect(find.text("Home"), findsOneWidget);
  });
}
