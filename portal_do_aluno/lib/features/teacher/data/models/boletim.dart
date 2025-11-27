import 'package:portal_do_aluno/features/teacher/data/models/nota_disciplina.dart';

class Boletim {
  final String id;
  final String alunoId;
  final List<NotaDisciplina> disciplinas;
  final double mediageral;
  final String situacao; // aprovado ou reprovado

  Boletim({
    required this.id,
    required this.alunoId,
    required this.disciplinas,
    required this.mediageral,
    required this.situacao,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'alunoId': alunoId,
    'disciplinas': disciplinas.map((e) => e.toJson()).toList(),
    'mediageral': mediageral,
    'situacao': situacao,
  };

  factory Boletim.fromJson(Map<String, dynamic> json) => Boletim(
    id: json['id'] as String? ?? '',
    alunoId: json['alunoId'] as String? ?? '',
    disciplinas:
        (json['disciplinas'] as List<dynamic>?)
            ?.map((e) => NotaDisciplina.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    mediageral: json['mediageral'] as double? ?? 0.0,
    situacao: json['situacao'] as String? ?? '',
  );

  Boletim copyWith({
    String? id,
    String? alunoId,
    List<NotaDisciplina>? disciplinas,
    double? mediageral,
    String? situacao,
  }) => Boletim(
    id: id ?? this.id,
    alunoId: alunoId ?? this.alunoId,
    disciplinas: disciplinas ?? this.disciplinas,
    mediageral: mediageral ?? this.mediageral,
    situacao: situacao ?? this.situacao,
  );
}
