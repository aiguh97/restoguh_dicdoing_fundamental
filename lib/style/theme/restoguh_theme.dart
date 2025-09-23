import 'package:flutter/material.dart';
import 'package:restoguh_dicoding_fundamentl/style/typography/typography_text_styles.dart';
import "../colors/restoguh_colors.dart";

class RestoguhTheme {
  /// Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      colorSchemeSeed: RestoguhColors.green.secondaryColor,
      brightness: Brightness.light,
      textTheme: _textTheme,
      useMaterial3: true,
      appBarTheme: _appBarTheme,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: RestoguhColors.blue.primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  /// Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      colorSchemeSeed: RestoguhColors.blue.primaryColor,
      brightness: Brightness.dark,
      textTheme: _textTheme,
      useMaterial3: true,
      appBarTheme: _appBarTheme,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: RestoguhColors.green.secondaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  /// TextTheme
  static TextTheme get _textTheme {
    return TextTheme(
      displayLarge: RestoguhTextStyles.displayLarge,
      displayMedium: RestoguhTextStyles.displayMedium,
      displaySmall: RestoguhTextStyles.displaySmall,
      headlineLarge: RestoguhTextStyles.headlineLarge,
      headlineMedium: RestoguhTextStyles.headlineMedium,
      headlineSmall: RestoguhTextStyles.headlineSmall,
      titleLarge: RestoguhTextStyles.titleLarge,
      titleMedium: RestoguhTextStyles.titleMedium,
      titleSmall: RestoguhTextStyles.titleSmall,
      bodyLarge: RestoguhTextStyles.bodyLargeBold,
      bodyMedium: RestoguhTextStyles.bodyLargeMedium,
      bodySmall: RestoguhTextStyles.bodyLargeRegular,
      labelLarge: RestoguhTextStyles.labelLarge,
      labelMedium: RestoguhTextStyles.labelMedium,
      labelSmall: RestoguhTextStyles.labelSmall,
    );
  }

  /// AppBarTheme
  static AppBarTheme get _appBarTheme {
    return AppBarTheme(
      toolbarTextStyle: RestoguhTextStyles.titleLarge,
      titleTextStyle: RestoguhTextStyles.titleLarge.copyWith(
        color: Colors.white,
      ),

      backgroundColor: RestoguhColors.green.secondaryColor,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
    );
  }
}
