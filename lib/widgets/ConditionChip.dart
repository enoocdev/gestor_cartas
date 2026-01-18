import 'package:flutter/material.dart';
// Importamos la enumeracion de condiciones para obtener el color y el nombre
import 'package:gestor_cartas/Logic/CardCondition.dart';

// Este widget se encarga de mostrar una pequena etiqueta visual para la calidad de la carta
// Recibe una condicion de tipo CardCondition y muestra un chip con el color correspondiente
class ConditionChip extends StatelessWidget {
  // La condicion de la carta usando la enumeracion CardCondition
  final CardCondition? condition;
  // Tamano de la fuente que se puede ajustar desde fuera
  final double fontSize;

  // Constructor del widget que recibe la condicion y opcionalmente el tamano de fuente
  const ConditionChip({super.key, required this.condition, this.fontSize = 12});

  @override
  Widget build(BuildContext context) {
    // Si la condicion es nula mostramos un contenedor vacio
    if (condition == null) {
      return const SizedBox.shrink();
    }

    // Obtenemos el color de fondo directamente desde la enumeracion
    final backgroundColor = condition!.color;
    // Obtenemos el nombre a mostrar desde la enumeracion
    final displayText = condition!.displayName;

    return Container(
      // Espaciado interno para que el texto no toque los bordes del chip
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        // Color de fondo segun la condicion
        color: backgroundColor,
        // Bordes redondeados para el aspecto de chip
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          // El texto siempre sera blanco para resaltar sobre el fondo de color
          color: Colors.white,
          // Fuente muy gruesa para mejorar la legibilidad
          fontWeight: FontWeight.w900,
          // Tamano de fuente configurable
          fontSize: fontSize,
          // Un poco de espacio entre letras para mejor apariencia
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
