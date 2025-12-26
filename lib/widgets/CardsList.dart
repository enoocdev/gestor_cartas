import 'package:flutter/material.dart';
import 'package:gestor_cartas/Pages/AddOrUpdatePage.dart';
import 'package:gestor_cartas/widgets/ConditionChip.dart';

class CardsList extends StatelessWidget {
  const CardsList({super.key, required this.cards});

  final List<dynamic> cards;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: ListTile(
            leading: ClipRRect(
              // ClipRRect redondea la imagen
              borderRadius: BorderRadius.circular(200),
              child: Image.asset(
                "assets/images/underground_sea.jpg",
                fit: BoxFit.cover,
                width: 50,
                height: 50,
              ),
            ),
            title: Row(
              children: [
                Expanded(child: Text(card.nombre)),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 5),

                  child: Text(
                    "${card.precio.toStringAsFixed(2)} €", // Variable: orderedList[index].precio
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ],
            ),

            subtitle: Row(
              children: [
                Expanded(
                  child: Text(card.coleccion, style: TextStyle(fontSize: 12)),
                ),
                ConditionChip(condition: card.calidad),
              ],
            ),

            trailing: Icon(Icons.edit),

            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddOrUpdatePage(card: card),
              ),
            ),
          ),
        );
      },
    );
  }
}
