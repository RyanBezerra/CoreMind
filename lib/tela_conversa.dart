import 'package:flutter/material.dart';

class TelaConversa extends StatefulWidget {
  const TelaConversa({super.key});

  @override
  State<TelaConversa> createState() => _TelaConversaState();
}

class _TelaConversaState extends State<TelaConversa> with SingleTickerProviderStateMixin {
  final TextEditingController _controladorTexto = TextEditingController();
  final List<Mensagem> _mensagens = [];
  bool _estaDigitando = false;
  late AnimationController _animacaoController;
  late Animation<double> _animacaoFade;
  late Animation<Offset> _animacaoSlide;
  final ScrollController _scrollController = ScrollController();

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

    // Mensagem inicial do assistente
    _mensagens.add(
      Mensagem(
        texto: 'Olá! Sou seu assistente virtual. Como posso ajudar você hoje?',
        eUsuario: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    _controladorTexto.dispose();
    _animacaoController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _rolarParaBaixo() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _enviarMensagem() {
    if (_controladorTexto.text.trim().isEmpty) return;

    setState(() {
      _mensagens.add(
        Mensagem(
          texto: _controladorTexto.text,
          eUsuario: true,
          timestamp: DateTime.now(),
        ),
      );
      _estaDigitando = true;
    });

    _controladorTexto.clear();
    _rolarParaBaixo();

    // Simular resposta do assistente
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _mensagens.add(
            Mensagem(
              texto: 'Esta é uma resposta simulada do assistente. Em breve, será integrada com a API de IA.',
              eUsuario: false,
              timestamp: DateTime.now(),
            ),
          );
          _estaDigitando = false;
        });
        _rolarParaBaixo();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.red.withOpacity(0.2),
              child: const Icon(
                Icons.smart_toy,
                color: Colors.red,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Assistente Virtual',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // Implementar menu de opções
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              reverse: true,
              itemCount: _mensagens.length,
              itemBuilder: (context, index) {
                final mensagem = _mensagens[_mensagens.length - 1 - index];
                return _construirMensagem(mensagem);
              },
            ),
          ),
          if (_estaDigitando)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const SizedBox(width: 12.0),
                  const Text(
                    'Assistente está digitando',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(width: 8.0),
                  SizedBox(
                    width: 16.0,
                    height: 16.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          _construirCampoEntrada(),
        ],
      ),
    );
  }

  Widget _construirMensagem(Mensagem mensagem) {
    return SlideTransition(
      position: _animacaoSlide,
      child: FadeTransition(
        opacity: _animacaoFade,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: mensagem.eUsuario ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!mensagem.eUsuario) ...[
                CircleAvatar(
                  backgroundColor: Colors.red.withOpacity(0.2),
                  child: const Icon(Icons.smart_toy, color: Colors.red),
                ),
                const SizedBox(width: 8.0),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    color: mensagem.eUsuario ? Colors.red : Colors.grey[900],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mensagem.texto,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        _formatarHora(mensagem.timestamp),
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (mensagem.eUsuario) ...[
                const SizedBox(width: 8.0),
                CircleAvatar(
                  backgroundColor: Colors.red.withOpacity(0.2),
                  child: const Icon(Icons.person, color: Colors.red),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirCampoEntrada() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8.0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controladorTexto,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Digite sua mensagem...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
              ),
              onSubmitted: (_) => _enviarMensagem(),
            ),
          ),
          const SizedBox(width: 8.0),
          FloatingActionButton(
            backgroundColor: Colors.red,
            child: const Icon(Icons.send),
            onPressed: _enviarMensagem,
          ),
        ],
      ),
    );
  }

  String _formatarHora(DateTime timestamp) {
    final hora = timestamp.hour.toString().padLeft(2, '0');
    final minuto = timestamp.minute.toString().padLeft(2, '0');
    return '$hora:$minuto';
  }
}

class Mensagem {
  final String texto;
  final bool eUsuario;
  final DateTime timestamp;

  Mensagem({
    required this.texto,
    required this.eUsuario,
    required this.timestamp,
  });
} 