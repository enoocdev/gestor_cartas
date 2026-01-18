import 'package:flutter/material.dart';
import 'package:gestor_cartas/Logic/CardList.dart';
import 'package:gestor_cartas/Pages/AddOrUpdatePage.dart';
import 'package:gestor_cartas/widgets/ConditionChip.dart';
import 'package:gestor_cartas/widgets/CardImage.dart';

// widget que se encarga de pintar la lista de cartas
class CardsList extends StatefulWidget {
  const CardsList({super.key, required this.cards});

  // lista de cartas que me pasan desde fuera
  final List<dynamic> cards;

  @override
  State<CardsList> createState() => _CardsListState();
}

class _CardsListState extends State<CardsList> {
  // copia local de la lista para trabajar con ella
  late List<dynamic> _cards;

  // inicio la lista copiando los datos que me llegan
  @override
  void initState() {
    super.initState();
    _cards = [...widget.cards];
  }

  // si me actualizan la lista desde el padre actualizo mi copia
  @override
  void didUpdateWidget(covariant CardsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.cards, widget.cards)) {
      setState(() {
        _cards = List<dynamic>.from(widget.cards);
      });
    }
  }

  // construyo la lista usando un builder por eficiencia
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(), // quito el scroll propio para que use el de la pagina
      itemCount: _cards.length,
      itemBuilder: (context, index) {
        final card = _cards[index];
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
                Expanded(child: Text(card.nombre)),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: Text(
                    // pongo el precio siempre con dos decimales
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
                Expanded(
                  child: Text(
                    card.coleccion,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                // etiqueta de color para el estado
                ConditionChip(condition: card.calidad),
              ],
            ),

            trailing: const Icon(Icons.edit),

            // al tocar voy a editar y al volver refresco la lista
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
