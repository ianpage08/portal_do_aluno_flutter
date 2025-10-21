import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portal_do_aluno/admin/data/models/disciplinas/boletim.dart';
import 'package:portal_do_aluno/admin/data/models/disciplinas/nota_disciplina.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class BoletimService {
  CollectionReference get collectionBoletim => _firestore.collection('boletim');

  /// 🔹 Retorna todos os boletins (painéis administrativos)
  Stream<QuerySnapshot> getBoletins() {
    return collectionBoletim.snapshots();
  }

  /// 🔹 Retorna boletins de um aluno específico em tempo real
  Stream<QuerySnapshot> getNotas(String alunoId) {
    return collectionBoletim.where('alunoid', isEqualTo: alunoId).snapshots();
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
      alunoId: alunoId,
      disciplinas: disciplinas,
      mediageral: 0.0,
      situacao: 'Em andamento',
    );

    await collectionBoletim.doc(novoBoletim.id).set({
      ...novoBoletim.toJson(),
      'matriculaId': matriculaId,
    });
  }

  /// 🔹 Salva ou atualiza nota de uma disciplina
  Future<void> salvarOuAtualizarNota({
    required String alunoId,
    required String matriculaId,
    required String disciplinaId,
    required String nomeDisciplina,
    required int unidade,
    required String tipo, // 'teste', 'prova', 'trabalho', 'extra'
    required double nota,
  }) async {
    final docRef = collectionBoletim.doc(alunoId);
    final doc = await docRef.get();

    Boletim? boletim = await buscarBoletimPorAluno(alunoId);

    // 🔹 Cria boletim novo se não existir
    //verificar com o proprio banco de dados 
    if (!doc.exists) {
      final novaDisciplina = NotaDisciplina(
        id: disciplinaId,
        disciplinaId: disciplinaId,
        nomeDisciplina: nomeDisciplina,
      ).atualizarNota(unidade, tipo, nota);

      await criarBoletim(
        alunoId: alunoId,
        matriculaId: matriculaId,
        disciplinas: [novaDisciplina],
      );
      return;
    } else {
      boletim = Boletim.fromJson(doc.data() as Map<String, dynamic>);
    }

    // 🔹 Atualiza ou adiciona disciplina existente
    final indexDisciplina = boletim.disciplinas.indexWhere(
      (d) => d.disciplinaId == disciplinaId,
    );

    if (indexDisciplina >= 0) {
      // Atualiza nota na disciplina existente
      boletim.disciplinas[indexDisciplina] = boletim
          .disciplinas[indexDisciplina]
          .atualizarNota(unidade, tipo, nota);
    } else {
      // Adiciona nova disciplina
      boletim.disciplinas.add(
        NotaDisciplina(
          id: disciplinaId,
          disciplinaId: disciplinaId,
          nomeDisciplina: nomeDisciplina,
        ).atualizarNota(unidade, tipo, nota),
      );
    }

    // 🔹 Recalcula média e situação
    double mediaGeral = calcularMediaGeral(boletim.disciplinas);
    String situacao = mediaGeral >= 6 ? 'Aprovado' : 'Reprovado';

    // 🔹 Salva tudo no mesmo documento
    await collectionBoletim.doc(boletim.id).update({
      'disciplinas': boletim.disciplinas.map((d) => d.toJson()).toList(),
      'mediageral': mediaGeral,
      'situacao': situacao,
    });
  }

  /// 🔹 Calcula média geral
  double calcularMediaGeral(List<NotaDisciplina> disciplinas) {
    final medias = disciplinas
        .map((d) => d.calcularMediaFinal())
        .whereType<double>()
        .toList();

    if (medias.isEmpty) return 0.0;

    return medias.reduce((a, b) => a + b) / medias.length;
  }

  /// 🔹 Busca boletim de um aluno
  Future<Boletim?> buscarBoletimPorAluno(String alunoId) async {
    final query = await collectionBoletim
        .where('alunoid', isEqualTo: alunoId)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;

    return Boletim.fromJson(query.docs.first.data() as Map<String, dynamic>);
  }
}
