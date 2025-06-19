import 'package:flutter/material.dart';
import 'models/usuario.dart';
import 'tela_conversa.dart';
import 'tela_salvos.dart';
import 'tela_assistente.dart';
import 'tela_perfil.dart';
import 'tela_login.dart';

class TelaInicial extends StatefulWidget {
  final Usuario usuario;

  const TelaInicial({
    super.key,
    required this.usuario,
  });

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> with SingleTickerProviderStateMixin {
  late AnimationController _animacaoController;
  late Animation<double> _animacaoFade;
  late Animation<Offset> _animacaoSlide;
  int _indiceAtual = 0;

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

  void _fazerLogout() {
    print('Botão Logout do AppBar pressionado');
    
    // Navegação direta para TelaLogin, removendo todas as telas anteriores
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const TelaLogin()),
      (route) => false,
    );
  }

  Widget _obterTelaAtual() {
    switch (_indiceAtual) {
      case 0:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 80,
                color: Colors.grey[600],
              ),
              const SizedBox(height: 16),
              Text(
                'Inicie uma nova conversa',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Clique no botão abaixo para começar',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TelaConversa(usuario: widget.usuario),
                    ),
                  );
                },
                icon: const Icon(Icons.chat),
                label: const Text('Nova Conversa'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        );
      case 1:
        return TelaSalvos(usuario: widget.usuario);
      case 2:
        return TelaAssistente(usuario: widget.usuario);
      case 3:
        return TelaPerfil(usuario: widget.usuario);
      default:
        return Center(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TelaConversa(usuario: widget.usuario),
                ),
              );
            },
            icon: const Icon(Icons.chat),
            label: const Text('Nova Conversa'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CoreMind'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _fazerLogout,
          ),
        ],
      ),
      body: _obterTelaAtual(),
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