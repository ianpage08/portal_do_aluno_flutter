class ClasseDeAula {
  final String id;
  final String serie;
  final String turno;
  final int qtdAlunos;
  final String professorTitular;

  ClasseDeAula({
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

  factory ClasseDeAula.fromJson(Map<String, dynamic> json) => ClasseDeAula(
    id: json['id'] as String? ?? '',
    serie: json['serie'] as String? ?? '',
    turno: json['turno'] as String? ?? '',
    qtdAlunos: json['qtdAlunos'] as int? ?? 0,
    professorTitular: json['professorTitular'] as String? ?? '',
  );

  ClasseDeAula copyWith({
    String? id,
    String? serie,
    String? turno,
    int? qtdAlunos,
    String? professorTitular,
  }) {
    return ClasseDeAula(
      id: id ?? this.id ,
      serie: serie ?? this.serie,
      turno: turno ?? this.turno,
      qtdAlunos: qtdAlunos ?? this.qtdAlunos  ,
      professorTitular: professorTitular ?? this.professorTitular,
    );
  }
}
