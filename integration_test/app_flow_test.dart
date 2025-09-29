import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:restoguh_dicoding_fundamentl/screens/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('full onboarding flow navigates to menu screen', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: OnboardingScreen(),
        routes: {
          "/home": (context) =>
              const Scaffold(body: Text("Home", key: Key("home_screen"))),
        },
      ),
    );

    await tester.pumpAndSettle();

    // Pastikan halaman pertama muncul
    expect(find.text("Nearby restaurants"), findsOneWidget);

    // Next page
    await tester.tap(find.byIcon(Icons.arrow_forward));
    await tester.pumpAndSettle();
    expect(find.text("Select the Favorites Menu"), findsOneWidget);

    // Next page
    await tester.tap(find.byIcon(Icons.arrow_forward));
    await tester.pumpAndSettle();
    expect(find.text("Good food at a cheap price"), findsOneWidget);

    // Finish
    await tester.tap(find.byIcon(Icons.check));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key("home_screen")), findsOneWidget);
  });
}
