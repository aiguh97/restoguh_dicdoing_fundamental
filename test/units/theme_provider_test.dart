import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restoguh_dicoding_fundamentl/providers/theme_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThemeProvider Unit Tests', () {
    late ThemeProvider provider;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      provider = ThemeProvider();
      await Future.delayed(
        const Duration(milliseconds: 100),
      ); // wait _loadThemePreference
    });

    test('default theme is false (light)', () {
      expect(provider.isDarkMode, false);
    });

    test('toggleTheme updates value', () async {
      await provider.toggleTheme(true);
      expect(provider.isDarkMode, true);
    });
  });
}
