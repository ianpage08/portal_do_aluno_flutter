import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portal_do_aluno/admin/data/models/calendario.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _collectionCalendario = _firestore.collection(
  'calendario',
);

class CalendarioService {
  Stream<QuerySnapshot> getCalendario() {
    return _collectionCalendario.snapshots();
  }

  Future<void> cadastrarCalendario(Calendario calendario) async {
    final docRef = _collectionCalendario.doc();
    final novoCalendario = calendario.copyWith(id: docRef.id);

    await docRef.set(novoCalendario.toJson());
  }

  Future<void> excluirCalendario(String calendarioId) {
    return _collectionCalendario.doc(calendarioId).delete();
  }
}
