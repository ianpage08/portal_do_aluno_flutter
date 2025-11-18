import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:portal_do_aluno/admin/data/models/exercicios.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class ExercicioSevice {
  Stream<QuerySnapshot> getExercicios() {
    return _firestore.collection('exercicios').snapshots();
  }

  Future<void> cadastrarNovoExercicio(Exercicios exercicios, String turmaId) async {
    final docRef = _firestore.collection('exercicios').doc();
    final novoExercicio = exercicios.copyWith(id: docRef.id);

    await docRef.set(novoExercicio.toJson());

    final alunosSnapshot = await _firestore
        .collection('usuarios')
        .where('turmaId', isEqualTo: turmaId)
        .get();

    debugPrint('total de Alunos encontrados : ${alunosSnapshot.docs.length.toString()}');

    final batch = _firestore.batch();
    for (var aluno in alunosSnapshot.docs) {

      final documenteRef = aluno.reference
          .collection('exercicios_status')
          .doc(docRef.id);
      batch.set(documenteRef, {'id': docRef.id, 'status': false });
    }

    await batch.commit();
    debugPrint('Exercício cadastrado com sucesso! $novoExercicio');
  }

  Future<void> excluirExercicio(String exercicioId) {
    return _firestore.collection('exercicios').doc(exercicioId).delete();
  }

  Future<void> atualizarStatusDoExercicio(
    String exercicioId,
    String alunoId,
    bool status,
  ) async {
    final alunoSnapshot = await _firestore
        .collection('usuarios')
        .where('alunoId', isEqualTo: alunoId)
        .get();
    if (alunoSnapshot.docs.isEmpty) {
      debugPrint('Aluno não encontrado');
      return;
    }
    final batch = _firestore.batch();

    for (var aluno in alunoSnapshot.docs) {

      final docRef = aluno.reference
          .collection('exercicios_status')
          .doc(exercicioId);

      batch.update(docRef, {'status': status});
          
    }
    await batch.commit();
    debugPrint('Status do exercício atualizado com sucesso!');
  }
}
