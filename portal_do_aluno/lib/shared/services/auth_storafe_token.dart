import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorageService {
  static final AuthStorageService _instance =
      AuthStorageService._internal();

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
  Future<void> deletarToken() async {
    await _storage.delete(key: 'auth_token');
  }
}
