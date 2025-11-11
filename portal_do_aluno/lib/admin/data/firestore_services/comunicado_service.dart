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
    final novoComunicado = comunidado.copyWith(id: docRef.id);

    await docRef.set(novoComunicado.toJson());

    final usuariosSnapshot = await buscarUsuariosPorTipo(
      novoComunicado.destinatario.toString(),
    );
    final batch = _firestore.batch();

    for (var destinatario in usuariosSnapshot.docs) {
      final userId = destinatario.id;
      final document = _firestore
          .collection('usuarios')
          .doc(userId)
          .collection('visualizacoes')
          .doc(docRef.id);
      debugPrint('🧾 Adicionando comunicado para usuário: $userId');
      debugPrint(userId);
      debugPrint(docRef.id);
      debugPrint(document.toString());

      batch.set(document, {
        'id': docRef.id,
        'userId': userId,
        'titulo': novoComunicado.titulo,
        'mensagem': novoComunicado.mensagem,
        'dataPublicacao': novoComunicado.dataPublicacao,

        'visualizado': false,
      });
    }
    await batch.commit();
    debugPrint(' Comunicado enviado e subcoleções criadas com sucesso!');
  }

  Future<void> excluirComunicado(String comunicadoId) async {
    await comunicadosCollection.doc(comunicadoId).delete();
  }

  Future<int> calcularQuantidadeDeCominicados() async {
    final qtd = await comunicadosCollection.get();
    return qtd.docs.length;
  }

  Future<QuerySnapshot> buscarUsuariosPorTipo(String destinatario) {
    switch (destinatario) {
      case 'Todos':
        return _firestore.collection('usuarios').get();

      case 'Alunos':
        return _firestore
            .collection('usuarios')
            .where('type', isEqualTo: 'aluno')
            .get();

      case 'Professores':
        return _firestore
            .collection('usuarios')
            .where('type', isEqualTo: 'teacher')
            .get();

      case 'Responsáveis':
        return _firestore
            .collection('usuarios')
            .where('type', isEqualTo: 'responsavel')
            .get();

      default:
        return _firestore.collection('usuarios').get();
    }
  }

  Future<List<String>> getTokensDestinatario(String destinatario) async {
    final firestore = FirebaseFirestore.instance;
    List<String> tokens = [];

    try {
      QuerySnapshot usuariosSnapshot = await buscarUsuariosPorTipo(
        destinatario,
      );

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
  // vai me retorna as vizualizações em tempo real

  Stream<int> contadorDeVizualizacoesVista() {
    final queryDoc = _firestore
        .collectionGroup('visualizacoes')
        .where('visualizado', isEqualTo: true)
        .snapshots();

    return queryDoc.map((snapshot) => snapshot.docs.length);
  }

  Stream<int> contadorDeVizalizacoesNaoVistas() {
    final query = _firestore
        .collectionGroup('visualizacoes')
        .where('visualizado', isEqualTo: false)
        .snapshots();
    return query.map((snapshot) => snapshot.docs.length);
  }
}
