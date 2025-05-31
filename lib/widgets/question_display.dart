// lib/widgets/question_display.dart
import 'package:flutter/material.dart';

class QuestionDisplay extends StatelessWidget {
  final String questionText;
  final int currentQuestionNumber;
  final int totalQuestions;

  const QuestionDisplay({
    super.key,
    required this.questionText,
    required this.currentQuestionNumber,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pregunta $currentQuestionNumber de $totalQuestions',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 10),
            Text(
              questionText,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}