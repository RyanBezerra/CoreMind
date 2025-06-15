import 'package:flutter/material.dart';
import 'tela_conversa.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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

  final List<Map<String, dynamic>> _conversasSalvas = [];

  // Lista de todas as categorias/tags disponíveis
  final List<String> todasCategorias = [
    'Desenvolvimento', 'Projetos', 'Ajudas', 'Negócios', 'Outros',
  ];

  final ScrollController _scrollControllerConversas = ScrollController();

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
    _carregarConversasSalvas();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _carregarConversasSalvas();
  }

  Future<void> _carregarConversasSalvas() async {
    final prefs = await SharedPreferences.getInstance();
    final conversas = prefs.getStringList('conversas_salvas') ?? [];
    print('Conversas lidas do shared_preferences: ' + conversas.toString());
    setState(() {
      _conversasSalvas.clear();
      for (var conversaStr in conversas) {
        final map = _converterStringParaMap(conversaStr);
        if (map != null) {
          _conversasSalvas.add(map);
        }
      }
    });
  }

  Map<String, dynamic>? _converterStringParaMap(String str) {
    try {
      return json.decode(str);
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    _scrollControllerConversas.dispose();
    _animacaoController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _filtrarConversas() {
    if (_categoriaSelecionada == 'Todas') {
      return _conversasSalvas;
    }
    return _conversasSalvas.where((conversa) => (conversa['categorias'] ?? ['Geral']).contains(_categoriaSelecionada)).toList();
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
    print('Conversas filtradas para exibição: ' + conversasFiltradas.toString());

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
            child: Scrollbar(
              controller: _scrollControllerConversas,
              thumbVisibility: true,
              trackVisibility: true,
              interactive: true,
              child: ListView.builder(
                controller: _scrollControllerConversas,
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
          ),
        ],
      ),
    );
  }

  Widget _construirFiltros() {
    final categorias = ['Todas', ...todasCategorias];

    return SizedBox(
      height: 50.0,
      width: double.infinity,
      child: Scrollbar(
        thumbVisibility: true,
        trackVisibility: true,
        interactive: true,
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
              builder: (context) => TelaConversa(tituloConversa: conversa['titulo']),
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
                    _formatarData(DateTime.parse(conversa['data'])),
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
                  for (var cat in (conversa['categorias'] ?? ['Geral']))
                    Container(
                      margin: const EdgeInsets.only(right: 4.0),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        cat,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.red, size: 18),
                    onPressed: () => _editarCategorias(conversa),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _editarCategorias(Map<String, dynamic> conversa) async {
    final selecionadas = Set<String>.from(conversa['categorias'] ?? []);
    final resultado = await showDialog<Set<String>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar categorias'),
          content: SingleChildScrollView(
            child: Column(
              children: todasCategorias.map((cat) {
                return CheckboxListTile(
                  title: Text(cat),
                  value: selecionadas.contains(cat),
                  onChanged: (val) {
                    if (val == true) {
                      selecionadas.add(cat);
                    } else {
                      selecionadas.remove(cat);
                    }
                    (context as Element).markNeedsBuild();
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, selecionadas),
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
    if (resultado != null && resultado.isNotEmpty) {
      setState(() {
        conversa['categorias'] = resultado.toList();
      });
      // Atualiza no SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final conversas = prefs.getStringList('conversas_salvas') ?? [];
      for (int i = 0; i < conversas.length; i++) {
        final map = jsonDecode(conversas[i]);
        if (map['titulo'] == conversa['titulo']) {
          map['categorias'] = resultado.toList();
          conversas[i] = jsonEncode(map);
        }
      }
      await prefs.setStringList('conversas_salvas', conversas);
    }
  }
} 