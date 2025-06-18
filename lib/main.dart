import 'package:flutter/material.dart';
import 'tela_login.dart';
import 'tela_cadastro.dart';
import 'services/database_service.dart';

void main() async {
  print('Iniciando aplicação...');
  WidgetsFlutterBinding.ensureInitialized();
  print('WidgetsFlutterBinding inicializado');
  
  try {
    await DatabaseService.initialize();
    print('Banco de dados inicializado com sucesso!');
  } catch (e) {
    print('Erro ao inicializar banco de dados: $e');
    print('Continuando sem inicialização do banco de dados...');
  }
  
  print('Executando aplicação...');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoreMind',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.red,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.red,
          secondary: Colors.red,
          surface: Colors.black,
          background: Colors.black,
        ),
      ),
      home: const TelaLogin(),
    );
  }
} 