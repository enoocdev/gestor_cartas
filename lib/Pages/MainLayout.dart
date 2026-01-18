import 'package:flutter/material.dart';
import 'package:gestor_cartas/Logic/CardList.dart';
import 'package:gestor_cartas/Pages/CardsPage.dart';
import 'package:gestor_cartas/Pages/MainPage.dart';
import 'package:material_symbols_icons/symbols.dart';

// estructura principal con navegacion y carga de datos
class MainLayout extends StatefulWidget {
  // funcion que me pasan para cambiar el tema
  final Function changeTheme;
  const MainLayout({super.key, required this.changeTheme});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  // uso el singleton para acceder a las cartas
  final Cardlist _cardlist = Cardlist();

  // pagina actual del menu
  int _selectedIndex = 0;

  // para saber si estoy cargando datos
  bool _loading = false;

  // cargo el json de forma asincrona y actualizo la ui
  loadCards() async {
    setState(() {
      _loading = true;
    });

    await _cardlist.readFromJson();

    setState(() {
      _loading = false;
    });
  }

  // cargo los datos al iniciar el widget
  @override
  void initState() {
    super.initState();
    loadCards();
  }

  // defino las paginas y monto el scaffold con la barra de abajo
  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [MainPage(), CardsPage()];

    return Scaffold(
      appBar: AppBar(
        title: Text("Gestor de cartas"),
        centerTitle: true,
        // boton para cambiar entre modo claro y oscuro
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
      // si esta cargando pongo un spinner y si no la pagina que toque
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : pages[_selectedIndex],
      // barra de navegacion para cambiar de pantalla
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(
            icon: Icon(Symbols.playing_cards),
            label: "Cards",
          ),
        ],
        currentIndex: _selectedIndex,
        // cambio el indice cuando pulsan un boton
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
