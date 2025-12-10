import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:portal_do_aluno/core/user/user.dart';

class AuthStorageService {
  static final AuthStorageService _instance = AuthStorageService._internal();

  factory AuthStorageService() {
    return _instance;
  }

  AuthStorageService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  //Salva o token no dispositivo
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  //Recupera o token do dispositivo
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  //deleta o token do dispositivo
  Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }
  //Salva o usuário no dispositivo
  Future<void> saveUsuario(Usuario user) async {
    await _storage.write(key: 'usuario', value: jsonEncode(user.toJsonSafe()));
  }

  //Recupera o usuário do dispositivo
  Future<Usuario?> getUser() async {
    final userJson = await _storage.read(key: 'usuario');
    if (userJson == null) {
      return null;
    }
    return Usuario.fromJson(jsonDecode(userJson));
  }
  //deleta o usuário do dispositivo
  Future<void> deleteUsuario() async {
    await _storage.delete(key: 'usuario');
  }
}
