class Usuario {
  final int? id;
  String nome;
  final String email;
  String senha;
  final DateTime dataCriacao;

  Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
    DateTime? dataCriacao,
  }) : dataCriacao = dataCriacao ?? DateTime.now();

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'] as int,
      nome: map['nome'] as String,
      email: map['email'] as String,
      senha: map['senha'] as String,
      dataCriacao: DateTime.parse(map['data_criacao'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'data_criacao': dataCriacao.toIso8601String(),
    };
  }

  Usuario copyWith({
    int? id,
    String? nome,
    String? email,
    String? senha,
    DateTime? dataCriacao,
  }) {
    return Usuario(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      senha: senha ?? this.senha,
      dataCriacao: dataCriacao ?? this.dataCriacao,
    );
  }
} 