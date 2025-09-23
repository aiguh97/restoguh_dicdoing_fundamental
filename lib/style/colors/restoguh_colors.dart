import 'package:flutter/material.dart';

enum RestoguhColors {
  blue(
    name: "Blue",
    primaryColor: Colors.blue,
    secondaryColor: Color(0xFF1976D2),
  ),
  amber(
    name: "Green",
    primaryColor: Colors.amber,
    secondaryColor: Color.fromARGB(255, 244, 190, 28),
  ),
  green(
    name: "Green",
    primaryColor: Color(0xFF4CAF50),
    secondaryColor: Color(0xFF1F5F23),
  ),
  red(name: "Red", primaryColor: Colors.red, secondaryColor: Color(0xFFB71C1C));

  const RestoguhColors({
    required this.name,
    required this.primaryColor,
    required this.secondaryColor,
  });

  final String name;
  final Color primaryColor;
  final Color secondaryColor;
}
