import 'package:flutter/material.dart';
import 'services/deepseek_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TelaConversa extends StatefulWidget {
  final String? tituloConversa;
  const TelaConversa({super.key, this.tituloConversa});

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
  final DeepSeekService _deepSeekService = DeepSeekService();

  String get _chaveHistorico => widget.tituloConversa != null
      ? 'historico_conversa_${widget.tituloConversa}'
      : 'historico_conversa';

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
    if (widget.tituloConversa != null) {
      _carregarHistoricoConversa();
    } else {
      _salvarEIniciarNovaConversa().then((_) => _carregarHistoricoConversa());
    }
  }

  @override
  void dispose() {
    _salvarConversaAoSair();
    _controladorTexto.dispose();
    _animacaoController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _salvarConversaAoSair() async {
    if (widget.tituloConversa != null) return; // Não sobrescreve histórico de conversa salva
    final prefs = await SharedPreferences.getInstance();
    final historico = prefs.getStringList('historico_conversa') ?? [];
    if (historico.isNotEmpty) {
      String? titulo;
      String? ultimaMensagem;
      DateTime? data;
      for (var msgStr in historico) {
        final map = jsonDecode(msgStr);
        if (titulo == null && map['eUsuario'] == true) {
          titulo = map['texto'];
        }
        if (map['eUsuario'] == false) {
          ultimaMensagem = map['texto'];
          data = DateTime.parse(map['timestamp']);
        }
      }
      if (titulo != null && ultimaMensagem != null && data != null) {
        await _salvarConversa(titulo, ultimaMensagem, data);
        await prefs.setStringList('historico_conversa_$titulo', historico);
      }
    }
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

  Future<void> _salvarConversa(String titulo, String ultimaMensagem, DateTime data) async {
    final prefs = await SharedPreferences.getInstance();
    final conversas = prefs.getStringList('conversas_salvas') ?? [];
    List<Map<String, dynamic>> listaConversas = conversas.map((c) => jsonDecode(c) as Map<String, dynamic>).toList();

    // Verifica se já existe uma conversa com o mesmo título
    final idx = listaConversas.indexWhere((c) => c['titulo'] == titulo);
    if (idx != -1) {
      // Atualiza a última mensagem e data
      listaConversas[idx]['ultimaMensagem'] = ultimaMensagem;
      listaConversas[idx]['data'] = data.toIso8601String();
    } else {
      // Adiciona nova conversa
      listaConversas.add({
        'titulo': titulo,
        'ultimaMensagem': ultimaMensagem,
        'data': data.toIso8601String(),
        'categorias': ['Geral'],
      });
    }
    final conversasJson = listaConversas.map((c) => jsonEncode(c)).toList();
    await prefs.setStringList('conversas_salvas', conversasJson);

    print('Salvando conversa: título=$titulo, últimaMensagem=$ultimaMensagem, data=$data');
    print('Lista final de conversas: ' + listaConversas.toString());
  }

  Future<void> _salvarEIniciarNovaConversa() async {
    final prefs = await SharedPreferences.getInstance();
    final historico = prefs.getStringList('historico_conversa') ?? [];
    if (historico.isNotEmpty) {
      String? titulo;
      String? ultimaMensagem;
      DateTime? data;
      for (var msgStr in historico) {
        final map = jsonDecode(msgStr);
        if (titulo == null && map['eUsuario'] == true) {
          titulo = map['texto'];
        }
        if (map['eUsuario'] == false) {
          ultimaMensagem = map['texto'];
          data = DateTime.parse(map['timestamp']);
        }
      }
      if (titulo != null && ultimaMensagem != null && data != null) {
        await _salvarConversa(titulo, ultimaMensagem, data);
        // Salva o histórico completo dessa conversa
        await prefs.setStringList('historico_conversa_$titulo', historico);
      }
    }
    await prefs.remove('historico_conversa');
  }

  Future<void> _salvarHistoricoConversa() async {
    final prefs = await SharedPreferences.getInstance();
    final historico = _mensagens.map((m) => jsonEncode({
      'texto': m.texto,
      'eUsuario': m.eUsuario,
      'timestamp': m.timestamp.toIso8601String(),
    })).toList();
    await prefs.setStringList(_chaveHistorico, historico);
  }

  Future<void> _carregarHistoricoConversa() async {
    final prefs = await SharedPreferences.getInstance();
    final historico = prefs.getStringList(_chaveHistorico) ?? [];
    setState(() {
      _mensagens.clear();
      for (var msgStr in historico) {
        final map = jsonDecode(msgStr);
        _mensagens.add(Mensagem(
          texto: map['texto'],
          eUsuario: map['eUsuario'],
          timestamp: DateTime.parse(map['timestamp']),
        ));
      }
      if (_mensagens.isEmpty) {
        _mensagens.add(
          Mensagem(
            texto: 'Olá! Sou seu assistente virtual. Como posso ajudar você hoje?',
            eUsuario: false,
            timestamp: DateTime.now(),
          ),
        );
      }
    });
  }

  void _enviarMensagem() async {
    if (_controladorTexto.text.trim().isEmpty) return;

    final mensagemUsuario = _controladorTexto.text;
    final primeiraMensagem = _mensagens.where((m) => m.eUsuario).isEmpty;
    setState(() {
      _mensagens.add(
        Mensagem(
          texto: mensagemUsuario,
          eUsuario: true,
          timestamp: DateTime.now(),
        ),
      );
      _estaDigitando = true;
    });
    await _salvarHistoricoConversa();

    _controladorTexto.clear();
    _rolarParaBaixo();

    try {
      final resposta = await _deepSeekService.sendMessage(
        mensagemUsuario,
        _mensagens.where((m) => m.eUsuario || m.eUsuario == false).toList(),
      );
      if (mounted) {
        setState(() {
          _mensagens.add(
            Mensagem(
              texto: resposta,
              eUsuario: false,
              timestamp: DateTime.now(),
            ),
          );
          _estaDigitando = false;
        });
        await _salvarHistoricoConversa();
        _rolarParaBaixo();
        if (primeiraMensagem) {
          await _salvarConversa(
            mensagemUsuario,
            resposta,
            DateTime.now(),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _mensagens.add(
            Mensagem(
              texto: 'Desculpe, ocorreu um erro ao processar sua mensagem. Por favor, tente novamente.',
              eUsuario: false,
              timestamp: DateTime.now(),
            ),
          );
          _estaDigitando = false;
        });
        await _salvarHistoricoConversa();
        _rolarParaBaixo();
      }
    }
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