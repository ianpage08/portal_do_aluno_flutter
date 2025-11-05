import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
    final firestore = FirebaseFirestore.instance;
    List<String> tokens = [];

    try {
      QuerySnapshot usuariosSnapshot;

      switch (destinatario) {
        case 'Todos':
          usuariosSnapshot = await firestore.collection('usuarios').get();
          break;
        case 'Alunos':
          usuariosSnapshot = await firestore
              .collection('usuarios')
              .where('type', isEqualTo: 'aluno')
              .get();
          break;
        case 'Professores':
          usuariosSnapshot = await firestore
              .collection('usuarios')
              .where('type', isEqualTo: 'teacher')
              .get();
          break;
        case 'Responsáveis':
          usuariosSnapshot = await firestore
              .collection('usuarios')
              .where('type', isEqualTo: 'responsavel')
              .get();
          break;
        default:
          usuariosSnapshot = await firestore.collection('usuarios').get();
      }

      // Busca tokens de cada usuário sem quebrar o fluxo
      for (var usuario in usuariosSnapshot.docs) {
        final userId = usuario.id;

        try {
          final tokensSnapshot = await firestore
              .collection('usuarios')
              .doc(userId)
              .collection('tokens')
              .get();

          for (var tokenDoc in tokensSnapshot.docs) {
            final token = tokenDoc.data()['fmcToken'];
            if (token != null && token is String) {
              tokens.add(token);
            }
          }
        } catch (e) {
          debugPrint('⚠️ Erro ao buscar tokens do usuário $userId: $e');
          continue; // ignora o erro e segue pros próximos usuários
        }
      }

      
      return tokens;
    } catch (e) {
      debugPrint('❌ Erro geral ao buscar tokens: $e');
      return [];
    }
  }
}
