import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:portal_do_aluno/core/user/user.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> CadastroUsuario(Usuario usuario) async {
  final senhaHash = BCrypt.hashpw(usuario.password, BCrypt.gensalt());
  

  await _firestore.collection('usuarios').doc(usuario.id).set(
    {'id': usuario.id,
    'cpf': usuario.cpf,
    'nome': usuario.name,
    'senha': senhaHash,
    'tipo': usuario.type.name}
  );
}
