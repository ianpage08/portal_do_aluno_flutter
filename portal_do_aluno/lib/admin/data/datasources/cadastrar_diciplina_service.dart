import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portal_do_aluno/admin/data/models/diciplinas.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class DisciplinaService {
  // Stream para listar disciplinas
  Stream<QuerySnapshot> getDisciplinas() {
    return _firestore.collection('disciplinas').snapshots();
  }

  // Cadastrar uma nova disciplina
  Future<void> cadastrarNovaDisciplina(Disciplina disciplina) async {
    final disciplinaJson = disciplina.toJson();
    await _firestore.collection('disciplinas').doc().set(disciplinaJson);
  }
}
