class NotaDisciplina {
  final String id;
  final String nomeDisciplina;
  final String disciplinaId;

  NotaDisciplina({
    required this.id,

    required this.nomeDisciplina,
    required this.disciplinaId,
    Map<int, Map<String, double?>>? notas,
  }) : notas =
           notas ??
           {
             1: {'teste': null, 'prova': null},
             2: {'teste': null, 'prova': null},
             3: {'teste': null, 'prova': null},
             4: {'teste': null, 'prova': null},
           };

  final Map<int, Map<String, double?>> notas;

  double? calcularmediaUnidade(int unidade) {
    final unit = notas[unidade];
    if (unit == null) {
      return null;
    }
    final teste = unit['teste'];
    final prova = unit['prova'];
    if (teste != null && prova != null) {
      return (teste + prova) / 2;
    }
    return null;
  }

  double? calcularMediaFinal() {
    final medias = List.generate(
      4,
      (index) => calcularmediaUnidade(index + 1),
    ).where((element) => element != null).map((e) => e!).toList();
    if (medias.isEmpty) {
      return null;
    }
    return medias.reduce((a, b) => a + b) / medias.length;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nomeDisciplina': nomeDisciplina,
    'disciplinaId': disciplinaId,
    'notas': notas,
  };

  factory NotaDisciplina.fromJson(Map<String, dynamic> json) {
    final Map<int, Map<String, double?>> notasMap = {};
    (json['notas'] as Map<String, dynamic>? ?? {}).forEach((key, value) {
      final int unidade = int.parse(key);
      notasMap[unidade] = Map<String, double?>.from(value);
    });
    return NotaDisciplina(
      id: json['id'] as String? ?? '',
      nomeDisciplina: json['nomeDisciplina'] as String? ?? '',
      disciplinaId: json['disciplinaId'] as String? ?? '',
      notas: notasMap,
    );
  }
  NotaDisciplina atualizarNota(int unidade, String tipo, double nota) {
    final novasNotas = Map<int, Map<String, double?>>.from(notas);
    novasNotas[unidade] = {...novasNotas[unidade]!, tipo: nota};
    return copyWith(notas: novasNotas);
  }

  NotaDisciplina copyWith({
    String? id,
    String? nomeDisciplina,
    String? disciplinaId,
    Map<int, Map<String, double?>>? notas,
  }) => NotaDisciplina(
    id: id ?? this.id,
    nomeDisciplina: nomeDisciplina ?? this.nomeDisciplina,
    disciplinaId: disciplinaId ?? this.disciplinaId,
    notas: notas ?? this.notas,
  );
}
