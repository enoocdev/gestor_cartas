// Imports necesarios para manejar archivos (io) y para codificar/decodificar JSON (convert).
import 'dart:io';
import 'dart:convert';
// Importo mi modelo de Card para poder usarlo.
import 'Card.dart';

// Hago la clase Cardlist pública para otros ficheros.
export 'CardList.dart';

import 'package:flutter/services.dart';

/// Clase que gestiona la lista completa de cartas.
/// Se encarga de añadir, borrar, buscar y persistir los datos en JSON.
class Cardlist {
  // Implmento patron singleton para facilidad a la hora de acceder a los datos
  // y no tener que pasar la lista por parametro de los widgets
  static final Cardlist _instance = Cardlist._internal();

  factory Cardlist() {
    return _instance;
  }

  Cardlist._internal();

  // Aquí guardo todas las cartas en memoria.
  List<Card> cards = [];

  // Lo uso como autoincremento para el código de cada carta nueva.
  int contador = 0;

  // Función para añadir una nueva carta a la lista.
  // Incremento el contador antes de pasarlo para generar el nuevo código.
  addCard(nombre, calidad, coleccion, precio, imagenPath) {
    cards.add(
      Card(
        codigo: ++contador,
        nombre: nombre,
        calidad: calidad,
        coleccion: coleccion,
        precio: precio,
        imagenPath: imagenPath,
      ),
    );
  }

  // Función para eliminar una carta por su código.
  // Uso removeWhere por si acaso hubiera duplicados, aunque no debería.
  delCard(int cod) {
    return cards.removeWhere((a) => a.codigo == cod);
  }

  updateCard(Card card) {
    Card c = searchCard(code: card.codigo)[0];

    c.calidad = card.calidad;
    c.coleccion = card.coleccion;
    c.nombre = card.nombre;
    c.precio = card.precio;
    c.imagenPath = card.imagenPath;
  }

  // Buscador genérico. Permite filtrar por cualquier campo que no sea nulo.
  searchCard({
    int? code,
    String? nombre,
    String? calidad,
    String? coleccion,
    double? precio,
  }) {
    // El .where me permite encadenar las condiciones del filtro.
    // Para cada campo, si el parámetro no es nulo, aplico el filtro. Si es nulo, lo ignoro (devuelvo true).
    return cards
        .where(
          (a) =>
              ((code != null ? (a.codigo == code) : true) &&
              (nombre != null && nombre != ""
                  ? (a.nombre.toLowerCase().contains(
                      nombre.toLowerCase().trim(),
                    ))
                  : true) &&
              (calidad != null && calidad != ""
                  ? (a.calidad?.toLowerCase() == calidad.toLowerCase())
                  : true) &&
              (coleccion != null && coleccion != ""
                  ? (a.coleccion.toLowerCase() == coleccion.toLowerCase())
                  : true) &&
              (precio != null && precio != -1 ? (a.precio > precio) : true)),
        )
        .toList(); // Devuelvo el resultado como una nueva lista.
  }

  // Guarda la lista de cartas actual en un fichero JSON.
  // Es una función asíncrona porque la escritura a disco puede tardar.
  writeInJson(String path) async {
    File file = File(path);
    try {
      // Primero, convierto la lista de objetos Card a una lista de Mapas.
      List<Map<String, dynamic>> registros = cards
          .map(
            (card) => {
              "codigo": card.codigo,
              "nombre": card.nombre,
              "calidad": card.calidad,
              "coleccion": card.coleccion,
              "precio": card.precio,
              "imagenPath": card.imagenPath,
            },
          )
          .toList();

      // Convierto la lista de mapas a un string en formato JSON y lo escribo en el fichero.
      await file.writeAsString(jsonEncode(registros), mode: FileMode.write);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Carga las cartas desde un fichero JSON.
  readFromJson(String path) async {
    String contenido;
    try {
      contenido = await rootBundle.loadString(path);
    } catch (e) {
      print("ERROR LEYENDO EL ARCHIVO: $e");
      return -1;
    }

    // Si el fichero está vacío, tampoco hay nada que cargar.
    if (contenido.trim().isEmpty) return 0;

    // Decodifico el string JSON a una lista de datos.
    var datos = jsonDecode(contenido);
    cards = []; // Vacío la lista actual antes de cargar las nuevas.

    // Recorro los datos y creo un objeto Card por cada uno.
    for (Map<String, dynamic> dato in datos) {
      cards.add(
        Card(
          codigo: dato['codigo'],
          nombre: dato['nombre'],
          calidad: dato['calidad'],
          coleccion: dato['coleccion'],
          precio: dato['precio'],
          imagenPath: dato['imagenPath'],
        ),
      );
    }
    // Actualizo el contador al código más alto que haya cargado.
    // Así, la próxima carta que añada tendrá un código correlativo y único.

    contador = cards.map((c) => c.codigo).reduce((a, b) => a > b ? a : b);

    return 1;
  }

  // Sobrescribo toString() para mostrar la lista completa.
  @override
  String toString() {
    // Uso un StringBuffer por eficiencia, es mejor que concatenar strings en un bucle.
    StringBuffer cardList = StringBuffer();
    for (Card c in cards) {
      cardList.write(c); // Aprovecho el toString() de la clase Card.
    }
    return cardList.toString();
  }
}
