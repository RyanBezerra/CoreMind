import 'package:flutter/material.dart';
import 'tela_conversa.dart';
import 'tela_salvos.dart';
import 'tela_assistente.dart';
import 'tela_perfil.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> with SingleTickerProviderStateMixin {
  late AnimationController _animacaoController;
  late Animation<double> _animacaoFade;
  late Animation<Offset> _animacaoSlide;
  int _indiceAtual = 0;

  final List<Widget> _telas = [
    const TelaConversa(),
    const TelaSalvos(),
    const TelaAssistente(),
    const TelaPerfil(),
  ];

  @override
  void initState() {
    super.initState();
    _animacaoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animacaoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animacaoController,
        curve: Curves.easeOutCubic,
      ),
    );
    _animacaoSlide = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animacaoController,
        curve: Curves.easeOutCubic,
      ),
    );
    _animacaoController.forward();
  }

  @override
  void dispose() {
    _animacaoController.dispose();
    super.dispose();
  }

  void _mudarTela(int indice) {
    setState(() {
      _indiceAtual = indice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _telas[_indiceAtual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        onTap: _mudarTela,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Conversas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Salvos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy),
            label: 'Assistente',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
} 