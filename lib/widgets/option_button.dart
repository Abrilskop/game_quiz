// lib/widgets/option_button.dart
import 'package:flutter/material.dart';
import '../constants/app_theme.dart'; // Para colores

class OptionButton extends StatelessWidget {
  final String optionText;
  final VoidCallback onPressed;
  final bool isSelected;
  final bool isCorrect;
  final bool isAnswered;
  final bool isEnabled;

  const OptionButton({
    super.key,
    required this.optionText,
    required this.onPressed,
    this.isSelected = false,
    this.isCorrect = false,
    this.isAnswered = false,
    this.isEnabled = true,
  });

  Color _getBackgroundColor(BuildContext context) {
    if (!isAnswered) {
      return isSelected ? AppTheme.selectedOptionColor : AppTheme.defaultOptionColor;
    }
    // Si ya se respondió
    if (isCorrect) return AppTheme.correctColor; // Siempre verde si es la correcta
    if (isSelected && !isCorrect) return AppTheme.incorrectColor; // Roja si la seleccioné y es incorrecta
    return AppTheme.defaultOptionColor.withOpacity(0.5); // Opaca para las no seleccionadas/no correctas
  }

  IconData? _getIcon() {
    if (!isAnswered) return null;
    if (isCorrect) return Icons.check_circle_outline;
    if (isSelected && !isCorrect) return Icons.highlight_off;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: ElevatedButton.icon(
        icon: _getIcon() != null
            ? Icon(_getIcon(), color: Colors.white)
            : const SizedBox.shrink(),
        label: Text(optionText, style: Theme.of(context).textTheme.labelLarge),
        style: ElevatedButton.styleFrom(
          backgroundColor: _getBackgroundColor(context),
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50), // Ancho completo
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        onPressed: isEnabled && !isAnswered ? onPressed : null, // Deshabilita si no está enabled o ya se respondió
      ),
    );
  }
}