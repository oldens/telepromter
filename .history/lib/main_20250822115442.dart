import 'package:flutter/material.dart';
import 'package:simple_prompter/screens/home_screen.dart';

void main() {
  runApp(const SimplePrompterApp());
}

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
          seedColor: Colors.blue,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
