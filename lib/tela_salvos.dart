import 'package:flutter/material.dart';
import 'models/usuario.dart';
import 'models/conversa.dart';
import 'services/database_service.dart';
import 'tela_conversa.dart';

class TelaSalvos extends StatefulWidget {
  final Usuario usuario;

  const TelaSalvos({
    super.key,
    required this.usuario,
  });

  @override
  State<TelaSalvos> createState() => _TelaSalvosState();
}

class _TelaSalvosState extends State<TelaSalvos> {
  final DatabaseService _databaseService = DatabaseService();
  List<Conversa> _conversas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarConversas();
  }

  Future<void> _carregarConversas() async {
    print('=== CARREGANDO CONVERSAS SALVAS ===');
    print('ID do usuário: ${widget.usuario.id}');
    print('Email do usuário: ${widget.usuario.email}');
    
    setState(() {
      _isLoading = true;
    });

    try {
      print('>>> INICIANDO BUSCA DE CONVERSAS <<<');
      
      // BUSCAR CONVERSAS QUE TÊM MENSAGENS
      final conversas = await _databaseService.buscarConversasComMensagens(widget.usuario.id!);
      print('>>> CONVERSAS COM MENSAGENS ENCONTRADAS: ${conversas.length} <<<');
      
      // LOG DETALHADO DE CADA CONVERSA
      for (int i = 0; i < conversas.length; i++) {
        final conversa = conversas[i];
        print('>>> CONVERSA ${i + 1}: <<<');
        print('   ID: ${conversa['id']}');
        print('   Título: ${conversa['titulo']}');
        print('   Usuário ID: ${conversa['usuario_id']}');
        print('   Data Criação: ${conversa['data_criacao']}');
      }
      
      final conversasConvertidas = conversas.map((c) => Conversa.fromMap(c)).toList();
      print('>>> CONVERSAS CONVERTIDAS: ${conversasConvertidas.length} <<<');
      
      setState(() {
        _conversas = conversasConvertidas;
      });
      
      print('>>> CARREGAMENTO CONCLUÍDO COM SUCESSO <<<');
      
    } catch (e) {
      print('>>> ❌ ERRO AO CARREGAR CONVERSAS: $e <<<');
      print('>>> Stack trace: ${StackTrace.current} <<<');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar conversas: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _excluirConversa(Conversa conversa) async {
    try {
      await _databaseService.excluirConversa(conversa.id!);
      await _carregarConversas();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Conversa excluída com sucesso')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir conversa: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_conversas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_border,
              size: 80,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhuma conversa salva',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Suas conversas aparecerão aqui',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            // BOTÃO DE DEBUG
            ElevatedButton.icon(
              onPressed: () async {
                print('=== DEBUG: VERIFICANDO TABELAS ===');
                await _databaseService.debugVerificarTabelas(widget.usuario.id!);
              },
              icon: const Icon(Icons.bug_report),
              label: const Text('Debug - Verificar Tabelas'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () async {
                print('=== DEBUG: LIMPANDO TUDO ===');
                await _databaseService.debugLimparTudo(widget.usuario.id!);
                await _carregarConversas();
              },
              icon: const Icon(Icons.delete_forever),
              label: const Text('Debug - Limpar Tudo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () async {
                print('=== DEBUG: VERIFICANDO ESTRUTURA DAS TABELAS ===');
                await _databaseService.debugVerificarEstruturaTabelas();
              },
              icon: const Icon(Icons.table_chart),
              label: const Text('Debug - Estrutura Tabelas'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () async {
                print('=== DEBUG: VERIFICANDO DADOS DAS TABELAS ===');
                await _databaseService.debugVerificarDadosTabelas();
              },
              icon: const Icon(Icons.data_usage),
              label: const Text('Debug - Dados Tabelas'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _carregarConversas,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _conversas.length,
        itemBuilder: (context, index) {
          final conversa = _conversas[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.red,
                child: Icon(Icons.chat, color: Colors.white),
              ),
              title: Text(
                conversa.titulo,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Criada em ${conversa.dataCriacao.day}/${conversa.dataCriacao.month}/${conversa.dataCriacao.year}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'excluir') {
                    _excluirConversa(conversa);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'excluir',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Excluir'),
                      ],
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TelaConversa(
                      usuario: widget.usuario,
                      conversaExistente: conversa,
                    ),
                  ),
                ).then((_) {
                  // Recarregar conversas quando voltar
                  _carregarConversas();
                });
              },
            ),
          );
        },
      ),
    );
  }
} 