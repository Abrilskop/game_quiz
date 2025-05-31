// test/widget/quiz_page_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
// Ajusta las rutas según tu estructura de proyecto
import 'package:game_quiz/providers/quiz_provider.dart';
import 'package:game_quiz/screens/quiz_page.dart';
import 'package:game_quiz/models/question_model.dart';
import 'package:game_quiz/widgets/option_button.dart';
import 'package:game_quiz/widgets/question_display.dart';
import 'package:game_quiz/screens/results_page.dart';
import 'package:game_quiz/constants/app_theme.dart'; // Importa tu tema

// Mock de preguntas para un control más fino en las pruebas de widget
// ESTA VARIABLE AHORA SE USARÁ
final mockQuestionsList = [
  Question(questionText: 'Test Q1: Capital of Testland?', options: ['Test A', 'Test B', 'Test C'], correctAnswer: 'Test A'),
  Question(questionText: 'Test Q2: Color of Test Sky?', options: ['Test Blue', 'Test Green', 'Test Red'], correctAnswer: 'Test Blue'),
  Question(questionText: 'Test Q3: Final Question?', options: ['Yes', 'No'], correctAnswer: 'Yes'),
];

// Helper para envolver el widget bajo prueba con MaterialApp y Provider
Widget createQuizPageTestWidget({QuizProvider? provider}) {
  return ChangeNotifierProvider<QuizProvider>(
    // Si no se provee un provider, crea uno con las preguntas mock
    create: (_) => provider ?? QuizProvider(questions: mockQuestionsList),
    child: MaterialApp(
      theme: AppTheme.lightTheme, // Aplica el tema para que los widgets lo encuentren
      home: const QuizPage(),
      // Define rutas para poder navegar y verificar la navegación en las pruebas
      routes: {
        // Asegúrate que ResultsPage también se envuelva en un Provider si lo necesita directamente,
        // aunque usualmente leerá del provider existente en el árbol.
        '/results': (context) => const ResultsPage(),
      },
    ),
  );
}

void main() {
  late QuizProvider testQuizProvider;

  setUp(() {
    // Ahora pasamos las preguntas mock al constructor de QuizProvider
    testQuizProvider = QuizProvider(questions: mockQuestionsList);
    // testQuizProvider.resetQuiz(); // El constructor ya establece el estado inicial.
                                  // resetQuiz() aquí es redundante a menos que hagas algo entre
                                  // la creación y el uso que necesite resetearse.
                                  // Es buena práctica llamar a reset si los tests pueden dejar
                                  // el provider en un estado no deseado para el siguiente test.
                                  // Dado que creamos una nueva instancia en cada setUp, está bien.
  });


  testWidgets('QuizPage displays initial question and options from mock list', (WidgetTester tester) async {
    // Usamos el testQuizProvider configurado en setUp
    await tester.pumpWidget(createQuizPageTestWidget(provider: testQuizProvider));

    // Verifica que se muestra el QuestionDisplay y el texto de la primera pregunta mock
    expect(find.byType(QuestionDisplay), findsOneWidget);
    expect(find.text(mockQuestionsList[0].questionText), findsOneWidget); // Usa mockQuestionsList para verificar

    // Verifica que se muestran los botones de opción para la primera pregunta mock
    for (var option in mockQuestionsList[0].options) {
      expect(find.widgetWithText(OptionButton, option), findsOneWidget);
    }

    // Verifica que el botón "Siguiente Pregunta" / "Ver Resultados" no está visible inicialmente
    expect(find.text('Siguiente Pregunta'), findsNothing);
    expect(find.text('Ver Resultados'), findsNothing);
  });

  testWidgets('Tapping correct option updates score and shows "Siguiente Pregunta" button', (WidgetTester tester) async {
    await tester.pumpWidget(createQuizPageTestWidget(provider: testQuizProvider));

    final correctAnswer = mockQuestionsList[0].correctAnswer; // Usa la pregunta mock
    await tester.tap(find.widgetWithText(OptionButton, correctAnswer));
    await tester.pump(); // Reconstruye el widget después del cambio de estado

    expect(testQuizProvider.score, 1);
    expect(testQuizProvider.isAnswered, true);

    // Verifica que el botón de "Siguiente Pregunta" aparece
    // (o "Ver Resultados" si solo hay una pregunta en mockQuestionsList)
    if (mockQuestionsList.length > 1) {
        expect(find.text('Siguiente Pregunta'), findsOneWidget);
    } else {
        expect(find.text('Ver Resultados'), findsOneWidget);
    }
  });

  testWidgets('Tapping "Siguiente Pregunta" loads next question from mock list', (WidgetTester tester) async {
    // Asegúrate de que haya al menos 2 preguntas para este test en mockQuestionsList
    if (mockQuestionsList.length < 2) {
        print("Skipping 'Tapping Siguiente' test: Not enough mock questions.");
        return;
    }

    await tester.pumpWidget(createQuizPageTestWidget(provider: testQuizProvider));

    // Primera respuesta
    await tester.tap(find.widgetWithText(OptionButton, mockQuestionsList[0].correctAnswer));
    await tester.pump();

    // Tap en Siguiente
    await tester.tap(find.text('Siguiente Pregunta'));
    await tester.pump();

    // Verifica que se muestra la segunda pregunta mock
    expect(find.text(mockQuestionsList[1].questionText), findsOneWidget);
    expect(testQuizProvider.currentQuestionIndex, 1);
    expect(testQuizProvider.isAnswered, false);
  });

  testWidgets('Finishing quiz navigates to ResultsPage', (WidgetTester tester) async {
    // No es necesario pasar el provider aquí si `createQuizPageTestWidget` ya lo hace
    // y el `testQuizProvider` de `setUp` se usa globalmente en este grupo de test.
    // Sin embargo, para claridad, puedes pasarlo explícitamente si lo deseas.
    await tester.pumpWidget(createQuizPageTestWidget(provider: testQuizProvider));

    // Simula responder todas las preguntas mock
    for (int i = 0; i < mockQuestionsList.length; i++) {
      // Encuentra la primera opción como ejemplo, podrías elegir la correcta si quieres
      await tester.tap(find.widgetWithText(OptionButton, mockQuestionsList[i].options.first).first); // .first por si hay duplicados
      await tester.pump();

      if (i < mockQuestionsList.length - 1) {
        expect(find.text('Siguiente Pregunta'), findsOneWidget);
        await tester.tap(find.text('Siguiente Pregunta'));
      } else {
        expect(find.text('Ver Resultados'), findsOneWidget);
        await tester.tap(find.text('Ver Resultados'));
      }
      // pumpAndSettle() espera a que las animaciones (como la navegación) terminen
      await tester.pumpAndSettle();
    }

    // Verifica que estamos en la ResultsPage
    expect(find.byType(ResultsPage), findsOneWidget);
    expect(find.textContaining('Tu puntuación:'), findsOneWidget);
    // Verifica el score final basado en cómo respondiste (aquí siempre la primera opción)
    // Este cálculo del score esperado dependerá de tu lógica de respuesta en el bucle.
    // Si siempre eliges la primera opción:
    int expectedScore = 0;
    for(var q in mockQuestionsList) {
        if(q.options.first == q.correctAnswer) expectedScore++;
    }
    expect(find.text('Tu puntuación: $expectedScore de ${mockQuestionsList.length}'), findsOneWidget);
  });
}