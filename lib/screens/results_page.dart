// lib/screens/results_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import 'quiz_page.dart'; // Para reiniciar

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false); // No necesita escuchar cambios aquí

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados del Quiz'),
        automaticallyImplyLeading: false, // No mostrar botón de atrás por defecto
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '¡Quiz Completado!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Text(
                    'Tu puntuación: ${quizProvider.score} de ${quizProvider.questions.length}',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Jugar de Nuevo'),
                onPressed: () {
                  quizProvider.resetQuiz();
                  Navigator.pushReplacement( // Reemplaza para no acumular pantallas de resultados
                    context,
                    MaterialPageRoute(builder: (context) => const QuizPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}