import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gestor_cartas/Logic/CardList.dart';
import 'package:gestor_cartas/Pages/CardsPage.dart';
import 'package:gestor_cartas/Pages/MainPage.dart';
import 'package:material_symbols_icons/symbols.dart';

class MainLayout extends StatefulWidget {
  final Function changeTheme;
  const MainLayout({super.key, required this.changeTheme});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final Cardlist _cardlist = Cardlist();
  int _selectedIndex = 0;

  bool _loading = false;

  loadCards() async {
    setState(() {
      _loading = true;
    });

    await _cardlist.readFromJson("assets/jsons/cards.json");

    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadCards();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [MainPage(), CardsPage()];

    return Scaffold(
      appBar: AppBar(
        title: Text("Gestor de cartas"),
        centerTitle: true,
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
