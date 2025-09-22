import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:restoguh_dicoding_fundamentl/providers/theme_provider.dart';
import 'package:restoguh_dicoding_fundamentl/screens/onboarding_screen.dart';
import 'package:restoguh_dicoding_fundamentl/screens/menu_screen.dart';
import 'package:restoguh_dicoding_fundamentl/theme/theme.dart';
// import 'package:restoguh_dicoding_fundamentl/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final seenOnboarding = prefs.getBool("seenOnboarding") ?? false;

  await initializeDateFormatting('id_ID', null);

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(seenOnboarding: seenOnboarding),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool seenOnboarding;

  const MyApp({super.key, required this.seenOnboarding});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Restaurant App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,
          initialRoute: seenOnboarding ? "/home" : "/",
          routes: {
            "/": (context) => const OnboardingScreen(),
            "/home": (context) => const MenuScreen(),
          },
        );
      },
    );
  }
}
