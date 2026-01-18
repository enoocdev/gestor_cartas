// Importo la libreria math para usar la funcion max
import 'dart:math';

// Importo la enumeracion de condiciones de las cartas
import 'CardCondition.dart';

// Hago la clase Card publica para otros ficheros que importen este
export 'Card.dart';

// Modelo que representa una carta de la coleccion
// Contiene todos los datos necesarios como codigo nombre calidad coleccion precio e imagen
class Card {
  // Identificador unico de la carta
  int codigo;
  // Nombre de la carta
  String nombre;
  // Estado de conservacion de la carta usando la enumeracion CardCondition
  // Es opcional porque puede no estar definido
  CardCondition? calidad;
  // Nombre del set o coleccion a la que pertenece la carta
  String coleccion;
  // Ruta a la imagen de la carta puede ser nulo si no tiene imagen
  String? imagenPath;

  // El precio es privado para forzar el uso del getter y setter
  // Asi controlo que nunca sea negativo
  late double _precio;

  // Constructor principal para crear una carta
  // Recibe todos los campos necesarios siendo el precio validado automaticamente
  Card({
    required this.codigo,
    required this.nombre,
    this.calidad,
    required this.coleccion,
    required double precio,
    this.imagenPath,
  }) {
    // Me aseguro de que el precio no sea negativo al crear la carta
    _precio = max(precio, 0);
  }

  // Getter publico para obtener el precio de la carta
  double get precio => _precio;

  // Setter para el precio con validacion para que no sea negativo
  set precio(double nuevoPrecio) {
    _precio = max(nuevoPrecio, 0);
  }

  // Sobrescribo toString para que al imprimir el objeto se vea bien formateado
  @override
  String toString() {
    return ("Card: $codigo\n\tNombre: $nombre\n\tCalidad: ${calidad?.displayName}\n\tColeccion: $coleccion\n\tPrecio: $precio\n\n");
  }
}
