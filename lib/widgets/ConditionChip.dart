import 'package:flutter/material.dart';

class ConditionChip extends StatelessWidget {
  final String condition;
  final double fontSize;

  const ConditionChip({super.key, required this.condition, this.fontSize = 12});

  @override
  Widget build(BuildContext context) {
    final quality = condition;
    final backgroundColor = _getColorForCondition(quality.toLowerCase());

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        quality,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: fontSize,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  _getColorForCondition(String quality) {
    switch (quality) {
      case 'mint':
        return const Color(0xFF00ACC1); // Cyan (Mint)
      case 'near mint':
        return const Color(0xFF43A047); // Verde (Near Mint)
      case 'excelent':
        return const Color(0xFF9E9D24); // Oliva/Dorado (Excellent)
      case 'good':
        return const Color(0xFFFFB300); // Amarillo/Ámbar (Good)
      case 'light played':
        return const Color(0xFFFB8C00); // Naranja (Light Played)
      case 'played':
        return const Color(0xFFE53935); // Rojo Claro (Played)
      case 'poor':
        return const Color(0xFFC62828); // Rojo Oscuro (Poor)
      default:
        return Colors.grey; // Color por defecto si falla
    }
  }
}
