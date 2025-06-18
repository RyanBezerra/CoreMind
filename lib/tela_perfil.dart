import 'package:flutter/material.dart';
import 'models/usuario.dart';
import 'services/database_service.dart';
import 'tela_login.dart';

class TelaPerfil extends StatefulWidget {
  final Usuario usuario;

  const TelaPerfil({
    super.key,
    required this.usuario,
  });

  @override
  State<TelaPerfil> createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> with SingleTickerProviderStateMixin {
  late AnimationController _animacaoController;
  late Animation<double> _animacaoFade;
  late Animation<Offset> _animacaoSlide;
  final _databaseService = DatabaseService();
  final _formKeyNome = GlobalKey<FormState>();
  final _formKeySenha = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _senhaAtualController = TextEditingController();
  final _novaSenhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  bool _mostrarSenhaAtual = false;
  bool _mostrarNovaSenha = false;
  bool _mostrarConfirmarSenha = false;

  @override
  void initState() {
    super.initState();
    _nomeController.text = widget.usuario.nome;
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
    _nomeController.dispose();
    _senhaAtualController.dispose();
    _novaSenhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> _editarPerfil() async {
    print('Botão Editar Perfil pressionado');
    _nomeController.text = widget.usuario.nome;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Perfil'),
        content: Form(
          key: _formKeyNome,
          child: TextFormField(
            controller: _nomeController,
            decoration: const InputDecoration(
              labelText: 'Nome',
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira seu nome';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              if (_formKeyNome.currentState!.validate()) {
                try {
                  if (widget.usuario.id == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Erro: ID do usuário é nulo'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  await _databaseService.atualizarNomeUsuario(
                    widget.usuario.id!,
                    _nomeController.text,
                  );
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Nome atualizado com sucesso!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context);
                    setState(() {
                      widget.usuario.nome = _nomeController.text;
                    });
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao atualizar nome: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Future<void> _alterarSenha() async {
    print('Botão Alterar Senha pressionado');
    _senhaAtualController.clear();
    _novaSenhaController.clear();
    _confirmarSenhaController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alterar Senha'),
        content: Form(
          key: _formKeySenha,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _senhaAtualController,
                obscureText: !_mostrarSenhaAtual,
                decoration: InputDecoration(
                  labelText: 'Senha Atual',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _mostrarSenhaAtual ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _mostrarSenhaAtual = !_mostrarSenhaAtual;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua senha atual';
                  }
                  if (value != widget.usuario.senha) {
                    return 'Senha atual incorreta';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _novaSenhaController,
                obscureText: !_mostrarNovaSenha,
                decoration: InputDecoration(
                  labelText: 'Nova Senha',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _mostrarNovaSenha ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _mostrarNovaSenha = !_mostrarNovaSenha;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a nova senha';
                  }
                  if (value.length < 6) {
                    return 'A senha deve ter pelo menos 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmarSenhaController,
                obscureText: !_mostrarConfirmarSenha,
                decoration: InputDecoration(
                  labelText: 'Confirmar Nova Senha',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _mostrarConfirmarSenha ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _mostrarConfirmarSenha = !_mostrarConfirmarSenha;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, confirme a nova senha';
                  }
                  if (value != _novaSenhaController.text) {
                    return 'As senhas não coincidem';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              if (_formKeySenha.currentState!.validate()) {
                try {
                  if (widget.usuario.id == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Erro: ID do usuário é nulo'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  await _databaseService.atualizarSenhaUsuario(
                    widget.usuario.id!,
                    _novaSenhaController.text,
                  );
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Senha atualizada com sucesso!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context);
                    setState(() {
                      widget.usuario.senha = _novaSenhaController.text;
                    });
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao atualizar senha: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _mostrarNotificacoes() {
    print('Botão Notificações pressionado');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notificações'),
        content: const Text('Funcionalidade em desenvolvimento.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _mostrarAjuda() {
    print('Botão Ajuda pressionado');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajuda'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Como usar o CoreMind:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 8),
              Text('1. Conversas: Inicie uma nova conversa com o assistente virtual'),
              Text('2. Salvos: Acesse suas conversas salvas'),
              Text('3. Perfil: Gerencie suas informações pessoais'),
              SizedBox(height: 16),
              Text(
                'Dicas:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 8),
              Text('• Mantenha sua senha segura e atualizada'),
              Text('• Salve conversas importantes para acesso futuro'),
              Text('• Use linguagem clara e específica com o assistente'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendi'),
          ),
        ],
      ),
    );
  }

  void _mostrarSobre() {
    print('Botão Sobre pressionado');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sobre'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'CoreMind',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              SizedBox(height: 8),
              Text('Versão 1.0.0'),
              SizedBox(height: 16),
              Text(
                'Desenvolvido por:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Equipe CoreMind'),
              SizedBox(height: 16),
              Text(
                'Descrição:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'O CoreMind é um assistente virtual inteligente projetado para ajudar '
                'em diversas tarefas, desde conversas simples até análises complexas.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _fazerLogout() {
    print('Botão Logout pressionado');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Tem certeza que deseja sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Fecha o dialog
              // Navega para a tela de login e remove todas as telas anteriores
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const TelaLogin()),
                (route) => false,
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
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
            onPressed: _editarPerfil,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.red.withOpacity(0.2),
                child: Text(
                  widget.usuario.nome[0].toUpperCase(),
                  style: const TextStyle(
                    fontSize: 32,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                widget.usuario.nome,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                widget.usuario.email,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                ),
              ),
            ),
            const SizedBox(height: 32),
            _construirItemPerfil(
              icone: Icons.person,
              titulo: 'Editar Perfil',
              onTap: _editarPerfil,
            ),
            _construirItemPerfil(
              icone: Icons.security,
              titulo: 'Alterar Senha',
              onTap: _alterarSenha,
            ),
            _construirItemPerfil(
              icone: Icons.notifications,
              titulo: 'Notificações',
              onTap: _mostrarNotificacoes,
            ),
            _construirItemPerfil(
              icone: Icons.help,
              titulo: 'Ajuda',
              onTap: _mostrarAjuda,
            ),
            _construirItemPerfil(
              icone: Icons.info,
              titulo: 'Sobre',
              onTap: _mostrarSobre,
            ),
            _construirItemPerfil(
              icone: Icons.logout,
              titulo: 'Logout',
              onTap: _fazerLogout,
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirItemPerfil({
    required IconData icone,
    required String titulo,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icone, color: Colors.red),
        title: Text(
          titulo,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
} 