import 'package:flutter/material.dart';
import 'package:gestor_cartas/Logic/CardList.dart';
import 'package:gestor_cartas/Pages/CardsPage.dart';
import 'package:gestor_cartas/Pages/MainPage.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:gestor_cartas/constants.dart';

/// Widget que define la estructura principal de la interfaz
/// Utiliza un StatefulWidget porque maneja el estado de la navegación y la carga de datos
class MainLayout extends StatefulWidget {
  // Recibe la función para cambiar el tema desde
  final Function changeTheme;
  const MainLayout({super.key, required this.changeTheme});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  // Instancia de la gestion de las cartas
  final Cardlist _cardlist = Cardlist();

  // Pagina actual
  int _selectedIndex = 0;

  // Estado para saber si se estan cargando los datos
  bool _loading = false;

  /// Metodo asincrono para cargar las cartas desde el JSON
  /// Gestiona el estado de carga para mostrar un indicador visual mientras se lee el archivo
  loadCards() async {
    setState(() {
      _loading = true;
    });

    // Llamada al método de la lógica para leer los datos del JSON
    await _cardlist.readFromJson(pathJson);

    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    // Se ejecuta una sola vez al insertar el widget
    super.initState();

    // Se ejecuta la carga de los datos
    loadCards();
  }

  @override
  Widget build(BuildContext context) {
    // Definicion de las pantallas disponibles para la navegacion
    final List<Widget> pages = [MainPage(), CardsPage()];

    return Scaffold(
      appBar: AppBar(
        title: Text("Gestor de cartas"),
        centerTitle: true,
        // Boton de cambio de tema cambia de icono segun el brillo actual de la app.
        leading: Theme.of(context).brightness == Brightness.dark
            ? IconButton(
                onPressed: () => widget.changeTheme(),
                icon: Icon(Icons.dark_mode),
              )
            : IconButton(
                onPressed: () => widget.changeTheme(),
                icon: Icon(Icons.light_mode),
              ),
      ),
      // Si esta cargando muestra un círculo de progreso. Si no, muestra la pagina seleccionada
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(
            icon: Icon(Symbols.playing_cards),
            label: "Cards",
          ),
        ],
        currentIndex: _selectedIndex,
        // Al pulsar un item, actualiza el índice y redibuja la interfaz
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        showUnselectedLabels: false,
      ),
    );
  }
}
