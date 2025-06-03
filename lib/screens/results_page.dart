// lib/screens/results_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import 'quiz_page.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  String getFunnyResultsTitle(int score, int totalQuestions, int geniusPoints) {
    double percentage = (score / (totalQuestions * 10)) * 100; // Asumiendo 10 pts por pregunta
    String title = "";

    if (percentage == 100) {
      title = "¡MEGA MENTE UWU! 🧠✨";
    } else if (percentage >= 75) {
      title = "¡Casi un Sabio Intergaláctico! 🚀";
    } else if (percentage >= 50) {
      title = "¡Nada mal, Cerebrito en Prácticas! 🤓";
    } else if (percentage >= 25) {
      title = "¡Sigue así, Pequeño Saltamontes del Saber! 🌱";
    } else {
      title = "¡Lo importante es divertirse! (y comer galletas 🍪)";
    }
    if (geniusPoints > 15) { // Ajusta este umbral
        title += "\n¡Con Poderes de Genio EXTREMOS!";
    } else if (geniusPoints > 0) {
        title += "\n¡Con un toque de Genialidad!";
    }
    return title;
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    final totalPossibleScore = quizProvider.questions.length * 10; // 10 puntos por pregunta

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados ¡Tachán! 🎉'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                getFunnyResultsTitle(quizProvider.score, quizProvider.questions.length, quizProvider.geniusPoints),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    children: [
                      Text(
                        'Tu puntuación: ${quizProvider.score} de $totalPossibleScore',
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      if (quizProvider.geniusPoints > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            '+ ${quizProvider.geniusPoints} Puntos de Genio ✨',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.amber.shade700),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.sentiment_very_satisfied), // Icono más divertido
                label: const Text('¡Otra Ronda, Porfis! 🙏'), // Texto divertido
                onPressed: () {
                  quizProvider.resetQuiz();
                  Navigator.pushReplacement(
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