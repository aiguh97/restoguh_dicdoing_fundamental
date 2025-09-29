import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:restoguh_dicoding_fundamentl/providers/menu_provider.dart';
import 'package:restoguh_dicoding_fundamentl/screens/menu_screen.dart';

// Fake screens untuk isolasi test
class TestHomeScreen extends StatelessWidget {
  const TestHomeScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Text('Home', key: Key('home_screen')));
}

class TestFavoriteScreen extends StatelessWidget {
  const TestFavoriteScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Text('Favorite', key: Key('favorite_screen')));
}

class TestSettingsScreen extends StatelessWidget {
  const TestSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Text('Settings', key: Key('settings_screen')));
}

void main() {
  Widget createTestableWidget({int currentIndex = 0}) {
    final provider = MenuProvider();
    provider.setIndex(currentIndex);

    return ChangeNotifierProvider<MenuProvider>.value(
      value: provider,
      child: MaterialApp(
        home: MenuScreen(
          screens: const [
            TestHomeScreen(),
            TestFavoriteScreen(),
            TestSettingsScreen(),
          ],
        ),
      ),
    );
  }

  group('MenuScreen Widget Tests', () {
    testWidgets('renders bottom navigation items', (tester) async {
      await tester.pumpWidget(createTestableWidget());
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('shows home screen by default', (tester) async {
      await tester.pumpWidget(createTestableWidget(currentIndex: 0));
      expect(find.byKey(const Key('home_screen')), findsOneWidget);
      expect(find.byKey(const Key('favorite_screen')), findsNothing);
      expect(find.byKey(const Key('settings_screen')), findsNothing);
    });

    testWidgets('shows favorite screen when index=1', (tester) async {
      await tester.pumpWidget(createTestableWidget(currentIndex: 1));
      expect(find.byKey(const Key('favorite_screen')), findsOneWidget);
    });

    testWidgets('navigates when tapping bottom navigation', (tester) async {
      final provider = MenuProvider();
      await tester.pumpWidget(
        ChangeNotifierProvider<MenuProvider>.value(
          value: provider,
          child: MaterialApp(
            home: MenuScreen(
              screens: const [
                TestHomeScreen(),
                TestFavoriteScreen(),
                TestSettingsScreen(),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.favorite));
      await tester.pump();
      expect(provider.currentIndex, 1);

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pump();
      expect(provider.currentIndex, 2);
    });
  });
}
