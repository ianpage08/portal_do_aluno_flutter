import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class TokensService {
  Future<void> gerarToken(String userId) async {
    try {
      String? fmcToken = await _firebaseMessaging.getToken();

      if (fmcToken == null) {
        throw Exception('Falha ao gerar token');
      }
      final docRef = _firestore
          .collection('usuarios')
          .doc(userId)
          .collection('tokens')
          .doc(fmcToken);
      final doc = await docRef.get();

      if (!doc.exists ) {
        await docRef.set({
          'userId': userId,
          'fmcToken': fmcToken,
          'createdToken': FieldValue.serverTimestamp(),
        });

        debugPrint('Token gerado com sucesso: $fmcToken');
        return;
      }
      await docRef.update({
        'fmcToken': fmcToken,
        'lastToken': FieldValue.serverTimestamp(),
      });

      debugPrint('Token atualizado com sucesso: $fmcToken');
    } catch (e) {
      debugPrint('Erro ao gerar token: $e');
    }
  }
}
