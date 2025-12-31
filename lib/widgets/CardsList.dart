import 'package:flutter/material.dart';
import 'package:gestor_cartas/Pages/AddOrUpdatePage.dart';
import 'package:gestor_cartas/widgets/ConditionChip.dart';

// Este widget se encarga de dibujar la lista de cartas de forma individual
class CardsList extends StatelessWidget {
  const CardsList({super.key, required this.cards});

  // Recibe la lista de cartas que tiene que mostrar por pantalla
  final List<dynamic> cards;

  @override
  Widget build(BuildContext context) {
    // Se usa un builder para generar los elementos
    return ListView.builder(
      shrinkWrap: true, // Hace que la lista ocupe solo el espacio de sus hijos
      physics:
          NeverScrollableScrollPhysics(), // Delega el scroll al widget padre para evitar conflictos
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card =
            cards[index]; // Se extrae la informacion de la carta actual por su indice
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
                // El nombre ocupa todo el espacio disponible a la izquierda
                Expanded(child: Text(card.nombre)),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 5),

                  child: Text(
                    // Se formatea el precio para que siempre muestre dos decimales
                    "${card.precio.toStringAsFixed(2)} €",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ],
            ),

            subtitle: Row(
              children: [
                // Texto pequeño para identificar a que coleccion pertenece la carta
                Expanded(
                  child: Text(card.coleccion, style: TextStyle(fontSize: 12)),
                ),
                // Widget que muestra una etiqueta de color segun el estado de la carta
                ConditionChip(condition: card.calidad),
              ],
            ),

            // Icono de lapiz para indicar visualmente que se puede editar
            trailing: Icon(Icons.edit),

            // Al tocar la carta se abre la pantalla de edicion pasando los datos actuales
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
