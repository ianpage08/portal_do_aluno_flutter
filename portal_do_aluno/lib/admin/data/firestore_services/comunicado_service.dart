import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portal_do_aluno/admin/data/models/comunicado.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference comunicadosCollection = _firestore.collection(
  'comunicados',
);

class ComunicadoService {
  Stream<QuerySnapshot> getComunicados() {
    return comunicadosCollection.snapshots();
  }

  Stream<QuerySnapshot> getComunicadosPorDestinatario(
    Destinatario destinatario,
  ) {
    return comunicadosCollection
        .where('destinatario', isEqualTo: destinatario.toString())
        .snapshots();
  }

  Future<void> enviarComunidado(Comunicado comunidado) async {
    final docRef = comunicadosCollection.doc();
    final novaComunicado = comunidado.copyWith(id: docRef.id);

    await docRef.set(novaComunicado.toJson());
  }

  Future<void> excluirComunicado(String comunicadoId) async {
    await comunicadosCollection.doc(comunicadoId).delete();
  }

  Future<int> calcularQuantidadeDeCominicados() async {
    final qtd = await comunicadosCollection.get();
    return qtd.docs.length;
  }
  Future<List<String>> getTokensDestinatario(String destinatario) async {
  QuerySnapshot snapshot;

  switch (destinatario) {
    case 'Todos':
      snapshot = await FirebaseFirestore.instance.collection('usuarios').get();
      break;
    case 'Alunos':
      snapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('type', isEqualTo: 'student')
          .get();
      break;
    case 'Professores':
      snapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('type', isEqualTo: 'teacher')
          .get();
      break;
    case 'Responsáveis':
      snapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('type', isEqualTo: 'responsavel')
          .get();
      break;
    default:
      snapshot = await FirebaseFirestore.instance.collection('usuarios').get();
  }

  // Filtra apenas os tokens não nulos
  return snapshot.docs
      .map((doc) => doc['fcmToken'] as String?)
      .where((token) => token != null)
      .cast<String>()
      .toList();
}

}
