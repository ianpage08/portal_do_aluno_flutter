

class AppConstants {
  static const String nameApp = 'Portal do Aluno'; //Nome do app
  static const String versionApp = '1.0.0'; //Versão do app
  static const String userKey =
      'user_data'; //Chave para armazenar dados do usuário
  static const String tokenKey =
      'auth_token'; //Chave para armazenar token de autenticação
  //Chaves para salvar dados no armazenamento local do celular. Por que constantes: Evita erros de digitação e facilita manutenção.

  static const Map<String, String> userTypesNames = {
    'student': 'Estudante',
    'teacher': 'Professor',
    'parent': 'Responsável',
    'admin': 'Administrador',
  }; 
}
