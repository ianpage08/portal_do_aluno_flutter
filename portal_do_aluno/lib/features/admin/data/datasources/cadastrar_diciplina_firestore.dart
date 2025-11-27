import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portal_do_aluno/features/admin/data/models/diciplinas.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class DisciplinaService {
  // Stream para listar disciplinas
  Stream<QuerySnapshot> getDisciplinas() {
    return _firestore.collection('disciplinas').snapshots();
  }

  // Cadastrar uma nova disciplina
  Future<void> cadastrarNovaDisciplina(Disciplina disciplina) async {
    final docRef = _firestore.collection('disciplinas').doc();

    final novaDisciplina = disciplina.copyWith(id: docRef.id);
    await docRef.set(novaDisciplina.toJson());
  }

  Future<void> excluirDisciplina(String disciplinaId) async {
    await _firestore.collection('disciplinas').doc(disciplinaId).delete();
  }
}
