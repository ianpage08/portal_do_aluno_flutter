import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portal_do_aluno/admin/data/models/disciplinas/boletim.dart';
import 'package:portal_do_aluno/admin/data/models/disciplinas/nota_disciplina.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class BoletimService {
  CollectionReference get collectionBoletim =>
      _firestore.collection('boletim');

  /// 🔹 Retorna todos os boletins (painéis administrativos)
  Stream<QuerySnapshot> getBoletins() {
    return collectionBoletim.snapshots();
  }

  /// 🔹 Retorna boletins de um aluno específico em tempo real
  Stream<QuerySnapshot> getNotas(String alunoId) {
    return collectionBoletim
        .where('alunoid', isEqualTo: alunoId) // corrigido filtro
        .snapshots();
  }

  /// 🔹 Retorna boletins por matrícula
  Stream<QuerySnapshot> getBoletinsPorMatricula(String matriculaId) {
    return collectionBoletim
        .where('matriculaId', isEqualTo: matriculaId)
        .snapshots();
  }

  /// 🔹 Cria um novo boletim
  Future<void> criarBoletim({
    required String alunoId,
    required String matriculaId,
    required List<NotaDisciplina> disciplinas,
  }) async {
    final novoBoletim = Boletim(
      id: collectionBoletim.doc().id,
      alunoId: alunoId, // corrigido atributo
      disciplinas: disciplinas,
      mediageral: 0.0,
      situacao: 'Em andamento',
    );

    await collectionBoletim.doc(novoBoletim.id).set({
      ...novoBoletim.toJson(),
      'matriculaId': matriculaId, // corrigido typo
    });
  }

  /// 🔹 Atualiza uma nota específica e recalcula médias
  Future<void> salvarOuAtualizarNota({
  required String alunoId,
  required String matriculaId,
  required String disciplinaId,
  required String nomeDisciplina,
  required int unidade,
  required String tipo, // 'teste', 'prova', 'trabalho', 'extra'
  required double nota,
}) async {
  // 🔹 Busca boletim
  Boletim? boletim = await buscarBoletimPorAluno(alunoId);

  if (boletim == null) {
    // Cria boletim novo
    final novaDisciplina = NotaDisciplina(
      id: disciplinaId,
      disciplinaId: disciplinaId,
      nomeDisciplina: nomeDisciplina,
      notas: {unidade: {tipo: nota}},
    );

    await criarBoletim(
      alunoId: alunoId,
      matriculaId: matriculaId,
      disciplinas: [novaDisciplina],
    );
    return;
  }

  // 🔹 Boletim existe, atualiza disciplina
  NotaDisciplina disciplina = boletim.disciplinas.firstWhere(
    (d) => d.disciplinaId == disciplinaId,
    orElse: () => NotaDisciplina(
      id: disciplinaId,
      disciplinaId: disciplinaId,
      nomeDisciplina: nomeDisciplina,
    ),
  );

  // Atualiza nota
  disciplina = disciplina.atualizarNota(unidade, tipo, nota);

  // Atualiza lista de disciplinas no boletim
  List<NotaDisciplina> disciplinasAtualizadas = boletim.disciplinas
      .where((d) => d.disciplinaId != disciplinaId)
      .toList()
    ..add(disciplina);

  // Recalcula média e situação
  double mediaGeral = calcularMediaGeral(disciplinasAtualizadas);
  String situacao = mediaGeral >= 6 ? 'Aprovado' : 'Reprovado';

  // Salva tudo no mesmo documento
  await collectionBoletim.doc(boletim.id).update({
    'disciplinas': disciplinasAtualizadas.map((d) => d.toJson()).toList(),
    'mediageral': mediaGeral,
    'situacao': situacao,
  });
}


  /// 🔹 Cálculo interno da média geral
  double calcularMediaGeral(List<NotaDisciplina> disciplinas) {
    final medias = disciplinas
        .map((disc) => disc.calcularMediaFinal())
        .where((m) => m != null)
        .map((m) => m!)
        .toList();

    if (medias.isEmpty) return 0.0;

    return medias.reduce((a, b) => a + b) / medias.length;
  }

  /// 🔹 Busca um boletim de um aluno (único)
  Future<Boletim?> buscarBoletimPorAluno(String alunoId) async {
    final query = await collectionBoletim
        .where('alunoid', isEqualTo: alunoId)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;

    return Boletim.fromJson(query.docs.first.data() as Map<String, dynamic>);
  }
}
