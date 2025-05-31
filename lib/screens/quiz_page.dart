// lib/screens/quiz_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../widgets/question_display.dart';
import '../widgets/option_button.dart';
import 'results_page.dart'; // Importa la página de resultados

class QuizPage extends StatelessWidget {
  const QuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Escucha los cambios en QuizProvider
    final quizProvider = Provider.of<QuizProvider>(context);
    final currentQ = quizProvider.currentQuestion;

    return Scaffold(
      appBar: AppBar(
        title: const Text('UWU Quiz'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Center(
                child: Text('Puntos: ${quizProvider.score}',
                    style: const TextStyle(fontSize: 18, color: Colors.white))),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            QuestionDisplay(
              questionText: currentQ.questionText,
              currentQuestionNumber: quizProvider.currentQuestionIndex + 1,
              totalQuestions: quizProvider.questions.length,
            ),
            const SizedBox(height: 20),
            ...currentQ.options.map((option) {
              bool isSelected = quizProvider.selectedAnswer == option;
              bool isCorrect = option == currentQ.correctAnswer;

              return OptionButton(
                optionText: option,
                isSelected: isSelected,
                isCorrect: isCorrect,
                isAnswered: quizProvider.isAnswered,
                isEnabled: !quizProvider.isAnswered, // Solo se puede presionar si no se ha respondido
                onPressed: () => quizProvider.answerQuestion(option),
              );
            }).toList(),
            const Spacer(),
            if (quizProvider.isAnswered)
              ElevatedButton(
                onPressed: () {
                  if (quizProvider.isQuizOver) {
                    Navigator.pushReplacement( // Reemplaza para no volver a la última pregunta
                      context,
                      MaterialPageRoute(builder: (context) => const ResultsPage()),
                    );
                  } else {
                    quizProvider.nextQuestion();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
                child: Text(
                  quizProvider.isQuizOver ? 'Ver Resultados' : 'Siguiente Pregunta',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black87),
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}