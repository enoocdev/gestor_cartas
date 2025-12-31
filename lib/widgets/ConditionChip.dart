import 'package:flutter/material.dart';

// Este widget se encarga de mostrar una pequeña etiqueta visual para la calidad de la carta
class ConditionChip extends StatelessWidget {
  final String condition; // El texto de la condicion
  final double fontSize; // Tamaño de la fuente que se puede ajustar

  const ConditionChip({super.key, required this.condition, this.fontSize = 12});

  @override
  Widget build(BuildContext context) {
    final quality = condition;
    // Se calcula el color de fondo llamando a la funcion interna pasandolo a minusculas
    final backgroundColor = _getColorForCondition(quality.toLowerCase());

    return Container(
      // Espaciado interno para que el texto no toque los bordes del chip
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8), // Bordes redondeados
      ),
      child: Text(
        quality,
        style: TextStyle(
          color: Colors
              .white, // El texto siempre sera blanco para resaltar sobre el fondo
          fontWeight:
              FontWeight.w900, // Fuente muy gruesa para mejorar la lectura
          fontSize: fontSize,
          letterSpacing:
              0.5, // Un poco de espacio entre letras para que quede mejor
        ),
      ),
    );
  }

  // Funcion de apoyo para mapear cada estado de conservacion con un color especifico
  _getColorForCondition(String quality) {
    switch (quality) {
      case 'mint':
        return const Color(0xFF00ACC1); // Cyan para Mint
      case 'near mint':
        return const Color(0xFF43A047); // Verde para Near Mint
      case 'excelent':
        return const Color(0xFF9E9D24); // Verde para Excellent
      case 'good':
        return const Color(0xFFFFB300); // Amarillopara Good
      case 'light played':
        return const Color(0xFFFB8C00); // Naranja para Light Played
      case 'played':
        return const Color(0xFFE53935); // Rojo Claro para Played
      case 'poor':
        return const Color(0xFFC62828); // Rojo Oscuro para Poor
      default:
        return Colors
            .grey; // Color gris si la condicion no coincide con ninguna
    }
  }
}
