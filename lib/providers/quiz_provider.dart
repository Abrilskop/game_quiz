// lib/providers/quiz_provider.dart
import 'package:flutter/foundation.dart';
import '../models/question_model.dart';

class QuizProvider with ChangeNotifier {
  final List<Question> _questions = [
    // Tus preguntas aquí... (igual que antes)
    Question(
      questionText: '¿Cuál es la capital de Francia?',
      options: ['Berlín', 'Madrid', 'París', 'Roma'],
      correctAnswer: 'París',
    ),
    Question(
      questionText: '¿Qué planeta es conocido como el Planeta Rojo?',
      options: ['Tierra', 'Marte', 'Júpiter', 'Saturno'],
      correctAnswer: 'Marte',
    ),
    // ... más preguntas
  ];

  int _currentQuestionIndex = 0;
  int _score = 0;
  String? _selectedAnswer;
  bool _isAnswered = false;

  // Getters para la UI
  List<Question> get questions => _questions;
  Question get currentQuestion => _questions[_currentQuestionIndex];
  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  String? get selectedAnswer => _selectedAnswer;
  bool get isAnswered => _isAnswered;
  bool get isQuizOver => _currentQuestionIndex >= _questions.length -1 && _isAnswered; // Un poco ajustado para saber cuándo mostrar resultados


  void answerQuestion(String selectedOption) {
    if (_isAnswered) return;

    _selectedAnswer = selectedOption;
    _isAnswered = true;
    if (selectedOption == currentQuestion.correctAnswer) {
      _score++;
    }
    notifyListeners(); // Notifica a los widgets que escuchan que el estado ha cambiado
  }

  void nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      _selectedAnswer = null;
      _isAnswered = false;
      notifyListeners();
    } else {
      // El quiz ya terminó, no debería llamarse a nextQuestion sino navegar a resultados.
      // La lógica de "isQuizOver" y la navegación se manejarán en la UI.
      // O podrías tener un estado como `QuizState.finished`
      print("Quiz finished, should navigate to results.");
      // Si necesitas notificar un cambio final, puedes hacerlo.
      notifyListeners();
    }
  }

  void resetQuiz() {
    _currentQuestionIndex = 0;
    _score = 0;
    _selectedAnswer = null;
    _isAnswered = false;
    notifyListeners();
  }
}