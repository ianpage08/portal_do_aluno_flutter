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
      novoComunicado.destinatario.name,
    );
    final batch = _firestore.batch();

    for (var destinatario in usuariosSnapshot.docs) {
      final userId = destinatario.id;
      final document = _firestore
          .collection('usuarios')
          .doc(userId)
          .collection('visualizacoes')
          .doc(docRef.id);
      
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
    debugPrint(
      ' Comunicado enviado e subcoleções criadas com sucesso! $usuariosSnapshot',
    );
  }

  Future<void> excluirComunicado(String comunicadoId) async {
    await comunicadosCollection.doc(comunicadoId).delete();
  }

  Future<int> calcularQuantidadeDeCominicados() async {
    final qtd = await comunicadosCollection.get();
    return qtd.docs.length;
  }

  Future<QuerySnapshot> buscarUsuariosPorTipo(String destinatario) {
    destinatario = destinatario.toLowerCase();
    switch (destinatario) {
      case 'todos':
        return _firestore.collection('usuarios').get();

      case 'alunos':
        return _firestore
            .collection('usuarios')
            .where('type', isEqualTo: 'student')
            .get();

      case 'professores':
        return _firestore
            .collection('usuarios')
            .where('type', isEqualTo: 'teacher')
            .get();

      case 'responsáveis':
        return _firestore
            .collection('usuarios')
            .where('type', isEqualTo: 'responsavel')
            .get();

      default:
        debugPrint('⚠️ Destinatário desconhecido: $destinatario');
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

  Stream<int> contadorDeVisualizacoesTotalVistas() {
    return _firestore
        .collectionGroup('visualizacoes')
        .where('visualizado', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<int> contadorDeVisualizacoesNaoVistasPorId(String userId) {
    return _firestore
        .collection('usuarios')
        .doc(userId)
        .collection('visualizacoes')
        .where('visualizado', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Future<void> atualizarVisualizacao(String userID) async {
    final docRef = await _firestore
        .collection('usuarios')
        .doc(userID)
        .collection('visualizacoes')
        .where('visualizado', isEqualTo: false)
        .get();

    WriteBatch batch = _firestore.batch();

    for (var usuario in docRef.docs) {
      batch.update(usuario.reference, {
        'visualizado': true,

        'dataVisualizacao': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }
}
