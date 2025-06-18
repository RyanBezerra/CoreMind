import 'package:flutter/material.dart';
import 'tela_conversa.dart';
import 'models/usuario.dart';

class TelaAssistente extends StatefulWidget {
  final Usuario usuario;

  const TelaAssistente({
    super.key,
    required this.usuario,
  });

  @override
  State<TelaAssistente> createState() => _TelaAssistenteState();
}

class _TelaAssistenteState extends State<TelaAssistente> with SingleTickerProviderStateMixin {
  late AnimationController _animacaoController;
  late Animation<double> _animacaoFade;
  late Animation<Offset> _animacaoSlide;
  bool _assistenteAtivo = true;

  final List<Map<String, dynamic>> _recursos = [
    {
      'icone': Icons.chat,
      'titulo': 'Chat Inteligente',
      'descricao': 'Converse com o assistente sobre qualquer assunto',
    },
    {
      'icone': Icons.code,
      'titulo': 'Ajuda com Código',
      'descricao': 'Receba ajuda com desenvolvimento e debugging',
    },
    {
      'icone': Icons.lightbulb,
      'titulo': 'Dicas e Sugestões',
      'descricao': 'Obtenha recomendações personalizadas',
    },
    {
      'icone': Icons.search,
      'titulo': 'Busca Avançada',
      'descricao': 'Encontre informações específicas rapidamente',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Assistente Virtual',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Implementar configurações
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _construirCabecalho(),
            _construirStatus(),
            _construirRecursos(),
            _construirEstatisticas(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TelaConversa(usuario: widget.usuario),
            ),
          );
        },
        backgroundColor: Colors.red,
        icon: const Icon(Icons.chat),
        label: const Text('Iniciar Conversa'),
      ),
    );
  }

  Widget _construirCabecalho() {
    return SlideTransition(
      position: _animacaoSlide,
      child: FadeTransition(
        opacity: _animacaoFade,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30.0,
                backgroundColor: Colors.red.withOpacity(0.2),
                child: const Icon(
                  Icons.smart_toy,
                  size: 30.0,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Assistente Virtual',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Sempre pronto para ajudar',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirStatus() {
    return SlideTransition(
      position: _animacaoSlide,
      child: FadeTransition(
        opacity: _animacaoFade,
        child: Container(
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 12.0,
                    height: 12.0,
                    decoration: BoxDecoration(
                      color: _assistenteAtivo ? Colors.green : Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    _assistenteAtivo ? 'Online' : 'Offline',
                    style: TextStyle(
                      color: _assistenteAtivo ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Switch(
                value: _assistenteAtivo,
                onChanged: (valor) {
                  setState(() {
                    _assistenteAtivo = valor;
                  });
                },
                activeColor: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirRecursos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Recursos Disponíveis',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          itemCount: _recursos.length,
          itemBuilder: (context, index) {
            final recurso = _recursos[index];
            return SlideTransition(
              position: _animacaoSlide,
              child: FadeTransition(
                opacity: _animacaoFade,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Icon(
                          recurso['icone'],
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              recurso['titulo'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              recurso['descricao'],
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _construirEstatisticas() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Estatísticas',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: _construirItemEstatistica(
                  icone: Icons.chat,
                  valor: '156',
                  titulo: 'Conversas',
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: _construirItemEstatistica(
                  icone: Icons.timer,
                  valor: '48h',
                  titulo: 'Tempo Ativo',
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: _construirItemEstatistica(
                  icone: Icons.star,
                  valor: '4.8',
                  titulo: 'Avaliação',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _construirItemEstatistica({
    required IconData icone,
    required String valor,
    required String titulo,
  }) {
    return SlideTransition(
      position: _animacaoSlide,
      child: FadeTransition(
        opacity: _animacaoFade,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            children: [
              Icon(
                icone,
                color: Colors.red,
                size: 24.0,
              ),
              const SizedBox(height: 8.0),
              Text(
                valor,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                titulo,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 