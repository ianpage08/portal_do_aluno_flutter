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
             1: {'teste': null, 'prova': null, 'trabalho': null, 'extra': null},
             2: {'teste': null, 'prova': null, 'trabalho': null, 'extra': null},
             3: {'teste': null, 'prova': null, 'trabalho': null, 'extra': null},
             4: {'teste': null, 'prova': null, 'trabalho': null, 'extra': null},
           };

  final Map<int, Map<String, double?>> notas;

  double? calcularMediaUnidade(int unidade) {
    final unit = notas[unidade];
    if (unit == null) return null;

    // Considera todas as notas (teste, prova, trabalho, extra)
    final valores = unit.values.whereType<double>().toList();
    if (valores.isEmpty) return null;

    return valores.reduce((a, b) => a + b) / valores.length;
  }

  double? calcularMediaFinal() {
    final medias = List.generate(
      4,
      (index) => calcularMediaUnidade(index + 1),
    ).whereType<double>().toList();

    if (medias.isEmpty) return null;
    return medias.reduce((a, b) => a + b) / medias.length;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nomeDisciplina': nomeDisciplina,
    'disciplinaId': disciplinaId,
    'notas': notas.map((key, value) => MapEntry(key.toString(), value)),
  };

  factory NotaDisciplina.fromJson(Map<String, dynamic> json) {
    final Map<int, Map<String, double?>> notasMap = {};
    (json['notas'] as Map<String, dynamic>? ?? {}).forEach((key, value) {
      final int unidade = int.parse(key); // converte de string pra int
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

    // Garante que a unidade exista antes de adicionar
    if (novasNotas.containsKey(unidade)) {
      novasNotas[unidade] = {...novasNotas[unidade]!, tipo: nota};
    } else {
      novasNotas[unidade] = {tipo: nota};
    }

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
