import 'package:flutter/material.dart';

class AppTypography {
  // Заголовки
  static const TextStyle h1 = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    height: 1.2,
  );
  
  static const TextStyle h2 = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
    height: 1.3,
  );
  
  static const TextStyle h3 = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.0,
    height: 1.4,
  );
  
  // Текст
  static const TextStyle body1 = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.15,
    height: 1.5,
  );
  
  static const TextStyle body2 = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.25,
    height: 1.4,
  );
  
  // Кнопки
  static const TextStyle button = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.25,
    height: 1.0,
  );
  
  // Підписи
  static const TextStyle caption = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.4,
    height: 1.3,
  );
  
  // Підказки
  static const TextStyle overline = TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.normal,
    letterSpacing: 1.5,
    height: 1.0,
  );
  
  // Material Design Text Theme
  static TextTheme get textTheme => const TextTheme(
    displayLarge: h1,
    displayMedium: h2,
    displaySmall: h3,
    bodyLarge: body1,
    bodyMedium: body2,
    labelLarge: button,
    labelMedium: caption,
    labelSmall: overline,
  );
}
