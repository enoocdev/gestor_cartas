import 'package:flutter/material.dart';
import 'Theme/AppTheme.dart';
import 'Pages/MainLayout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Defino el estado inicial usa eñ del sistema por defecto
  ThemeMode _theme = ThemeMode.system;

  // Funcion para alternar entre temas
  swapTheme() {
    setState(() {
      // Si es dark pasa a light si no pasa a dark
      _theme = _theme == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Gestor de cartas",
      theme: AppTheme.lightTheme, // Estilo claro de la pagina
      darkTheme: AppTheme.darkTheme, // Estilo oscuro de la pagiina
      themeMode: _theme, // Controla que tema se muestra actualmente
      // Pasamos la función swapTheme a la página principal para poder usarla alli
      home: MainLayout(changeTheme: swapTheme),
      debugShowCheckedModeBanner: false,
    );
  }
}
