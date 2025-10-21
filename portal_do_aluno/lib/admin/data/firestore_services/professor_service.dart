import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portal_do_aluno/admin/data/models/professor.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class ProfessorService {
  Stream<QuerySnapshot> getProfessor() {
    return _firestore.collection('professores').snapshots();
  }

  Future<void> cadastrarProfessor({
    required String usuarioId,
    required classId,
    required Professor professor,
  }) async {
    final docRef = _firestore.collection('professores').doc();
    final novoProfessor = professor.copyWith(
      id: docRef.id,
      classId: classId,
      usuarioId: '',
    );

    await docRef.set(novoProfessor.toJson());
  }

  Future<void> excluirProfessor(String professorId) {
    return _firestore.collection('professores').doc(professorId).delete();
  }
}
