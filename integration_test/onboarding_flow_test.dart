// integration_test/onboarding_flow_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:restoguh_dicoding_fundamentl/main.dart';
import 'package:restoguh_dicoding_fundamentl/providers/onboarding_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Full Onboarding Flow', () {
    setUp(() async {
      // Reset SharedPreferences
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('tapping Skip navigates to /home', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<OnboardingProvider>(
          create: (_) => OnboardingProvider(),
          child: MyApp(seenOnboarding: false),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Nearby restaurants'), findsOneWidget);

      // Tap Skip
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();

      // Should navigate to /home
      expect(find.text('Menu'), findsOneWidget);
    });

    testWidgets('tapping Next until last page then Finish', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<OnboardingProvider>(
          create: (_) => OnboardingProvider(),
          child: MyApp(seenOnboarding: false),
        ),
      );

      await tester.pumpAndSettle();

      // Tap Next button until last page
      final nextButton = find.byIcon(Icons.arrow_forward);
      expect(nextButton, findsOneWidget);

      // First page -> Second page
      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      expect(find.text('Select the Favorites Menu'), findsOneWidget);

      // Second page -> Third page
      await tester.tap(nextButton);
      await tester.pumpAndSettle();
      expect(find.text('Good food at a cheap price'), findsOneWidget);

      // Last page -> Finish (Check icon is check)
      final finishButton = find.byIcon(Icons.check);
      expect(finishButton, findsOneWidget);

      await tester.tap(finishButton);
      await tester.pumpAndSettle();

      // Should navigate to /home
      expect(find.text('Menu'), findsOneWidget);
    });
  });
}
