import 'package:flutter/material.dart';
import 'package:gestor_cartas/widgets/ColeccionCard.dart';
import 'package:gestor_cartas/widgets/ColeccionTopCards.dart';

// pantalla de inicio que se ve al abrir la app
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // construyo la interfaz permitiendo scroll si no cabe
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            // pongo un tope de ancho para que no se estire mucho
            constraints: const BoxConstraints(maxWidth: 800),
            child: Container(
              margin: EdgeInsets.all(15),
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // widget con el resumen de la coleccion
                  ColeccionCard(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Mejores Cartas",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  // lista con las cartas mas caras
                  ColeccionTopCards(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
