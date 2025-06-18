class Mensagem {
  final int? id;
  final int conversaId;
  final String texto;
  final bool eUsuario;
  final DateTime dataCriacao;

  Mensagem({
    this.id,
    required this.conversaId,
    required this.texto,
    required this.eUsuario,
    DateTime? dataCriacao,
  }) : dataCriacao = dataCriacao ?? DateTime.now();

  factory Mensagem.fromMap(Map<String, dynamic> map) {
    return Mensagem(
      id: map['id'] as int,
      conversaId: map['conversa_id'] as int,
      texto: map['texto'] as String,
      eUsuario: map['e_usuario'] == 1,
      dataCriacao: DateTime.parse(map['data_criacao'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'conversa_id': conversaId,
      'texto': texto,
      'e_usuario': eUsuario ? 1 : 0,
      'data_criacao': dataCriacao.toIso8601String(),
    };
  }

  Mensagem copyWith({
    int? id,
    int? conversaId,
    String? texto,
    bool? eUsuario,
    DateTime? dataCriacao,
  }) {
    return Mensagem(
      id: id ?? this.id,
      conversaId: conversaId ?? this.conversaId,
      texto: texto ?? this.texto,
      eUsuario: eUsuario ?? this.eUsuario,
      dataCriacao: dataCriacao ?? this.dataCriacao,
    );
  }
} 