// Importo la librería math para usar la función max().
import 'dart:math';

// Hago la clase Card pública para otros ficheros que importen este.
export 'Card.dart';

/// Modelo para representar una carta.
class Card {
  int codigo;
  String nombre;
  String? calidad; // La calidad puede ser opcional, por eso es nullable.
  String coleccion;
  String? imagenPath;

  // El precio es privado para forzar el uso del getter y setter.
  // Así controlo que nunca sea negativo.
  double _precio;

  // Constructor principal para crear una carta.
  Card({
    this.codigo,
    this.nombre,
    this.calidad,
    this.coleccion,
    this._precio,
    this.imagenPath,
  }) {
    // Me aseguro de que el precio no sea negativo al crear la carta.
    _precio = max(precio, 0);
  }

  // Getter público para el precio.
  double get precio => _precio;

  // Setter para el precio, con la misma validación para que no sea negativo.
  set precio(double nuevoPrecio) {
    _precio = max(nuevoPrecio, 0);
  }

  // Sobrescribo toString() para que al imprimir el objeto se vea bien.
  @override
  String toString() {
    return ("Card: $codigo\n\tNombre: $nombre\n\tCalidad: $calidad\n\tColeccion: $coleccion\n\tPrecio: $precio\n\n");
  }
}
