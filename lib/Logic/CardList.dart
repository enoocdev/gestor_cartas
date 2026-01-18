// Imports necesarios para manejar archivos io y para codificar decodificar JSON convert
import 'dart:io';
import 'dart:convert';
// Importo mi modelo de Card para poder usarlo
import 'Card.dart';
// Importo la enumeracion de condiciones
import 'CardCondition.dart';

// Hago la clase Cardlist publica para otros ficheros
export 'CardList.dart';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

// Clase que gestiona la lista completa de cartas
// Se encarga de anadir borrar buscar y persistir los datos en JSON
class Cardlist {
  // Implemento patron singleton para facilidad a la hora de acceder a los datos
  // y no tener que pasar la lista por parametro de los widgets
  static final Cardlist _instance = Cardlist._internal();

  // Factory constructor que devuelve siempre la misma instancia
  factory Cardlist() {
    return _instance;
  }

  // Constructor privado para el singleton
  Cardlist._internal();

  // Aqui guardo todas las cartas en memoria
  List<Card> cards = [];

  // Lo uso como autoincremento para el codigo de cada carta nueva
  int contador = 0;

  // Funcion para anadir una nueva carta a la lista
  // Recibe los datos necesarios incluyendo la calidad como CardCondition
  // Incremento el contador antes de pasarlo para generar el nuevo codigo
  addCard(nombre, CardCondition? calidad, coleccion, precio, imagenPath) {
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

  // Funcion para eliminar una carta por su codigo
  // Uso removeWhere por si acaso hubiera duplicados aunque no deberia
  delCard(int cod) {
    return cards.removeWhere((a) => a.codigo == cod);
  }

  // Funcion para actualizar los datos de una carta existente
  // Busca la carta por codigo y actualiza todos sus campos
  updateCard(Card card) {
    Card c = searchCard(code: card.codigo)[0];

    c.calidad = card.calidad;
    c.coleccion = card.coleccion;
    c.nombre = card.nombre;
    c.precio = card.precio;
    c.imagenPath = card.imagenPath;
  }

  // Buscador generico que permite filtrar por cualquier campo que no sea nulo
  // Recibe parametros opcionales y devuelve las cartas que coincidan con todos los filtros
  searchCard({
    int? code,
    String? nombre,
    CardCondition? calidad,
    String? coleccion,
    double? precio,
  }) {
    // El where me permite encadenar las condiciones del filtro
    // Para cada campo si el parametro no es nulo aplico el filtro si es nulo lo ignoro
    return cards
        .where(
          (a) =>
              ((code != null ? (a.codigo == code) : true) &&
              (nombre != null && nombre != ""
                  ? (a.nombre.toLowerCase().contains(
                      nombre.toLowerCase().trim(),
                    ))
                  : true) &&
              (calidad != null ? (a.calidad == calidad) : true) &&
              (coleccion != null && coleccion != ""
                  ? (a.coleccion.toLowerCase() == coleccion.toLowerCase())
                  : true) &&
              (precio != null && precio != -1 ? (a.precio > precio) : true)),
        )
        .toList();
  }

  // Guarda la lista de cartas actual en un fichero JSON
  // Es una funcion asincrona porque la escritura a disco puede tardar
  writeInJson() async {
    try {
      // Obtengo el directorio de documentos de la app
      final appDir = await getApplicationDocumentsDirectory();
      final filePath = '${appDir.path}/cards.json';
      File file = File(filePath);

      // Primero convierto la lista de objetos Card a una lista de Mapas
      // La calidad se guarda como string usando el displayName de la enumeracion
      List<Map<String, dynamic>> registros = cards
          .map(
            (card) => {
              "codigo": card.codigo,
              "nombre": card.nombre,
              "calidad": card.calidad?.displayName,
              "coleccion": card.coleccion,
              "precio": card.precio,
              "imagenPath": card.imagenPath,
            },
          )
          .toList();

      // Convierto la lista de mapas a un string en formato JSON y lo escribo en el fichero
      await file.writeAsString(jsonEncode(registros), mode: FileMode.write);
      return true;
    } catch (e) {
      print("ERROR ESCRIBIENDO EL ARCHIVO: $e");
      return false;
    }
  }

  // Carga las cartas desde un fichero JSON
  // Primero intenta cargar desde el directorio de documentos
  // Si no existe carga desde assets y lo copia al directorio de documentos
  readFromJson() async {
    String contenido;
    try {
      // Obtengo el directorio de documentos de la app
      final appDir = await getApplicationDocumentsDirectory();
      final filePath = '${appDir.path}/cards.json';
      File file = File(filePath);

      // Verifico si ya existe el archivo en el directorio de documentos
      if (await file.exists()) {
        // Si existe leo desde el archivo local
        contenido = await file.readAsString();
      } else {
        // Si no existe cargo desde assets y lo copio al directorio de documentos
        contenido = await rootBundle.loadString('assets/jsons/cards.json');
        // Guardo una copia en el directorio de documentos para futuras lecturas y escrituras
        await file.writeAsString(contenido);
      }
    } catch (e) {
      print("ERROR LEYENDO EL ARCHIVO: $e");
      return -1;
    }

    // Si el fichero esta vacio tampoco hay nada que cargar
    if (contenido.trim().isEmpty) return 0;

    // Decodifico el string JSON a una lista de datos
    var datos = jsonDecode(contenido);
    // Vacio la lista actual antes de cargar las nuevas
    cards = [];

    // Recorro los datos y creo un objeto Card por cada uno
    // La calidad se convierte de string a CardCondition usando el metodo fromString
    for (Map<String, dynamic> dato in datos) {
      cards.add(
        Card(
          codigo: dato['codigo'],
          nombre: dato['nombre'],
          calidad: CardConditionExtension.fromString(dato['calidad']),
          coleccion: dato['coleccion'],
          precio: dato['precio'],
          imagenPath: dato['imagenPath'],
        ),
      );
    }
    // Actualizo el contador al codigo mas alto que haya cargado
    // Asi la proxima carta que anada tendra un codigo correlativo y unico

    contador = cards.map((c) => c.codigo).reduce((a, b) => a > b ? a : b);

    return 1;
  }

  // Sobrescribo toString para mostrar la lista completa de forma legible
  @override
  String toString() {
    // Uso un StringBuffer por eficiencia es mejor que concatenar strings en un bucle
    StringBuffer cardList = StringBuffer();
    for (Card c in cards) {
      // Aprovecho el toString de la clase Card
      cardList.write(c);
    }
    return cardList.toString();
  }
}
