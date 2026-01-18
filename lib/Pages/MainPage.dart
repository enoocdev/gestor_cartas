import 'package:flutter/material.dart';
import 'package:gestor_cartas/widgets/ColeccionCard.dart';
import 'package:gestor_cartas/widgets/ColeccionTopCards.dart';

// Esta clase define la vista de inicio que se muestra al abrir la app
// Es un StatefulWidget aunque actualmente no maneja estado dinamico
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Se usa SingleChildScrollView para que se pueda hacer scroll si el contenido es muy largo
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            // Esto ajusta que cuando la pantalla se hace grande
            // lo maximo de anchura que puede tener es de 800 pixeles
            constraints: const BoxConstraints(maxWidth: 800),
            child: Container(
              // Se aplica un margen externo de 15 pixeles en todos los lados
              margin: EdgeInsets.all(15),
              child: Column(
                // Espaciado automatico de 10 pixeles entre cada elemento
                spacing: 10,
                // Hace que los hijos ocupen todo el ancho disponible
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Widget personalizado que muestra informacion general de la coleccion
                  ColeccionCard(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    // Titulo de la seccion de mejores cartas
                    child: Text(
                      "Mejores Cartas",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  // Widget que muestra las cartas con mayor precio de la coleccion
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
