// lib/screens/quiz_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../widgets/question_display.dart';
import '../widgets/option_button.dart';
import 'results_page.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);
    final currentQ = quizProvider.currentQuestion;

    return Scaffold(
      appBar: AppBar(
        title: const Text('UWU Quiz✨'), // Título más divertido
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Center(
              child: Column( // Mostrar score y puntos de genio
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Puntos: ${quizProvider.score}',
                      style: const TextStyle(fontSize: 16, color: Colors.white)),
                  if (quizProvider.geniusPoints > 0)
                    Text('+${quizProvider.geniusPoints} Genio!',
                        style: TextStyle(fontSize: 12, color: Colors.amber[300])),
                ],
              ),
            ),
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

            // Mostrar mensaje de Feedback
            if (quizProvider.isAnswered && quizProvider.currentFeedbackMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Card(
                  color: quizProvider.selectedAnswer == currentQ.correctAnswer
                      ? Colors.green.shade100
                      : Colors.red.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      quizProvider.currentFeedbackMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: quizProvider.selectedAnswer == currentQ.correctAnswer
                            ? Colors.green.shade800
                            : Colors.red.shade800,
                      ),
                    ),
                  ),
                ),
              ),

            ...currentQ.options.map((option) {
              bool isSelected = quizProvider.selectedAnswer == option;
              bool isCorrect = option == currentQ.correctAnswer;

              return OptionButton(
                optionText: option,
                isSelected: isSelected,
                isCorrect: isCorrect,
                isAnswered: quizProvider.isAnswered,
                isEnabled: !quizProvider.isAnswered,
                onPressed: () => quizProvider.answerQuestion(option),
              );
            }).toList(),
            const Spacer(),
            if (quizProvider.isAnswered)
              ElevatedButton(
                onPressed: () {
                  if (quizProvider.isQuizOver) {
                    Navigator.pushReplacement(
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
                  quizProvider.isQuizOver ? 'Ver Resultados ¡Fiesta!' : 'Siguiente Pregunta >.<', // Texto divertido
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