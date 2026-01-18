import 'package:flutter/material.dart';
import 'package:gestor_cartas/Logic/CardList.dart';
import 'package:gestor_cartas/Pages/AddOrUpdatePage.dart';
import 'package:gestor_cartas/widgets/CardsList.dart';

// pantalla donde muestro todas las cartas y el buscador
class CardsPage extends StatefulWidget {
  const CardsPage({super.key});

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  // cargo la lista global de cartas
  final Cardlist _cardlist = Cardlist();
  // lista auxiliar que uso para filtrar
  late List _cards = _cardlist.cards;

  // pinto la pantalla con el boton flotante y la lista
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // voy a la pantalla de crear y espero a que vuelva
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddOrUpdatePage()),
          );
          // cuando vuelve actualizo la lista por si hubo cambios
          setState(() {
            _cards = [...Cardlist().cards];
          });
        },
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            // limito el ancho para que no se vea mal en pantallas grandes
            constraints: const BoxConstraints(maxWidth: 800),

            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Cartas",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        SizedBox(
                          width: 240,
                          child: TextField(
                            decoration: InputDecoration(
                              icon: Icon(Icons.search),
                              hintText: "Buscar...",
                              isDense: true,
                              contentPadding: EdgeInsets.all(8),
                            ),
                            // filtro la lista cada vez que escribo algo
                            onChanged: (text) {
                              setState(() {
                                _cards = _cardlist.searchCard(nombre: text);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  // paso la lista filtrada al widget que las pinta
                  CardsList(cards: _cards),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
