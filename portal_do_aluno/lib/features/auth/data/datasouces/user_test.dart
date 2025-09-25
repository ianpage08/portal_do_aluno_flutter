import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:portal_do_aluno/core/user/user.dart';


final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> criarUsuariosTeste() async {
  final usuarios = [
    Usuario(
      id: 'aluno01',
      name: 'Aluno Teste',
      cpf: '85300011122',
      password: 'senha123',
      type: UserType.student,
    ),
    Usuario(
      id: 'prof01',
      name: 'Professor Teste',
      cpf: '11122233344',
      password: 'senha123',
      type: UserType.teacher,
    ),
    Usuario(
      id: 'admin01',
      name: 'Admin Teste',
      cpf: '55566677788',
      password: 'senha123',
      type: UserType.admin,
    ),
  ];

  for (var usuario in usuarios) {
    final senhaHash = BCrypt.hashpw(usuario.password, BCrypt.gensalt());
    await _firestore.collection('usuarios').doc(usuario.id).set({
      'id': usuario.id,
      'nome': usuario.name,
      'cpf': usuario.cpf,
      'senha': senhaHash,
      'tipo': usuario.type.name,
    });
    
  }
}
