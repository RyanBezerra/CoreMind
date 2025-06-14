import 'package:flutter/material.dart';

class TelaPerfil extends StatefulWidget {
  const TelaPerfil({super.key});

  @override
  State<TelaPerfil> createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> with SingleTickerProviderStateMixin {
  late AnimationController _animacaoController;
  late Animation<double> _animacaoFade;
  late Animation<Offset> _animacaoSlide;

  final Map<String, dynamic> _usuario = {
    'nome': 'João Silva',
    'email': 'joao.silva@email.com',
    'telefone': '(11) 98765-4321',
    'localizacao': 'São Paulo, SP',
    'dataCadastro': '15/03/2024',
  };

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
          'Perfil',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              // Implementar edição de perfil
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _construirCabecalho(),
            _construirInformacoesPessoais(),
            _construirMenu(),
          ],
        ),
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
          child: Column(
            children: [
              CircleAvatar(
                radius: 50.0,
                backgroundColor: Colors.red.withOpacity(0.2),
                child: const Icon(
                  Icons.person,
                  size: 50.0,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                _usuario['nome'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                _usuario['email'],
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirInformacoesPessoais() {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Informações Pessoais',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              _construirItemInfo(
                icone: Icons.phone,
                titulo: 'Telefone',
                valor: _usuario['telefone'],
              ),
              const SizedBox(height: 12.0),
              _construirItemInfo(
                icone: Icons.location_on,
                titulo: 'Localização',
                valor: _usuario['localizacao'],
              ),
              const SizedBox(height: 12.0),
              _construirItemInfo(
                icone: Icons.calendar_today,
                titulo: 'Membro desde',
                valor: _usuario['dataCadastro'],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirItemInfo({
    required IconData icone,
    required String titulo,
    required String valor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Icon(
            icone,
            color: Colors.red,
            size: 20.0,
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                valor,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _construirMenu() {
    final itensMenu = [
      {
        'icone': Icons.settings,
        'titulo': 'Configurações',
        'acao': () {
          // Implementar configurações
        },
      },
      {
        'icone': Icons.notifications,
        'titulo': 'Notificações',
        'acao': () {
          // Implementar notificações
        },
      },
      {
        'icone': Icons.security,
        'titulo': 'Privacidade',
        'acao': () {
          // Implementar privacidade
        },
      },
      {
        'icone': Icons.help,
        'titulo': 'Ajuda',
        'acao': () {
          // Implementar ajuda
        },
      },
      {
        'icone': Icons.logout,
        'titulo': 'Sair',
        'acao': () {
          // Implementar logout
        },
        'cor': Colors.red,
      },
    ];

    return SlideTransition(
      position: _animacaoSlide,
      child: FadeTransition(
        opacity: _animacaoFade,
        child: Container(
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            children: itensMenu.map((item) {
              return _construirItemMenu(
                icone: item['icone'] as IconData,
                titulo: item['titulo'] as String,
                acao: item['acao'] as Function(),
                cor: item['cor'] as Color?,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _construirItemMenu({
    required IconData icone,
    required String titulo,
    required Function acao,
    Color? cor,
  }) {
    return InkWell(
      onTap: () => acao(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              icone,
              color: cor ?? Colors.white,
              size: 24.0,
            ),
            const SizedBox(width: 16.0),
            Text(
              titulo,
              style: TextStyle(
                color: cor ?? Colors.white,
                fontSize: 16.0,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: cor ?? Colors.grey[400],
              size: 16.0,
            ),
          ],
        ),
      ),
    );
  }
} 