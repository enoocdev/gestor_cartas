import 'package:flutter/material.dart';
import 'package:gestor_cartas/Logic/CardList.dart';
import 'package:gestor_cartas/Pages/AddOrUpdatePage.dart';
import 'package:gestor_cartas/widgets/CardsList.dart';

// Esta pantalla se encarga de mostrar todas las cartas y permitir la busqueda
// Es un StatefulWidget porque maneja el estado del filtro de busqueda
class CardsPage extends StatefulWidget {
  const CardsPage({super.key});

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  // Referencia a la logica centralizada de las cartas usando el singleton
  final Cardlist _cardlist = Cardlist();
  // Variable para guardar la lista que se va a mostrar segun el filtro aplicado
  late List _cards = _cardlist.cards;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Boton circular flotante para ir a la pantalla de agregar una nueva carta
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navegamos a la pantalla de agregar carta y esperamos el resultado
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddOrUpdatePage()),
          );
          // Al volver actualizamos la lista para reflejar los cambios
          setState(() {
            _cards = [...Cardlist().cards];
          });
        },
        // Icono de mas para indicar que se puede agregar
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            // Esto ajusta que cuando la pantalla se hace grande
            // lo maximo de anchura que puede tener es de 800 pixeles
            constraints: const BoxConstraints(maxWidth: 800),

            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  // Espacio superior
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 15),
                    child: Row(
                      children: [
                        // Titulo de la seccion alineado a la izquierda
                        Expanded(
                          child: Text(
                            "Cartas",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // Contenedor con ancho fijo para el buscador
                        SizedBox(
                          width: 240,
                          child: TextField(
                            decoration: InputDecoration(
                              // Icono de lupa para indicar busqueda
                              icon: Icon(Icons.search),
                              hintText: "Buscar...",
                              // Lo hace mas compacto visualmente
                              isDense: true,
                              contentPadding: EdgeInsets.all(8),
                            ),
                            // Cada vez que el usuario escribe se filtra la lista
                            onChanged: (text) {
                              setState(() {
                                // Se llama al buscador de la logica y se refresca la vista
                                _cards = _cardlist.searchCard(nombre: text);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Linea divisoria para separar la busqueda de la lista
                  const Divider(),
                  // Se le pasa la lista filtrada al widget que dibuja las cartas
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
