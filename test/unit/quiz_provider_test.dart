// test/unit/quiz_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:game_quiz/models/question_model.dart'; // Ajusta la ruta
import 'package:game_quiz/providers/quiz_provider.dart'; // Ajusta la ruta

// Mock de preguntas para las pruebas
final List<Question> mockQuestions = [
  Question(questionText: 'Q1', options: ['A', 'B'], correctAnswer: 'A'),
  Question(questionText: 'Q2', options: ['C', 'D'], correctAnswer: 'D'),
];

// Helper para crear una instancia de QuizProvider con preguntas mock
QuizProvider createProviderWithMockQuestions() {
  final provider = QuizProvider();
  // Es necesario un hack para reemplazar las preguntas internas,
  // o modificar QuizProvider para aceptar preguntas en el constructor para testing.
  // Para este ejemplo, asumimos que QuizProvider usa las preguntas que tiene por defecto
  // o que tienes una forma de inyectarlas (mejor para testing).
  // Si QuizProvider carga preguntas internamente, este test probará esas.
  // Una mejor aproximación sería:
  // final provider = QuizProvider(questions: mockQuestions);
  // pero eso requeriría cambiar el constructor de QuizProvider.
  // Por ahora, probaremos la lógica con sus preguntas por defecto.
  return provider;
}


void main() {
  group('QuizProvider Unit Tests', () {
    late QuizProvider quizProvider;

    setUp(() {
      // Si quieres usar preguntas mock, necesitarías modificar QuizProvider
      // para poder inyectarlas o tener un método `loadQuestions(List<Question> q)`.
      // Por simplicidad, aquí usaremos el QuizProvider tal cual.
      quizProvider = QuizProvider();
      // Si QuizProvider tiene preguntas por defecto, puedes resetearlo para cada test
      quizProvider.resetQuiz(); // Asegura estado inicial limpio
    });

    test('Initial state is correct', () {
      expect(quizProvider.currentQuestionIndex, 0);
      expect(quizProvider.score, 0);
      expect(quizProvider.isAnswered, false);
      expect(quizProvider.selectedAnswer, null);
      // Asume que QuizProvider tiene al menos una pregunta
      expect(quizProvider.questions.isNotEmpty, true);
    });

    test('Answering a question correctly updates score and state', () {
      final firstQuestion = quizProvider.currentQuestion;
      quizProvider.answerQuestion(firstQuestion.correctAnswer);

      expect(quizProvider.score, 1);
      expect(quizProvider.isAnswered, true);
      expect(quizProvider.selectedAnswer, firstQuestion.correctAnswer);
    });

    test('Answering a question incorrectly does not update score but updates state', () {
      final firstQuestion = quizProvider.currentQuestion;
      // Encuentra una respuesta incorrecta
      final incorrectAnswer = firstQuestion.options.firstWhere((opt) => opt != firstQuestion.correctAnswer);
      quizProvider.answerQuestion(incorrectAnswer);

      expect(quizProvider.score, 0);
      expect(quizProvider.isAnswered, true);
      expect(quizProvider.selectedAnswer, incorrectAnswer);
    });

    test('nextQuestion advances to the next question and resets answer state', () {
      if (quizProvider.questions.length < 2) {
        print("Skipping nextQuestion test: Not enough questions in QuizProvider for this test.");
        return; // Salta el test si no hay suficientes preguntas
      }
      quizProvider.answerQuestion(quizProvider.currentQuestion.correctAnswer); // Responder primero
      quizProvider.nextQuestion();

      expect(quizProvider.currentQuestionIndex, 1);
      expect(quizProvider.isAnswered, false);
      expect(quizProvider.selectedAnswer, null);
    });

    test('resetQuiz resets all state to initial values', () {
      quizProvider.answerQuestion(quizProvider.currentQuestion.correctAnswer);
      if (quizProvider.questions.length > 1) quizProvider.nextQuestion();
      quizProvider.answerQuestion(quizProvider.currentQuestion.correctAnswer);
      quizProvider.resetQuiz();

      expect(quizProvider.currentQuestionIndex, 0);
      expect(quizProvider.score, 0);
      expect(quizProvider.isAnswered, false);
      expect(quizProvider.selectedAnswer, null);
    });

     test('isQuizOver returns true when last question is answered', () {
        // Navega hasta la última pregunta
        while(quizProvider.currentQuestionIndex < quizProvider.questions.length - 1) {
            quizProvider.answerQuestion(quizProvider.currentQuestion.correctAnswer); // contesta
            quizProvider.nextQuestion(); // pasa a la siguiente
        }
        // Ahora estamos en la última pregunta, la contestamos
        quizProvider.answerQuestion(quizProvider.currentQuestion.correctAnswer);

        expect(quizProvider.isQuizOver, true);
    });
  });
}