import 'package:flutter/material.dart';
import 'tela_inicial.dart';

void main() {
  runApp(const CoreMindApp());
}

class CoreMindApp extends StatelessWidget {
  const CoreMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoreMind',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
        ),
      ),
      home: const TelaInicial(),
    );
  }
} 