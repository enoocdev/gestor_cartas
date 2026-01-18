// Importamos flutter para poder usar los colores
import 'package:flutter/material.dart';

// Enumeracion que define todos los estados de conservacion posibles para una carta
// Cada valor representa un nivel de calidad diferente de menor a mayor desgaste
enum CardCondition {
  // Carta en estado perfecto sin ningun defecto visible
  mint,
  // Carta casi perfecta con minimos defectos apenas perceptibles
  nearMint,
  // Carta en excelente estado con pequenos defectos menores
  excellent,
  // Carta en buen estado general con desgaste leve
  good,
  // Carta ligeramente jugada con desgaste notable pero aceptable
  lightPlayed,
  // Carta usada con desgaste evidente en bordes y superficie
  played,
  // Carta en mal estado con danos significativos
  poor,
}

// Extension que anade metodos utiles a la enumeracion CardCondition
extension CardConditionExtension on CardCondition {
  // Devuelve el nombre legible de la condicion para mostrar en la interfaz
  String get displayName {
    switch (this) {
      case CardCondition.mint:
        return 'Mint';
      case CardCondition.nearMint:
        return 'Near Mint';
      case CardCondition.excellent:
        return 'Excelent';
      case CardCondition.good:
        return 'Good';
      case CardCondition.lightPlayed:
        return 'Light Played';
      case CardCondition.played:
        return 'Played';
      case CardCondition.poor:
        return 'Poor';
    }
  }

  // Devuelve el color asociado a cada condicion para usarlo en los chips
  Color get color {
    switch (this) {
      case CardCondition.mint:
        // Cyan para Mint que representa estado perfecto
        return const Color(0xFF00ACC1);
      case CardCondition.nearMint:
        // Verde para Near Mint que indica muy buen estado
        return const Color(0xFF43A047);
      case CardCondition.excellent:
        // Verde amarillento para Excellent
        return const Color(0xFF9E9D24);
      case CardCondition.good:
        // Amarillo para Good que indica estado aceptable
        return const Color(0xFFFFB300);
      case CardCondition.lightPlayed:
        // Naranja para Light Played que indica desgaste leve
        return const Color(0xFFFB8C00);
      case CardCondition.played:
        // Rojo claro para Played que indica desgaste notable
        return const Color(0xFFE53935);
      case CardCondition.poor:
        // Rojo oscuro para Poor que indica mal estado
        return const Color(0xFFC62828);
    }
  }

  // Convierte un string a su correspondiente valor de la enumeracion
  // Devuelve null si el string no coincide con ninguna condicion
  static CardCondition? fromString(String? value) {
    // Si el valor es nulo o vacio devolvemos null
    if (value == null || value.isEmpty) return null;

    // Convertimos a minusculas para comparar sin importar mayusculas
    final lowerValue = value.toLowerCase();

    switch (lowerValue) {
      case 'mint':
        return CardCondition.mint;
      case 'near mint':
        return CardCondition.nearMint;
      case 'excelent':
        return CardCondition.excellent;
      case 'good':
        return CardCondition.good;
      case 'light played':
        return CardCondition.lightPlayed;
      case 'played':
        return CardCondition.played;
      case 'poor':
        return CardCondition.poor;
      default:
        return null;
    }
  }
}
