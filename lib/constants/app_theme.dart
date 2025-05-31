// lib/constants/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.teal,
    scaffoldBackgroundColor: Colors.grey[100],
    fontFamily: 'Montserrat', // Asegúrate de añadir la fuente a pubspec.yaml y assets
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.teal,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.tealAccent[700],
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    // ***** CAMBIO AQUÍ *****
    cardTheme: CardThemeData( // Cambiado de CardTheme a CardThemeData
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
    ),
    // ***** FIN DEL CAMBIO *****
    textTheme: TextTheme(
      headlineSmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.teal[800]),
      bodyLarge: TextStyle(fontSize: 18.0, color: Colors.grey[800]),
      labelLarge: const TextStyle(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.bold), // Para texto de botones
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal).copyWith(
      secondary: Colors.amber, // Accent color
    ),
    // Asegúrate que el resto de tus temas sean compatibles
    // por ejemplo, si usas `useMaterial3: true`, algunos nombres o propiedades podrían cambiar.
    // Si no lo has puesto explícitamente, Flutter puede estar usando Material 3 por defecto
    // en proyectos nuevos.
    // useMaterial3: true, // Descomenta y prueba si tienes más errores de este tipo
  );

  // Colores específicos del quiz
  static const Color correctColor = Colors.green;
  static const Color incorrectColor = Colors.red;
  static Color defaultOptionColor = Colors.teal.shade300;
  static Color selectedOptionColor = Colors.teal.shade500;
}