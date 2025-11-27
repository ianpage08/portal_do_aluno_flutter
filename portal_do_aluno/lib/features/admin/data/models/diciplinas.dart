class Disciplina {
  final String id;
  final String nome;
  final String professor;
  final int cargaHoraria;
  final int aulaPrevistas;

  Disciplina({
    required this.id,
    required this.nome,
    required this.professor,
    required this.cargaHoraria,
    required this.aulaPrevistas,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'nome': nome,
    'professor': professor,
    'cargaHoraria': cargaHoraria,
    'aulaPrevistas': aulaPrevistas,
  };

  factory Disciplina.fromJson(Map<String, dynamic> json) => Disciplina(
    id: json['id'] as String? ?? '',
    nome: json['nome'] as String? ?? '',
    professor: json['professor'] as String? ?? '',
    cargaHoraria: (json['cargaHoraria'] as num?)?.toInt() ?? 0,
    aulaPrevistas: (json['aulaPrevistas'] as num?)?.toInt() ?? 0,
  );

  Disciplina copyWith({
    String? id,
    String? nome,
    String? professor,
    int? cargaHoraria,
    int? aulaPrevistas,
  }) {
    return Disciplina(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      professor: professor ?? this.professor,
      cargaHoraria: cargaHoraria ?? this.cargaHoraria,
      aulaPrevistas: aulaPrevistas ?? this.aulaPrevistas,
    );
  }
}
