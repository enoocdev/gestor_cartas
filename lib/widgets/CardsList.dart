import 'package:flutter/material.dart';
import 'package:gestor_cartas/Logic/CardList.dart';
import 'package:gestor_cartas/Pages/AddOrUpdatePage.dart';
import 'package:gestor_cartas/widgets/ConditionChip.dart';
import 'package:gestor_cartas/widgets/CardImage.dart';

// Este widget se encarga de dibujar la lista de cartas de forma individual
class CardsList extends StatefulWidget {
  const CardsList({super.key, required this.cards});

  // Recibe la lista de cartas que tiene que mostrar por pantalla
  final List<dynamic> cards;

  @override
  State<CardsList> createState() => _CardsListState();
}

class _CardsListState extends State<CardsList> {
  // Copia local de la lista de cartas; el widget trabajará sobre esta variable
  late List<dynamic> _cards;

  @override
  void initState() {
    super.initState();
    // Inicializamos la lista local con una copia de la pasada por el padre
    _cards = [...widget.cards];
  }

  @override
  void didUpdateWidget(covariant CardsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si el padre pasó una lista distinta (por referencia), actualizamos la copia local
    if (!identical(oldWidget.cards, widget.cards)) {
      setState(() {
        _cards = List<dynamic>.from(widget.cards);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Se usa un builder para generar los elementos
    return ListView.builder(
      shrinkWrap: true, // Hace que la lista ocupe solo el espacio de sus hijos
      physics:
          const NeverScrollableScrollPhysics(), // Delega el scroll al widget padre para evitar conflictos
      itemCount: _cards.length,
      itemBuilder: (context, index) {
        final card =
            _cards[index]; // Se extrae la informacion de la carta actual por su indice
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: ListTile(
            leading: CardImage(
              imagePath: card.imagenPath,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(200),
            ),
            title: Row(
              children: [
                // El nombre ocupa todo el espacio disponible a la izquierda
                Expanded(child: Text(card.nombre)),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: Text(
                    // Se formatea el precio para que siempre muestre dos decimales
                    "${card.precio.toStringAsFixed(2)} €",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),

            subtitle: Row(
              children: [
                // Texto pequeno para identificar a que coleccion pertenece la carta
                Expanded(
                  child: Text(
                    card.coleccion,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                // Widget que muestra una etiqueta de color segun el estado de la carta
                // Recibe directamente el valor de la enumeracion CardCondition
                ConditionChip(condition: card.calidad),
              ],
            ),

            // Icono de lapiz para indicar visualmente que se puede editar
            trailing: const Icon(Icons.edit),

            // Al tocar la carta se abre la pantalla de edicion pasando los datos actuales
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddOrUpdatePage(card: card),
                ),
              );

              setState(() {
                _cards = [...Cardlist().cards];
              });
            },
          ),
        );
      },
    );
  }
}
