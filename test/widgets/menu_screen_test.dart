import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:restoguh_dicoding_fundamentl/screens/menu_screen.dart';
import 'package:restoguh_dicoding_fundamentl/providers/menu_provider.dart';

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

  testWidgets('renders home screen by default', (tester) async {
    await tester.pumpWidget(createTestableWidget());
    expect(find.byKey(const Key('home_screen')), findsOneWidget);
  });
}
