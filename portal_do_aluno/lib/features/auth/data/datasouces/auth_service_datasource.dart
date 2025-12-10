import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portal_do_aluno/core/user/user.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:portal_do_aluno/shared/services/auth_storafe_token.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class AuthServico {
  /// Login usando CPF + senha (validação com BCrypt)
  Future<Usuario> loginCpfsenha(String cpf, String senha) async {
    final cpfLimpo = cpf.replaceAll(RegExp(r'\D'), '');

    final consulta = await _firestore
        .collection('usuarios')
        .where('cpf', isEqualTo: cpfLimpo)
        .limit(1)
        .get();

    if (consulta.docs.isEmpty) {
      throw Exception('CPF não encontrado');
    }

    final data = consulta.docs.first.data();
    final senhaHash = data['password'] as String;

    if (!BCrypt.checkpw(senha, senhaHash)) {
      throw Exception('Senha incorreta');
    }
    final token = _gerarToken();

    await AuthStorageService().saveToken(token);

    



    return Usuario.fromJson(data);
  }
  String _gerarToken(){
    const char = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(32, (index) => char[random.nextInt(char.length)]).join();

  }

  /// Stream para escutar mudanças de usuário logado (opcional)
  Stream<Usuario?> usuarioLogado(String cpf) {
    final cpfLimpo = cpf.replaceAll(RegExp(r'\D'), '');

    return _firestore
        .collection('usuarios')
        .where('cpf', isEqualTo: cpfLimpo)
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return null;
          final data = snapshot.docs.first.data();
          return Usuario.fromJson(data);
        });
  }
}
