import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bcrypt/bcrypt.dart';

import 'package:portal_do_aluno/core/user/user.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class CadastroService {
  // Cadastra um usuário no Firestore
  Future<String> cadastroUsuario(Usuario usuario) async {
    // Hash da senha
    final senhaHash = BCrypt.hashpw(usuario.password, BCrypt.gensalt());

    // Verifica CPF duplicado
    final consulta = await _firestore
        .collection('usuarios')
        .where('cpf', isEqualTo: usuario.cpf.replaceAll(RegExp(r'\D'), ''))
        .limit(1)
        .get();

    if (consulta.docs.isNotEmpty) {
      throw Exception('CPF já cadastrado');
    }

    // Cria documento no Firestore com ID gerado
    final usuarioRef = _firestore.collection('usuarios').doc();

    await usuarioRef.set({
      'id': usuarioRef.id,
      'name': usuario.name,
      'cpf': usuario.cpf.replaceAll(RegExp(r'\D'), ''),
      'password': senhaHash,
      'type': usuario.type.name,
      'turmaId': usuario.turmaId,
      'alunoId': usuario.alunoId,
      
    });

    return usuarioRef.id;
  }

  Future<void> deletarUsuario(String usuarioId) {
    return _firestore.collection('usuarios').doc(usuarioId).delete();
  }
}
