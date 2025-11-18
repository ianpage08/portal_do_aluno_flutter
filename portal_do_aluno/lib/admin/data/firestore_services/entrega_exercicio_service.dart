import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portal_do_aluno/admin/data/models/entrega_de_atividade.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class EntregaExercicioService {
  Future<void> entregarExercicio({
    required String exerciciosId,
    required String alunoId,
    required EntregaDeAtividade entrega,
  }) async {
    final docRef = _firestore
        .collection('exercicios')
        .doc(exerciciosId)
        .collection('entregas')
        .doc(alunoId);

    return docRef.set(entrega.toJson());
  }

  Future<void> excluirAtividade(String exerciciosId, String alunoId) async {
    return _firestore
        .collection('exercicios')
        .doc(exerciciosId)
        .collection('entregas')
        .doc(alunoId)
        .delete();
  }
}
