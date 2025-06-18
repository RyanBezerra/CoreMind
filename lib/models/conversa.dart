class Conversa {
  final int? id;
  final int usuarioId;
  final String titulo;
  final DateTime dataCriacao;

  Conversa({
    this.id,
    required this.usuarioId,
    required this.titulo,
    DateTime? dataCriacao,
  }) : dataCriacao = dataCriacao ?? DateTime.now();

  factory Conversa.fromMap(Map<String, dynamic> map) {
    return Conversa(
      id: map['id'] as int,
      usuarioId: map['usuario_id'] as int,
      titulo: map['titulo'] as String,
      dataCriacao: DateTime.parse(map['data_criacao'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuario_id': usuarioId,
      'titulo': titulo,
      'data_criacao': dataCriacao.toIso8601String(),
    };
  }

  Conversa copyWith({
    int? id,
    int? usuarioId,
    String? titulo,
    DateTime? dataCriacao,
  }) {
    return Conversa(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      titulo: titulo ?? this.titulo,
      dataCriacao: dataCriacao ?? this.dataCriacao,
    );
  }
} 