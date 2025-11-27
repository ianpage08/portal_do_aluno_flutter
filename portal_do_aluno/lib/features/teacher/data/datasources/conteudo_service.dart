import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portal_do_aluno/features/teacher/data/models/conteudo_presenca.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class ConteudoPresencaService {
  Stream<QuerySnapshot> getConteudoPresenca() {
    return _firestore.collection('conteudoPresenca').snapshots();
  }

  Future<void> cadastrarPresencaConteudoProfessor({
    required String turmaId,
    required ConteudoPresenca conteudoPresenca,
    
    
  }) async {
    final docRef = _firestore.collection('conteudoPresenca').doc();
    final novoConteudoPresenca = conteudoPresenca.copyWith(
      id: docRef.id,
      classId: turmaId,
      
    );

    await docRef.set(novoConteudoPresenca.toJson());
  }

  Future<void> excluirConteudoPresenca(String conteudoPresencaId) {
    return _firestore.collection('conteudoPresenca').doc(conteudoPresencaId).delete();
  }
}
