import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portal_do_aluno/core/user/user.dart';
import 'package:bcrypt/bcrypt.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class AuthServico {
  /// Stream para monitorar se o usuário está logado ou não
  Stream<Usuario?> get usuario {
    return _auth.authStateChanges().asyncMap(_userFromFirebaseUsuario);
  }

  /// Converte User do FirebaseAuth em Usuario do Firestore
  Future<Usuario?> _userFromFirebaseUsuario(User? firebaseUser) async {
    if (firebaseUser == null) return null;
    try {
      final doc =
          await _firestore.collection('usuarios').doc(firebaseUser.uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return Usuario.fromJson(data);
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  /// Login usando CPF + Senha (com BCrypt no Firestore)
  Future<Usuario?> loginCpfsenha(String cpf, String senha) async {
    try {
      final consulta = await _firestore
          .collection('usuarios')
          .where('cpf', isEqualTo: cpf)
          .limit(1)
          .get();

      if (consulta.docs.isEmpty) {
        throw Exception('CPF não encontrado');
      }

      final data = consulta.docs.first.data();
      final senhaHash = data['senha'] as String;

      // Valida senha com BCrypt
      if (!BCrypt.checkpw(senha, senhaHash)) {
        throw Exception('Senha incorreta');
      }

      // Retorna usuário válido
      return Usuario.fromJson(data);
    } catch (e) {
      
      return null;
    }
  }
}
