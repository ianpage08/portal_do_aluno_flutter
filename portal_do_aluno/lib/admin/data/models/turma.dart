class Turma {
  final String id;
  final String serie;
  final String turno;
  final int qtdAlunos;
  final String professorTitular;

  Turma({
    required this.id,
    required this.serie,
    required this.turno,
    required this.qtdAlunos,
    required this.professorTitular,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'serie': serie,
    'turno': turno,
    'qtdAlunos': qtdAlunos,
    'professorTitular': professorTitular,
  };

  factory Turma.fromJson(Map<String, dynamic> json) => Turma(
    id: json['id'] as String? ?? '',
    serie: json['serie'] as String? ?? '',
    turno: json['turno'] as String? ?? '',
    qtdAlunos: json['qtdAlunos'] as int? ?? 0,
    professorTitular: json['professorTitular'] as String? ?? '',
  );

  Turma copyWith({
    String? id,
    String? serie,
    String? turno,
    int? qtdAlunos,
    String? professorTitular,
  }) {
    return Turma(
      id: id ?? this.id ,
      serie: serie ?? this.serie,
      turno: turno ?? this.turno,
      qtdAlunos: qtdAlunos ?? this.qtdAlunos  ,
      professorTitular: professorTitular ?? this.professorTitular,
    );
  }
}
