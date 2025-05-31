// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/quiz_provider.dart';
import 'screens/quiz_page.dart';
import 'constants/app_theme.dart'; // Importa el tema

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Envuelve tu app con ChangeNotifierProvider para que QuizProvider esté disponible
    return ChangeNotifierProvider(
      create: (context) => QuizProvider(),
      child: MaterialApp(
        title: 'UWU Quiz Game',
        theme: AppTheme.lightTheme, // Aplica el tema
        debugShowCheckedModeBanner: false,
        home: const QuizPage(), // La pantalla inicial
      ),
    );
  }
}