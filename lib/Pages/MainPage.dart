import 'package:flutter/material.dart';
import 'package:gestor_cartas/widgets/ColeccionCard.dart';
import 'package:gestor_cartas/widgets/ColeccionTopCards.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            // Esto ajusta que cuando la pantalla se hace grande
            // lo maximo de anchura que pude tnr es de 800 px
            constraints: const BoxConstraints(maxWidth: 800),
            child: Container(
              margin: EdgeInsets.all(15),
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [ColeccionCard(), ColeccionTopCards()],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
