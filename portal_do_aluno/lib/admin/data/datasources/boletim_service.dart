import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portal_do_aluno/admin/data/models/disciplinas/boletim.dart';
import 'package:portal_do_aluno/admin/data/models/disciplinas/nota_disciplina.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class BoletimService {
  CollectionReference get _collectionBoletim =>
      _firestore.collection('boletim');

  /// 🔹 Retorna todos os boletins (painéis administrativos)
  Stream<QuerySnapshot> getBoletins() {
    return _collectionBoletim.snapshots();
  }

  /// 🔹 Retorna boletins de um aluno específico em tempo real
  Stream<QuerySnapshot> getNotas(String alunoId) {
    return _collectionBoletim
        .where('alunoid', isEqualTo: alunoId) // corrigido filtro
        .snapshots();
  }

  /// 🔹 Retorna boletins por matrícula
  Stream<QuerySnapshot> getBoletinsPorMatricula(String matriculaId) {
    return _collectionBoletim
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
      id: _collectionBoletim.doc().id,
      alunoId: alunoId, // corrigido atributo
      disciplinas: disciplinas,
      mediageral: 0.0,
      situacao: 'Em andamento',
    );

    await _collectionBoletim.doc(novoBoletim.id).set({
      ...novoBoletim.toJson(),
      'matriculaId': matriculaId, // corrigido typo
    });
  }

  /// 🔹 Atualiza uma nota específica e recalcula médias
  Future<void> atualizarNota({
    required String boletimId,
    required String disciplinaId,
    required int unidade,
    required String tipo, // 'teste' ou 'prova'
    required double nota,
  }) async {
    final boletimDoc = await _collectionBoletim.doc(boletimId).get();
    if (!boletimDoc.exists) return;

    final boletim =
        Boletim.fromJson(boletimDoc.data() as Map<String, dynamic>);

    // Atualiza a disciplina correta
    final novasDisciplinas = boletim.disciplinas.map((disciplina) {
      if (disciplina.disciplinaId == disciplinaId) {
        return disciplina.atualizarNota(unidade, tipo, nota);
      }
      return disciplina;
    }).toList();

    // Recalcula a média geral e situação
    final novaMediaGeral = _calcularMediaGeral(novasDisciplinas);
    final novaSituacao = novaMediaGeral >= 6.0 ? 'Aprovado' : 'Reprovado';

    // Atualiza no Firestore
    await _collectionBoletim.doc(boletimId).update({
      'disciplinas': novasDisciplinas.map((e) => e.toJson()).toList(),
      'mediageral': novaMediaGeral,
      'situacao': novaSituacao,
    });
  }

  /// 🔹 Cálculo interno da média geral
  double _calcularMediaGeral(List<NotaDisciplina> disciplinas) {
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
    final query = await _collectionBoletim
        .where('alunoid', isEqualTo: alunoId)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;

    return Boletim.fromJson(query.docs.first.data() as Map<String, dynamic>);
  }
}
