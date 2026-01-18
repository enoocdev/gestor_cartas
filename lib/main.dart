// Importamos el paquete principal de Flutter para usar los widgets de Material Design
import 'package:flutter/material.dart';
// Importamos el tema personalizado de la aplicacion
import 'Theme/AppTheme.dart';
// Importamos el layout principal que contiene la navegacion
import 'Pages/MainLayout.dart';

// Funcion principal que inicia la aplicacion
void main() {
  runApp(const MyApp());
}

// Widget raiz de la aplicacion que configura el tema y la navegacion
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Defino el estado inicial que usa el tema del sistema por defecto
  ThemeMode _theme = ThemeMode.system;

  // Funcion para alternar entre el tema claro y oscuro
  swapTheme() {
    setState(() {
      // Si es dark pasa a light si no pasa a dark
      _theme = _theme == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Titulo de la aplicacion que aparece en el sistema
      title: "Gestor de cartas",
      // Estilo claro de la aplicacion
      theme: AppTheme.lightTheme,
      // Estilo oscuro de la aplicacion
      darkTheme: AppTheme.darkTheme,
      // Controla que tema se muestra actualmente
      themeMode: _theme,
      // Pasamos la funcion swapTheme a la pagina principal para poder usarla alli
      home: MainLayout(changeTheme: swapTheme),
      // Ocultamos el banner de debug en la esquina
      debugShowCheckedModeBanner: false,
    );
  }
}
