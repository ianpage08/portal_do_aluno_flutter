import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portal_do_aluno/admin/data/models/turma.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class CadastroTurmaService {
  Stream<QuerySnapshot> getTurmas() {
    return _firestore.collection('turmas').snapshots();
  }

  Future<void> cadatrarNovaTurma(ClasseDeAula turma) {
    final docRef = _firestore.collection('turmas').doc();
    final novaTurma = turma.copyWith(id: docRef.id);

    return docRef.set(novaTurma.toJson());
  }

  Future<void> excluirTurma(String turmaId) {
    return _firestore.collection('turmas').doc(turmaId).delete();
  }
}
