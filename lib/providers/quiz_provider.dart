// lib/providers/quiz_provider.dart
import 'package:flutter/foundation.dart';
import '../models/question_model.dart';
import '../services/audio_service.dart'; // <--- CAMBIO/ADICIÓN: Importación del servicio de audio --->

class QuizProvider with ChangeNotifier {
  final List<Question> _questions;

  static final List<Question> _defaultFunnyQuestions = [
    Question(
      questionText: 'Si un gato se convierte en un espía, ¿qué nombre en clave tendría?',
      options: ['Agente Bigotes', '00-Miau', 'Gato con Licencia para Dormir', 'Jason Bourne-cat'],
      correctAnswer: 'Agente Bigotes',
    ),
    Question(
      questionText: '¿Cuál es el superpoder secreto de un pingüino que nadie conoce?',
      options: ['Volar (solo los jueves)', 'Dominar el mundo con su ternura', 'Hacer la mejor pizza de anchoas', 'Convertir agua en helado'],
      correctAnswer: 'Dominar el mundo con su ternura',
    ),
    Question(
      questionText: '¿Qué planeta está más cerca del Sol (y tiene las mejores selfies)?',
      options: ['Mercurio, el influencer cósmico', 'Venus, siempre diva', 'La Tierra (pero no se lo digas a la NASA)', 'Marte, el rey del filtro rojo'],
      correctAnswer: 'Mercurio, el influencer cósmico',
    ),
    Question(
      questionText: '¿Quién se robó la última galleta del tarro intergaláctico?',
      options: ['Un Gremlin hambriento', 'Thanos (necesitaba energía)', 'El Monstruo de las Galletas en una misión secreta', 'Fui yo, ¡shhh!'],
      correctAnswer: 'El Monstruo de las Galletas en una misión secreta',
    ),
  ];

  int _currentQuestionIndex = 0;
  int _score = 0;
  String? _selectedAnswer;
  bool _isAnswered = false;

  final List<String> _correctFeedbackMessages = [
    "¡Correctísimo! ¡Eres más brillante que una estrella fugaz con GPS!",
    "¡BOOM! Sabiduría desbloqueada. ¡Nivel UWU aumentado!",
    "¡Exacto! ¿Tienes un doctorado en Quizzología o qué?",
    "¡Perfectirijillo! ¡Das en el clavo como un carpintero ninja!",
  ];

  final List<String> _incorrectFeedbackMessages = [
    "¡Oof! Casi, casi... como calcetín desparejado.",
    "No te preocupes, hasta el unicornio más listo tropieza a veces.",
    "¡Respuesta incorrecta! Pero te ganas un aplauso por intentarlo.", // <--- CAMBIO: Eliminada simulación de AudioClip.clap() --->
    "¡Ups! Parece que esa neurona estaba de vacaciones. ¡Ánimo para la próxima!",
  ];

  String _currentFeedbackMessage = "";
  String get currentFeedbackMessage => _currentFeedbackMessage;

  int _geniusPoints = 0;
  int get geniusPoints => _geniusPoints;

  QuizProvider({List<Question>? questions})
      : _questions = questions ?? _defaultFunnyQuestions {
    if (_questions.isEmpty) {
      print("ADVERTENCIA: QuizProvider se inicializó con una lista de preguntas vacía.");
    }
    // <--- CAMBIO/ADICIÓN: Iniciar la música de fondo al crear el provider --->
    AudioService.playBackgroundMusic();
  }

  List<Question> get questions => _questions;
  Question get currentQuestion => _questions.isEmpty ? Question(questionText: "Oops, no hay preguntas", options: [], correctAnswer: "") : _questions[_currentQuestionIndex];
  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  String? get selectedAnswer => _selectedAnswer;
  bool get isAnswered => _isAnswered;
  bool get isQuizOver => _questions.isEmpty || (_currentQuestionIndex >= _questions.length - 1 && _isAnswered);

  void answerQuestion(String selectedOption) {
    if (_isAnswered || _questions.isEmpty) return;

    _selectedAnswer = selectedOption;
    _isAnswered = true;
    if (selectedOption == currentQuestion.correctAnswer) {
      _score += 10;
      _currentFeedbackMessage = _correctFeedbackMessages[(_score ~/ 10 -1 + _geniusPoints) % _correctFeedbackMessages.length];
      
      if ((_score ~/ 10) % 3 == 0) {
          _geniusPoints += 5;
          _currentFeedbackMessage += " ¡Y +5 Puntos de Genio por ser tan UWU-inteligente!";
      }
      // <--- CAMBIO/ADICIÓN: Reproducir sonido de acierto --->
      AudioService.playCorrectSound();
    } else {
      _currentFeedbackMessage = _incorrectFeedbackMessages[(_currentQuestionIndex) % _incorrectFeedbackMessages.length];
      // <--- CAMBIO/ADICIÓN: Reproducir sonido de error --->
      AudioService.playIncorrectSound();
    }
    notifyListeners();
  }

  void nextQuestion() {
    if (_questions.isEmpty || isQuizOver && _currentQuestionIndex >= _questions.length -1) return;
    
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      _selectedAnswer = null;
      _isAnswered = false;
      _currentFeedbackMessage = "";
      notifyListeners();
    } else {
      // Asegurarse de notificar si es la última pregunta y se ha respondido,
      // para que la UI pueda actualizar el botón a "Ver Resultados" incluso si
      // no hay más preguntas a las que avanzar.
      notifyListeners();
    }
  }

  void resetQuiz() {
    _currentQuestionIndex = 0;
    _score = 0;
    _geniusPoints = 0;
    _selectedAnswer = null;
    _isAnswered = false;
    _currentFeedbackMessage = "";

    // <--- CAMBIO/ADICIÓN: Opcional - Consideración para la música en reset --->
    // Si quieres que la música se reinicie cada vez:
    // AudioService.stopBackgroundMusic();
    // AudioService.playBackgroundMusic();
    // Si prefieres que siga sonando, no hagas nada aquí con la música.

    notifyListeners();
  }

  // <--- CAMBIO/ADICIÓN: Método para detener la música explícitamente --->
  // Este método podría ser llamado desde el widget `MyApp` o `QuizPage` en su `dispose`.
  void stopMusic() {
    AudioService.stopBackgroundMusic();
  }

  // <--- CAMBIO/ADICIÓN: Método para disponer los reproductores de audio --->
  // Este método debería ser llamado cuando la aplicación se cierra o el provider ya no se usa.
  // Por ejemplo, en el `dispose` del widget principal que maneja el ciclo de vida de la app.
  @override
  void dispose() {
    // Es una buena práctica detener la música y liberar los reproductores aquí
    // si el QuizProvider es el principal responsable de su ciclo de vida.
    AudioService.stopBackgroundMusic();
    AudioService.disposePlayers(); // Llama al dispose del servicio de audio
    super.dispose(); // Importante llamar al dispose de ChangeNotifier
  }
}