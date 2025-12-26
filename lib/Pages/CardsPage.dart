import 'package:flutter/material.dart';
import 'package:gestor_cartas/Logic/CardList.dart';
import 'package:gestor_cartas/Pages/AddOrUpdatePage.dart';
import 'package:gestor_cartas/widgets/CardsList.dart';

class CardsPage extends StatefulWidget {
  const CardsPage({super.key});

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  final Cardlist _cardlist = Cardlist();
  late List cards = _cardlist.cards;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddOrUpdatePage()),
        ),
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            // Esto ajusta que cuando la pantalla se hace grande
            // lo maximo de anchura que pude tnr es de 800 px
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
                          width: 240, // Le damos 200 pixeles de ancho
                          child: TextField(
                            decoration: InputDecoration(
                              icon: Icon(Icons.search),
                              hintText: "Buscar...",
                              isDense: true, // Lo hace más compacto
                              contentPadding: EdgeInsets.all(8),
                            ),
                            onChanged: (text) {
                              setState(() {
                                cards = _cardlist.searchCard(nombre: text);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  CardsList(cards: cards),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
