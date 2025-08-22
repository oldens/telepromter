import 'package:flutter/material.dart';
import 'package:simple_prompter/screens/home_screen.dart';
import 'package:simple_prompter/constants/app_colors.dart';
import 'package:simple_prompter/constants/app_typography.dart';

class SimplePrompterApp extends StatelessWidget {
  const SimplePrompterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Простий Суфлер',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        textTheme: AppTypography.textTheme,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 12.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
