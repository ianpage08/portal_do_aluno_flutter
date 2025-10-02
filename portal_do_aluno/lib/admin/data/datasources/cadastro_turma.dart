import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portal_do_aluno/admin/data/models/turma.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class CadastroTurmaService {
  Stream<QuerySnapshot> getTurmas() {
    return _firestore.collection('turmas').snapshots();
  }

  Future<void> cadatrarNovaTurma(Turma turma) {
    final turmaJson = turma.toJson();
    return _firestore.collection('turmas').doc().set(turmaJson);
  }
}
