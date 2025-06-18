import 'package:flutter/material.dart';
import 'models/usuario.dart';
import 'models/conversa.dart';
import 'models/mensagem.dart';
import 'services/database_service.dart';
import 'services/deepseek_service.dart';

class TelaConversa extends StatefulWidget {
  final Usuario usuario;
  final Conversa? conversaExistente;

  const TelaConversa({
    super.key,
    required this.usuario,
    this.conversaExistente,
  });

  @override
  State<TelaConversa> createState() => _TelaConversaState();
}

class _TelaConversaState extends State<TelaConversa> {
  final TextEditingController _mensagemController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final DatabaseService _databaseService = DatabaseService();
  final DeepSeekService _deepSeekService = DeepSeekService();
  
  List<Mensagem> _mensagens = [];
  bool _isLoading = false;
  int? _conversaId;

  @override
  void initState() {
    super.initState();
    print('=== TELA CONVERSA INICIALIZADA ===');
    print('Usuário ID: ${widget.usuario.id}');
    _carregarConversaExistente();
  }

  @override
  void dispose() {
    _mensagemController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _carregarConversaExistente() async {
    if (widget.conversaExistente != null) {
      _conversaId = widget.conversaExistente!.id;
      final mensagens = await _databaseService.buscarMensagensDaConversa(_conversaId!);
      setState(() {
        _mensagens = mensagens.map((m) => Mensagem.fromMap(m)).toList();
      });
    }
  }

  Future<void> _enviarMensagem() async {
    final texto = _mensagemController.text.trim();
    if (texto.isEmpty) return;

    print('=== ENVIANDO MENSAGEM ===');
    print('Texto: "$texto"');

    setState(() {
      _isLoading = true;
      _mensagemController.clear();
    });

    try {
      // 1. CRIAR CONVERSA SE NÃO EXISTIR
      if (_conversaId == null) {
        print('>>> CRIANDO CONVERSA <<<');
        _conversaId = await _databaseService.criarConversa(
          widget.usuario.id!,
          texto.length > 30 ? '${texto.substring(0, 30)}...' : texto,
        );
        print('>>> CONVERSA CRIADA: $_conversaId <<<');
      }

      // 2. SALVAR MENSAGEM DO USUÁRIO
      print('>>> SALVANDO MENSAGEM USUÁRIO <<<');
      final mensagemUsuarioId = await _databaseService.criarMensagem(_conversaId!, texto, true);
      print('>>> MENSAGEM USUÁRIO SALVA: $mensagemUsuarioId <<<');

      // 3. ADICIONAR À LISTA
      final mensagemUsuario = Mensagem(
        id: mensagemUsuarioId,
        conversaId: _conversaId!,
        texto: texto,
        eUsuario: true,
        dataCriacao: DateTime.now(),
      );
      
      setState(() {
        _mensagens.add(mensagemUsuario);
      });

      // 4. OBTER RESPOSTA DO BOT
      print('>>> OBTENDO RESPOSTA BOT <<<');
      final resposta = await _deepSeekService.sendMessage(texto, _mensagens);
      print('>>> RESPOSTA OBTIDA <<<');

      // 5. SALVAR RESPOSTA DO BOT
      print('>>> SALVANDO RESPOSTA BOT <<<');
      final mensagemBotId = await _databaseService.criarMensagem(_conversaId!, resposta, false);
      print('>>> RESPOSTA BOT SALVA: $mensagemBotId <<<');

      // 6. ADICIONAR À LISTA
      final mensagemBot = Mensagem(
        id: mensagemBotId,
        conversaId: _conversaId!,
        texto: resposta,
        eUsuario: false,
        dataCriacao: DateTime.now(),
      );
      
      setState(() {
        _mensagens.add(mensagemBot);
      });

      print('>>> ✅ MENSAGEM ENVIADA COM SUCESSO <<<');

      // ROLAR PARA BAIXO
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });

    } catch (e) {
      print('>>> ❌ ERRO: $e <<<');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _criarConversaTeste() async {
    print('=== CRIANDO CONVERSA DE TESTE ===');
    
    try {
      // CRIAR CONVERSA
      print('>>> CRIANDO CONVERSA DE TESTE <<<');
      final conversaId = await _databaseService.criarConversa(
        widget.usuario.id!,
        'Conversa de Teste - ${DateTime.now().toString().substring(11, 19)}',
      );
      print('>>> CONVERSA DE TESTE CRIADA COM ID: $conversaId <<<');
      
      // CRIAR MENSAGEM DO USUÁRIO
      print('>>> CRIANDO MENSAGEM DO USUÁRIO DE TESTE <<<');
      final mensagemUsuarioId = await _databaseService.criarMensagem(
        conversaId,
        'Esta é uma mensagem de teste do usuário',
        true,
      );
      print('>>> MENSAGEM USUÁRIO DE TESTE CRIADA COM ID: $mensagemUsuarioId <<<');
      
      // CRIAR MENSAGEM DO BOT
      print('>>> CRIANDO MENSAGEM DO BOT DE TESTE <<<');
      final mensagemBotId = await _databaseService.criarMensagem(
        conversaId,
        'Esta é uma resposta de teste do bot',
        false,
      );
      print('>>> MENSAGEM BOT DE TESTE CRIADA COM ID: $mensagemBotId <<<');
      
      // VERIFICAR SE TUDO FOI SALVO
      print('>>> VERIFICANDO SE TUDO FOI SALVO <<<');
      final mensagens = await _databaseService.buscarMensagensDaConversa(conversaId);
      print('>>> MENSAGENS NA CONVERSA DE TESTE: ${mensagens.length} <<<');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Conversa de teste criada! ID: $conversaId, Mensagens: ${mensagens.length}'),
            backgroundColor: Colors.green,
          ),
        );
      }
      
    } catch (e) {
      print('>>> ❌ ERRO AO CRIAR CONVERSA DE TESTE: $e <<<');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao criar conversa de teste: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.conversaExistente?.titulo ?? 'Nova Conversa'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          // BOTÃO DE TESTE GRANDE
          TextButton.icon(
            onPressed: _criarConversaTeste,
            icon: const Icon(Icons.science, color: Colors.white),
            label: const Text('TESTE', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          // BOTÃO DE TESTE GRANDE NO TOPO
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.orange,
            child: ElevatedButton.icon(
              onPressed: _criarConversaTeste,
              icon: const Icon(Icons.science),
              label: const Text('CRIAR CONVERSA DE TESTE'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.orange,
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),
          Expanded(
            child: _isLoading && _mensagens.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _mensagens.length,
                    itemBuilder: (context, index) {
                      final mensagem = _mensagens[index];
                      return _MensagemWidget(mensagem: mensagem);
                    },
                  ),
          ),
          if (_isLoading && _mensagens.isNotEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 16),
                  Text('Digitando...'),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _mensagemController,
                    decoration: const InputDecoration(
                      hintText: 'Digite sua mensagem...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _enviarMensagem(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _isLoading ? null : _enviarMensagem,
                  icon: const Icon(Icons.send),
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MensagemWidget extends StatelessWidget {
  final Mensagem mensagem;

  const _MensagemWidget({required this.mensagem});

  @override
  Widget build(BuildContext context) {
    final isUsuario = mensagem.eUsuario;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUsuario ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUsuario) ...[
            CircleAvatar(
              backgroundColor: Colors.red,
              child: const Icon(Icons.smart_toy, color: Colors.white),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUsuario ? Colors.red : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                mensagem.texto,
                style: TextStyle(
                  color: isUsuario ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          if (isUsuario) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }
} 