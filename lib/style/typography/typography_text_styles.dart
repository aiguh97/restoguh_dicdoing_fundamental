import 'package:flutter/material.dart';

class RestoguhTextStyles {
  // Font families
  static const String _geometr = 'Geometr415';
  static const String _gillSans = 'GillSansMT';
  static const String _sfui = 'SFUIDisplay';

  // Display styles (untuk judul besar)
  static const TextStyle displayLarge = TextStyle(
    fontFamily: _gillSans,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: _gillSans,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: _gillSans,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  // Headline styles
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: _geometr,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: _geometr,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: _geometr,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  // Title styles
  static const TextStyle titleLarge = TextStyle(
    fontFamily: _geometr,
    fontSize: 22,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: _geometr,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.2,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: _geometr,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.2,
  );

  // Body styles
  static const TextStyle bodyLargeBold = TextStyle(
    fontFamily: _geometr,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    height: 1.5,
  );

  static const TextStyle bodyLargeMedium = TextStyle(
    fontFamily: _geometr,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  static const TextStyle bodyLargeRegular = TextStyle(
    fontFamily: _geometr,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // Label styles
  static const TextStyle labelLarge = TextStyle(
    fontFamily: _geometr,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.2,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: _geometr,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.2,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: _geometr,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.2,
  );

  // Address
  static const TextStyle address = TextStyle(
    fontFamily: _geometr,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  // ReadMoreInline
  static const TextStyle readMore = TextStyle(
    fontFamily: _sfui,
    color: Color.fromARGB(255, 61, 61, 61),
    letterSpacing: 1.45,
  );

  static const TextStyle readMoreMore = TextStyle(
    fontFamily: _sfui,
    color: Color.fromARGB(255, 66, 189, 74),
    fontWeight: FontWeight.w700,
  );
}
