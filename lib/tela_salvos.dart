import 'package:flutter/material.dart';
import 'tela_conversa.dart';

class TelaSalvos extends StatefulWidget {
  const TelaSalvos({super.key});

  @override
  State<TelaSalvos> createState() => _TelaSalvosState();
}

class _TelaSalvosState extends State<TelaSalvos> with SingleTickerProviderStateMixin {
  late AnimationController _animacaoController;
  late Animation<double> _animacaoFade;
  late Animation<Offset> _animacaoSlide;
  String _categoriaSelecionada = 'Todas';

  final List<Map<String, dynamic>> _conversasSalvas = [
    {
      'titulo': 'Flutter - Dicas de Desenvolvimento',
      'ultimaMensagem': 'Aqui estão algumas dicas para melhorar seu código Flutter...',
      'data': DateTime.now().subtract(const Duration(hours: 2)),
      'categoria': 'Desenvolvimento',
    },
    {
      'titulo': 'UI/UX - Melhores Práticas',
      'ultimaMensagem': 'Para criar interfaces mais intuitivas, considere...',
      'data': DateTime.now().subtract(const Duration(days: 1)),
      'categoria': 'Design',
    },
    {
      'titulo': 'Integração com APIs',
      'ultimaMensagem': 'Para integrar APIs de forma eficiente...',
      'data': DateTime.now().subtract(const Duration(days: 2)),
      'categoria': 'Desenvolvimento',
    },
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

  List<Map<String, dynamic>> _filtrarConversas() {
    if (_categoriaSelecionada == 'Todas') {
      return _conversasSalvas;
    }
    return _conversasSalvas.where((conversa) => conversa['categoria'] == _categoriaSelecionada).toList();
  }

  String _formatarData(DateTime data) {
    final agora = DateTime.now();
    final diferenca = agora.difference(data);

    if (diferenca.inDays > 0) {
      return '${diferenca.inDays}d atrás';
    } else if (diferenca.inHours > 0) {
      return '${diferenca.inHours}h atrás';
    } else if (diferenca.inMinutes > 0) {
      return '${diferenca.inMinutes}m atrás';
    } else {
      return 'Agora';
    }
  }

  @override
  Widget build(BuildContext context) {
    final conversasFiltradas = _filtrarConversas();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Conversas Salvas',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Implementar busca
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _construirFiltros(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: conversasFiltradas.length,
              itemBuilder: (context, index) {
                final conversa = conversasFiltradas[index];
                return SlideTransition(
                  position: _animacaoSlide,
                  child: FadeTransition(
                    opacity: _animacaoFade,
                    child: _construirItemConversa(conversa),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirFiltros() {
    final categorias = ['Todas', 'Desenvolvimento', 'Design', 'Negócios'];

    return Container(
      height: 50.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: categorias.length,
        itemBuilder: (context, index) {
          final categoria = categorias[index];
          final selecionada = categoria == _categoriaSelecionada;

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(
                categoria,
                style: TextStyle(
                  color: selecionada ? Colors.white : Colors.grey,
                ),
              ),
              selected: selecionada,
              onSelected: (selecionado) {
                if (selecionado) {
                  setState(() {
                    _categoriaSelecionada = categoria;
                  });
                }
              },
              backgroundColor: Colors.grey[900],
              selectedColor: Colors.red,
            ),
          );
        },
      ),
    );
  }

  Widget _construirItemConversa(Map<String, dynamic> conversa) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TelaConversa(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      conversa['titulo'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    _formatarData(conversa['data']),
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(
                conversa['ultimaMensagem'],
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14.0,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      conversa['categoria'],
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 