import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portal_do_aluno/admin/data/models/disciplinas/boletim.dart';
import 'package:portal_do_aluno/admin/data/models/disciplinas/nota_disciplina.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class BoletimService {
  CollectionReference get collectionBoletim => _firestore.collection('boletim');

  //  Retorna todos os boletins (painéis administrativos)
  Stream<QuerySnapshot> getBoletins() {
    return collectionBoletim.snapshots();
  }

  // Retorna boletim de um aluno específico em tempo real
  Stream<DocumentSnapshot> getNotas(String alunoId) {
    return collectionBoletim.doc(alunoId).snapshots();
  }

  //  Retorna boletins por matrícula
  Stream<QuerySnapshot> getBoletinsPorMatricula(String matriculaId) {
    return collectionBoletim
        .where('matriculaId', isEqualTo: matriculaId)
        .snapshots();
  }

  // Cria um novo boletim (usando alunoId como ID do documento)
  Future<void> criarBoletim({
    required String alunoId,
    required String matriculaId,
    required List<NotaDisciplina> disciplinas,
  }) async {
    final novoBoletim = Boletim(
      id: alunoId,
      alunoId: alunoId,
      disciplinas: disciplinas,
      mediageral: 0.0,
      situacao: 'Em andamento',
    );

    await collectionBoletim.doc(alunoId).set({
      ...novoBoletim.toJson(),
      'matriculaId': matriculaId,
    });
  }

  //  Salva ou atualiza nota de uma disciplina (sem duplicação)
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

    Boletim boletim;

    //  Cria boletim novo se não existir
    if (!doc.exists) {
      // Busca todas as disciplinas cadastradas
      final disciplinasSnapShot = await _firestore
          .collection('disciplinas')
          .get();

      // Cria lista de NotaDisciplina com notas vazias
      final listaDisciplina = disciplinasSnapShot.docs.map((doc) {
        return NotaDisciplina(
          id: doc.id,
          disciplinaId: doc.id,
          nomeDisciplina: doc['nome'],
        );
      }).toList();

      // Atualiza nota apenas na disciplina correta
      final indexDisciplina = listaDisciplina.indexWhere(
        (d) => d.disciplinaId == disciplinaId,
      );
      if (indexDisciplina >= 0) {
        listaDisciplina[indexDisciplina] = listaDisciplina[indexDisciplina]
            .atualizarNota(unidade, tipo, nota);
      }

      // Cria o boletim com todas as disciplinas
      await criarBoletim(
        alunoId: alunoId,
        matriculaId: matriculaId,
        disciplinas: listaDisciplina,
      );
      return;
    } else {
      //  Carrega boletim existente
      boletim = Boletim.fromJson(doc.data() as Map<String, dynamic>);
    }

    //  Atualiza ou adiciona disciplina existente
    final indexDisciplina = boletim.disciplinas.indexWhere(
      (d) => d.disciplinaId == disciplinaId,
    );

    if (indexDisciplina >= 0) {
      // Atualiza nota na disciplina existente
      boletim.disciplinas[indexDisciplina] = boletim
          .disciplinas[indexDisciplina]
          .atualizarNota(unidade, tipo, nota);
    } else {
      // Adiciona nova disciplina se não existir
      boletim.disciplinas.add(
        NotaDisciplina(
          id: disciplinaId,
          disciplinaId: disciplinaId,
          nomeDisciplina: nomeDisciplina,
        ).atualizarNota(unidade, tipo, nota),
      );
    }

    //  Recalcula média geral e situação
    double mediaGeral = calcularMediaGeral(boletim.disciplinas);
    String situacao = mediaGeral >= 6 ? 'Aprovado' : 'Reprovado';

    //  Salva boletim atualizado
    await docRef.update({
      'disciplinas': boletim.disciplinas.map((d) => d.toJson()).toList(),
      'mediageral': mediaGeral,
      'situacao': situacao,
      'dataAtualizacao': FieldValue.serverTimestamp(),
    });
  }

  // Calcula média geral
  double calcularMediaGeral(List<NotaDisciplina> disciplinas) {
    final medias = disciplinas
        .map((d) => d.calcularMediaFinal())
        .whereType<double>()
        .toList();
    if (medias.isEmpty) return 0.0;
    return medias.reduce((a, b) => a + b) / medias.length;
  }

  // Busca boletim de um aluno (direto pelo documento)
  Future<Boletim?> buscarBoletimPorAluno(String alunoId) async {
    final doc = await collectionBoletim.doc(alunoId).get();
    if (!doc.exists) return null;
    return Boletim.fromJson(doc.data() as Map<String, dynamic>);
  }

  // Exclui boletim de um aluno
  Future<void> excluirBoletim(String alunoId) async {
    await collectionBoletim.doc(alunoId).delete();
  }
}
