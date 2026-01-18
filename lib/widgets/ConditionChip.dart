import 'package:flutter/material.dart';
import 'package:gestor_cartas/Logic/CardCondition.dart';

// widget que muestra la etiqueta de colores segun el estado
class ConditionChip extends StatelessWidget {
  final CardCondition? condition;
  final double fontSize;

  // pido la condicion y el tamano de letra
  const ConditionChip({super.key, required this.condition, this.fontSize = 12});

  @override
  Widget build(BuildContext context) {
    // si es nulo no muestro nada
    if (condition == null) {
      return const SizedBox.shrink();
    }

    // saco el color y el texto del enum
    final backgroundColor = condition!.color;
    final displayText = condition!.displayName;

    return Container(
      // decoracion con bordes redondeados y el color que toque
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          // pongo texto blanco y negrita
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: fontSize,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
