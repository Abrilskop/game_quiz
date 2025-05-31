// lib/providers/quiz_provider.dart
import 'package:flutter/foundation.dart';
import 'package:game_quiz/models/question_model.dart'; // Asegúrate que la ruta es correcta

class QuizProvider with ChangeNotifier {
  // _questions ahora es final y se inicializa en el constructor.
  final List<Question> _questions;

  // Preguntas por defecto que se usarán si no se proporcionan preguntas al constructor.
  // Estas son las preguntas que tenías hardcodeadas antes.
  static final List<Question> _defaultQuestions = [
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
    // ... puedes añadir más preguntas por defecto aquí
  ];

  int _currentQuestionIndex = 0;
  int _score = 0;
  String? _selectedAnswer;
  bool _isAnswered = false;

  // CONSTRUCTOR MODIFICADO
  // Acepta una lista opcional de preguntas.
  // Si no se proveen preguntas, usa _defaultQuestions.
  QuizProvider({List<Question>? questions})
      : _questions = questions ?? _defaultQuestions {
    // Es buena idea verificar si la lista de preguntas está vacía,
    // ya que podría causar problemas si la UI espera al menos una pregunta.
    if (_questions.isEmpty) {
      // Considera cómo manejar este caso: lanzar un error,
      // o asegurar que la UI pueda mostrar un mensaje apropiado.
      print("ADVERTENCIA: QuizProvider se inicializó con una lista de preguntas vacía.");
      // Podrías lanzar una excepción si una lista vacía es un estado inválido:
      // throw ArgumentError("La lista de preguntas no puede estar vacía.");
    }
    // No es necesario llamar a resetQuiz() aquí si el constructor ya establece el estado inicial deseado.
  }

  // Getters
  List<Question> get questions => _questions;

  Question get currentQuestion {
    if (_questions.isEmpty) {
      // Esto previene un error de rango si _questions está vacío y se intenta acceder a un índice.
      // Deberías decidir cómo manejar esto en tu UI. Podrías devolver una pregunta "dummy"
      // o lanzar un error más específico para que la UI lo capture.
      throw StateError("No hay preguntas disponibles en el quiz.");
    }
    return _questions[_currentQuestionIndex];
  }

  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  String? get selectedAnswer => _selectedAnswer;
  bool get isAnswered => _isAnswered;

  // bool get isQuizOver => _currentQuestionIndex >= _questions.length - 1 && _isAnswered;
  // Es más seguro comprobar primero si _questions está vacío:
  bool get isQuizOver {
    if (_questions.isEmpty) return true; // Si no hay preguntas, el quiz "terminó"
    return _currentQuestionIndex >= _questions.length - 1 && _isAnswered;
  }

  void answerQuestion(String selectedOption) {
    if (_isAnswered || _questions.isEmpty) return;

    _selectedAnswer = selectedOption;
    _isAnswered = true;
    if (selectedOption == currentQuestion.correctAnswer) {
      _score++;
    }
    notifyListeners();
  }

  void nextQuestion() {
    if (_questions.isEmpty || isQuizOver && _currentQuestionIndex >= _questions.length -1) {
      // Si no hay preguntas o ya estamos en la última pregunta y se contestó,
      // no hay "siguiente" pregunta en el sentido de avanzar el índice.
      // La lógica de navegar a resultados se maneja en la UI basada en isQuizOver.
      if (!isQuizOver) { // Solo notificar si aún no ha terminado formalmente
          notifyListeners();
      }
      return;
    }
    
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      _selectedAnswer = null;
      _isAnswered = false;
      notifyListeners();
    } else {
      // Esto realmente no debería suceder si la UI usa `isQuizOver` correctamente
      // para cambiar el botón a "Ver Resultados".
      // Pero si se llama, nos aseguramos de que el estado se notifique.
      print("Intentando llamar a nextQuestion() cuando el quiz ya debería haber terminado.");
      notifyListeners();
    }
  }

  void resetQuiz() {
    _currentQuestionIndex = 0;
    _score = 0;
    _selectedAnswer = null;
    _isAnswered = false;
    // _questions es 'final', así que no se reasigna aquí. La instancia del provider
    // usará las preguntas con las que fue creada. Si necesitas *cambiar*
    // el set de preguntas, tendrías que crear una nueva instancia de QuizProvider.
    notifyListeners();
  }
}