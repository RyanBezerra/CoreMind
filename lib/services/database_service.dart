import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;
  static bool _initialized = false;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  // Método para inicializar o banco de dados
  static Future<void> initialize() async {
    if (_initialized) return;
    
    print('Inicializando DatabaseService...');
    
    try {
      _initialized = true;
      print('DatabaseService inicializado com sucesso');
    } catch (e) {
      print('Erro ao inicializar DatabaseService: $e');
    }
  }

  Future<Database> get database async {
    print('Obtendo instância do banco de dados...');
    
    try {
      if (!_initialized) {
        print('DatabaseService não inicializado, inicializando agora...');
        await DatabaseService.initialize();
      }
      
      if (_database != null) {
        print('Retornando instância existente do banco de dados');
        return _database!;
      }
      
      print('Criando nova instância do banco de dados...');
      _database = await _initDatabase();
      print('Banco de dados criado com sucesso');
      return _database!;
    } catch (e) {
      print('Erro ao obter banco de dados: $e');
      rethrow;
    }
  }

  Future<Database> _initDatabase() async {
    try {
      final databasesPath = await getDatabasesPath();
      final path = join(databasesPath, 'coremind.db');
      
      print('Caminho do banco de dados: $path');
      
      return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
      );
    } catch (e) {
      print('Erro ao inicializar banco de dados: $e');
      rethrow;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabela de Usuários
    await db.execute('''
      CREATE TABLE usuarios(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        senha TEXT NOT NULL,
        data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Tabela de Conversas
    await db.execute('''
      CREATE TABLE conversas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuario_id INTEGER NOT NULL,
        titulo TEXT NOT NULL,
        data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (usuario_id) REFERENCES usuarios (id)
      )
    ''');

    // Tabela de Mensagens
    await db.execute('''
      CREATE TABLE mensagens(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        conversa_id INTEGER NOT NULL,
        texto TEXT NOT NULL,
        e_usuario BOOLEAN NOT NULL,
        data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (conversa_id) REFERENCES conversas (id)
      )
    ''');
  }

  // Métodos para Usuários
  Future<int> criarUsuario(String nome, String email, String senha) async {
    final db = await database;
    return await db.insert('usuarios', {
      'nome': nome,
      'email': email,
      'senha': senha,
    });
  }

  Future<Map<String, dynamic>?> buscarUsuarioPorEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'usuarios',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isEmpty) return null;
    return maps.first;
  }

  // Métodos para Conversas
  Future<int> criarConversa(int usuarioId, String titulo) async {
    print('=== CRIANDO CONVERSA ===');
    print('DatabaseService: Usuário ID: $usuarioId');
    print('DatabaseService: Título: "$titulo"');
    
    try {
      final db = await database;
      print('DatabaseService: Banco de dados obtido com sucesso');
      
      final dados = {
        'usuario_id': usuarioId,
        'titulo': titulo,
      };
      print('DatabaseService: Dados para inserção: $dados');
      
      final result = await db.insert('conversas', dados);
      print('DatabaseService: Conversa criada com ID: $result');
      
      // VERIFICAR SE A CONVERSA FOI REALMENTE SALVA
      final conversaSalva = await db.query(
        'conversas',
        where: 'id = ?',
        whereArgs: [result],
      );
      
      if (conversaSalva.isNotEmpty) {
        print('DatabaseService: ✅ CONVERSA CONFIRMADA NO BANCO');
        print('DatabaseService: ID: ${conversaSalva.first['id']}');
        print('DatabaseService: Usuário ID: ${conversaSalva.first['usuario_id']}');
        print('DatabaseService: Título: "${conversaSalva.first['titulo']}"');
      } else {
        print('DatabaseService: ❌ ERRO: CONVERSA NÃO ENCONTRADA NO BANCO');
      }
      
      return result;
    } catch (e) {
      print('DatabaseService: ❌ ERRO AO CRIAR CONVERSA: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> buscarConversasDoUsuario(int usuarioId) async {
    print('DatabaseService: Buscando conversas do usuário $usuarioId');
    try {
      final db = await database;
      final result = await db.query(
        'conversas',
        where: 'usuario_id = ?',
        whereArgs: [usuarioId],
        orderBy: 'data_criacao DESC',
      );
      print('DatabaseService: Encontradas ${result.length} conversas');
      return result;
    } catch (e) {
      print('DatabaseService: Erro ao buscar conversas: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> buscarConversasComMensagens(int usuarioId) async {
    print('=== BUSCANDO CONVERSAS COM MENSAGENS ===');
    print('DatabaseService: Usuário ID: $usuarioId');
    
    try {
      final db = await database;
      print('DatabaseService: Banco de dados obtido com sucesso');
      
      // Consulta simples: só conversas que têm pelo menos uma mensagem
      final query = '''
        SELECT DISTINCT c.* 
        FROM conversas c 
        INNER JOIN mensagens m ON c.id = m.conversa_id 
        WHERE c.usuario_id = ? 
        ORDER BY c.data_criacao DESC
      ''';
      
      print('DatabaseService: Executando consulta SQL:');
      print('DatabaseService: $query');
      print('DatabaseService: Parâmetros: [$usuarioId]');
      
      final result = await db.rawQuery(query, [usuarioId]);
      print('DatabaseService: ✅ Consulta executada com sucesso');
      print('DatabaseService: Encontradas ${result.length} conversas com mensagens');
      
      // LOG DETALHADO DOS RESULTADOS
      for (int i = 0; i < result.length; i++) {
        final conversa = result[i];
        print('DatabaseService: Conversa ${i + 1}:');
        print('   ID: ${conversa['id']}');
        print('   Título: ${conversa['titulo']}');
        print('   Usuário ID: ${conversa['usuario_id']}');
        print('   Data Criação: ${conversa['data_criacao']}');
        
        // VERIFICAR MENSAGENS DESTA CONVERSA
        final mensagens = await db.query(
          'mensagens',
          where: 'conversa_id = ?',
          whereArgs: [conversa['id']],
        );
        print('   Mensagens na conversa: ${mensagens.length}');
      }
      
      return result;
    } catch (e) {
      print('DatabaseService: ❌ ERRO AO BUSCAR CONVERSAS COM MENSAGENS: $e');
      print('DatabaseService: Stack trace: ${StackTrace.current}');
      rethrow;
    }
  }

  // Métodos para Mensagens
  Future<int> criarMensagem(int conversaId, String texto, bool eUsuario) async {
    print('=== CRIANDO MENSAGEM ===');
    print('DatabaseService: Conversa ID: $conversaId');
    print('DatabaseService: Texto: "${texto}"');
    print('DatabaseService: É usuário: $eUsuario');
    
    try {
      final db = await database;
      print('DatabaseService: Banco de dados obtido com sucesso');
      
      final dados = {
        'conversa_id': conversaId,
        'texto': texto,
        'e_usuario': eUsuario ? 1 : 0,
      };
      print('DatabaseService: Dados para inserção: $dados');
      
      final result = await db.insert('mensagens', dados);
      print('DatabaseService: Mensagem criada com ID: $result');
      
      // VERIFICAR SE A MENSAGEM FOI REALMENTE SALVA
      final mensagemSalva = await db.query(
        'mensagens',
        where: 'id = ?',
        whereArgs: [result],
      );
      
      if (mensagemSalva.isNotEmpty) {
        print('DatabaseService: ✅ MENSAGEM CONFIRMADA NO BANCO');
        print('DatabaseService: ID: ${mensagemSalva.first['id']}');
        print('DatabaseService: Conversa ID: ${mensagemSalva.first['conversa_id']}');
        print('DatabaseService: Texto: "${mensagemSalva.first['texto']}"');
        print('DatabaseService: É usuário: ${mensagemSalva.first['e_usuario']}');
      } else {
        print('DatabaseService: ❌ ERRO: MENSAGEM NÃO ENCONTRADA NO BANCO');
      }
      
      return result;
    } catch (e) {
      print('DatabaseService: ❌ ERRO AO CRIAR MENSAGEM: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> buscarMensagensDaConversa(int conversaId) async {
    print('DatabaseService: Buscando mensagens da conversa $conversaId');
    try {
      final db = await database;
      final result = await db.query(
        'mensagens',
        where: 'conversa_id = ?',
        whereArgs: [conversaId],
        orderBy: 'data_criacao ASC',
      );
      print('DatabaseService: Encontradas ${result.length} mensagens na conversa $conversaId');
      return result;
    } catch (e) {
      print('DatabaseService: Erro ao buscar mensagens: $e');
      rethrow;
    }
  }

  // Método para excluir uma conversa e suas mensagens
  Future<void> excluirConversa(int conversaId) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete(
        'mensagens',
        where: 'conversa_id = ?',
        whereArgs: [conversaId],
      );
      await txn.delete(
        'conversas',
        where: 'id = ?',
        whereArgs: [conversaId],
      );
    });
  }

  // Método para limpar conversas vazias (sem mensagens)
  Future<void> limparConversasVazias(int usuarioId) async {
    print('DatabaseService: Limpando conversas vazias do usuário $usuarioId');
    try {
      final db = await database;
      await db.transaction((txn) async {
        // Buscar conversas que não têm mensagens
        final conversasVazias = await txn.rawQuery('''
          SELECT c.id 
          FROM conversas c 
          LEFT JOIN mensagens m ON c.id = m.conversa_id 
          WHERE c.usuario_id = ? 
          AND m.id IS NULL
        ''', [usuarioId]);
        
        print('DatabaseService: Encontradas ${conversasVazias.length} conversas vazias para limpar');
        
        // Excluir conversas vazias
        for (final conversa in conversasVazias) {
          await txn.delete(
            'conversas',
            where: 'id = ?',
            whereArgs: [conversa['id']],
          );
        }
      });
      print('DatabaseService: Conversas vazias limpas com sucesso');
    } catch (e) {
      print('DatabaseService: Erro ao limpar conversas vazias: $e');
      rethrow;
    }
  }

  // Método para atualizar nome do usuário
  Future<void> atualizarNomeUsuario(int usuarioId, String novoNome) async {
    print('DatabaseService: Atualizando nome do usuário $usuarioId para "$novoNome"');
    try {
      final db = await database;
      print('DatabaseService: Banco de dados obtido com sucesso');
      final result = await db.update(
        'usuarios',
        {'nome': novoNome},
        where: 'id = ?',
        whereArgs: [usuarioId],
      );
      print('DatabaseService: Nome atualizado. Linhas afetadas: $result');
    } catch (e) {
      print('DatabaseService: Erro ao atualizar nome: $e');
      rethrow;
    }
  }

  // Método para atualizar senha do usuário
  Future<void> atualizarSenhaUsuario(int usuarioId, String novaSenha) async {
    print('DatabaseService: Atualizando senha do usuário $usuarioId');
    try {
      final db = await database;
      print('DatabaseService: Banco de dados obtido com sucesso');
      final result = await db.update(
        'usuarios',
        {'senha': novaSenha},
        where: 'id = ?',
        whereArgs: [usuarioId],
      );
      print('DatabaseService: Senha atualizada. Linhas afetadas: $result');
    } catch (e) {
      print('DatabaseService: Erro ao atualizar senha: $e');
      rethrow;
    }
  }

  // Método para buscar usuário por ID
  Future<Map<String, dynamic>?> buscarUsuarioPorId(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'usuarios',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return maps.first;
  }

  // MÉTODOS DE DEBUG - PARA IDENTIFICAR PROBLEMAS
  Future<void> debugVerificarTabelas(int usuarioId) async {
    print('=== DEBUG: VERIFICANDO TABELAS ===');
    try {
      final db = await database;
      
      // Verificar conversas do usuário
      final conversas = await db.query(
        'conversas',
        where: 'usuario_id = ?',
        whereArgs: [usuarioId],
      );
      print('DEBUG: Conversas encontradas: ${conversas.length}');
      for (final conversa in conversas) {
        print('DEBUG: Conversa ID: ${conversa['id']}, Título: ${conversa['titulo']}');
        
        // Verificar mensagens desta conversa
        final mensagens = await db.query(
          'mensagens',
          where: 'conversa_id = ?',
          whereArgs: [conversa['id']],
        );
        print('DEBUG: Mensagens na conversa ${conversa['id']}: ${mensagens.length}');
        for (final mensagem in mensagens) {
          print('DEBUG: - Mensagem ID: ${mensagem['id']}, É usuário: ${mensagem['e_usuario']}, Texto: ${mensagem['texto'].toString().substring(0, mensagem['texto'].toString().length > 20 ? 20 : mensagem['texto'].toString().length)}...');
        }
      }
    } catch (e) {
      print('DEBUG: Erro ao verificar tabelas: $e');
    }
    print('=== FIM DEBUG ===');
  }

  Future<void> debugVerificarMensagens(int conversaId) async {
    print('=== DEBUG: VERIFICANDO MENSAGENS DA CONVERSA $conversaId ===');
    try {
      final db = await database;
      final mensagens = await db.query(
        'mensagens',
        where: 'conversa_id = ?',
        whereArgs: [conversaId],
        orderBy: 'data_criacao ASC',
      );
      print('DEBUG: Total de mensagens na conversa $conversaId: ${mensagens.length}');
      for (int i = 0; i < mensagens.length; i++) {
        final msg = mensagens[i];
        print('DEBUG: Mensagem ${i + 1}: ID=${msg['id']}, É usuário=${msg['e_usuario']}, Texto="${msg['texto']}"');
      }
    } catch (e) {
      print('DEBUG: Erro ao verificar mensagens: $e');
    }
  }

  Future<void> debugVerificarEstruturaTabelas() async {
    print('=== DEBUG: VERIFICANDO ESTRUTURA DAS TABELAS ===');
    try {
      final db = await database;
      
      // Verificar se as tabelas existem
      final tabelas = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
      print('DEBUG: Tabelas encontradas: ${tabelas.map((t) => t['name']).toList()}');
      
      // Verificar se as tabelas necessárias existem
      final tabelasNecessarias = ['usuarios', 'conversas', 'mensagens'];
      for (final tabela in tabelasNecessarias) {
        final existe = tabelas.any((t) => t['name'] == tabela);
        print('DEBUG: Tabela "$tabela" existe: $existe');
      }
      
      // Verificar estrutura da tabela mensagens
      try {
        final estruturaMensagens = await db.rawQuery("PRAGMA table_info(mensagens)");
        print('DEBUG: Estrutura da tabela mensagens:');
        for (final coluna in estruturaMensagens) {
          print('DEBUG: - ${coluna['name']}: ${coluna['type']} (${coluna['notnull'] == 1 ? 'NOT NULL' : 'NULL'})');
        }
      } catch (e) {
        print('DEBUG: ❌ Erro ao verificar estrutura da tabela mensagens: $e');
      }
      
      // Verificar estrutura da tabela conversas
      try {
        final estruturaConversas = await db.rawQuery("PRAGMA table_info(conversas)");
        print('DEBUG: Estrutura da tabela conversas:');
        for (final coluna in estruturaConversas) {
          print('DEBUG: - ${coluna['name']}: ${coluna['type']} (${coluna['notnull'] == 1 ? 'NOT NULL' : 'NULL'})');
        }
      } catch (e) {
        print('DEBUG: ❌ Erro ao verificar estrutura da tabela conversas: $e');
      }
      
      // Verificar estrutura da tabela usuarios
      try {
        final estruturaUsuarios = await db.rawQuery("PRAGMA table_info(usuarios)");
        print('DEBUG: Estrutura da tabela usuarios:');
        for (final coluna in estruturaUsuarios) {
          print('DEBUG: - ${coluna['name']}: ${coluna['type']} (${coluna['notnull'] == 1 ? 'NOT NULL' : 'NULL'})');
        }
      } catch (e) {
        print('DEBUG: ❌ Erro ao verificar estrutura da tabela usuarios: $e');
      }
      
    } catch (e) {
      print('DEBUG: ❌ Erro ao verificar estrutura das tabelas: $e');
    }
  }

  Future<void> debugVerificarDadosTabelas() async {
    print('=== DEBUG: VERIFICANDO DADOS DAS TABELAS ===');
    try {
      final db = await database;
      
      // Verificar dados da tabela usuarios
      try {
        final usuarios = await db.query('usuarios');
        print('DEBUG: Total de usuários: ${usuarios.length}');
        for (final usuario in usuarios) {
          print('DEBUG: Usuário ID: ${usuario['id']}, Nome: ${usuario['nome']}, Email: ${usuario['email']}');
        }
      } catch (e) {
        print('DEBUG: ❌ Erro ao verificar dados da tabela usuarios: $e');
      }
      
      // Verificar dados da tabela conversas
      try {
        final conversas = await db.query('conversas');
        print('DEBUG: Total de conversas: ${conversas.length}');
        for (final conversa in conversas) {
          print('DEBUG: Conversa ID: ${conversa['id']}, Usuário ID: ${conversa['usuario_id']}, Título: ${conversa['titulo']}');
        }
      } catch (e) {
        print('DEBUG: ❌ Erro ao verificar dados da tabela conversas: $e');
      }
      
      // Verificar dados da tabela mensagens
      try {
        final mensagens = await db.query('mensagens');
        print('DEBUG: Total de mensagens: ${mensagens.length}');
        for (final mensagem in mensagens) {
          print('DEBUG: Mensagem ID: ${mensagem['id']}, Conversa ID: ${mensagem['conversa_id']}, É usuário: ${mensagem['e_usuario']}, Texto: "${mensagem['texto']}"');
        }
      } catch (e) {
        print('DEBUG: ❌ Erro ao verificar dados da tabela mensagens: $e');
      }
      
    } catch (e) {
      print('DEBUG: ❌ Erro ao verificar dados das tabelas: $e');
    }
  }

  Future<void> debugLimparTudo(int usuarioId) async {
    print('=== DEBUG: LIMPANDO TUDO DO USUÁRIO $usuarioId ===');
    try {
      final db = await database;
      await db.transaction((txn) async {
        // Buscar todas as conversas do usuário
        final conversas = await txn.query(
          'conversas',
          where: 'usuario_id = ?',
          whereArgs: [usuarioId],
        );
        
        print('DEBUG: Encontradas ${conversas.length} conversas para limpar');
        
        // Excluir mensagens de todas as conversas
        for (final conversa in conversas) {
          await txn.delete(
            'mensagens',
            where: 'conversa_id = ?',
            whereArgs: [conversa['id']],
          );
          print('DEBUG: Mensagens da conversa ${conversa['id']} excluídas');
        }
        
        // Excluir todas as conversas do usuário
        await txn.delete(
          'conversas',
          where: 'usuario_id = ?',
          whereArgs: [usuarioId],
        );
        print('DEBUG: Todas as conversas do usuário excluídas');
      });
      print('DEBUG: Limpeza concluída com sucesso');
    } catch (e) {
      print('DEBUG: Erro ao limpar tudo: $e');
    }
  }
} 