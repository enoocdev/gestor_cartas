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
  ThemeMode _theme = ThemeMode.system;

  cambiarTema() {
    setState(() {
      _theme = _theme == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Gestor de cartas",
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _theme,
      home: MainLayout(),
    );
  }
}
