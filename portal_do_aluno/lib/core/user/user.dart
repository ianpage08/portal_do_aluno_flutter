enum UserType { student, teacher, parent, admin }

class Usuario {
  final String id;
  final String? turmaId;
  final String? alunoId;
  final String cpf;
  final String name;
  final String password;
  final UserType type;
  

  Usuario({
    required this.id,
    required this.name,
    required this.password,
    required this.type,
    required this.cpf,
    this.turmaId,
    this.alunoId,
  });

  
  //Para que: Enviar dados para API, salvar no banco
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'password': password,
    'cpf': cpf,
    'type': type.name, // Converte enum em string
    'turmaId': turmaId,
    'alunoId': alunoId,
  };
  /*factory = Construtor  que pode retornar instância existente
  Converte Map em objeto Usuario
  Para que: Receber dados da API, carregar do banco
  UserType.values.byName() = Converte string em enum*/
  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
    id: json['id'] as String? ?? '', // valor padrão caso seja null
    name: json['name'] as String? ?? 'Sem Nome', // evita erro se name for null
    password: json['password'] as String? ?? '', // evita null na senha
    cpf: json['cpf'] as String? ?? '', // evita null no cpf
    type: json['type'] != null
        ? UserType.values.byName(
            json['type'] as String,
          ) // converte string para enum
        : UserType.student, // fallback se type for null
    turmaId: json['turmaId'] as String? ?? '',
    alunoId: json['alunoId'] as String? ?? '',
  );

  Usuario copyWith({
    String? id,
    String? name,
    String? password,
    String? cpf,
    UserType? type,
    String? turmaId,
    String? alunoId,
  }) => Usuario(
    id: id ?? this.id,
    name: name ?? this.name,
    password: password ?? this.password,
    cpf: cpf ?? this.cpf,
    type: type ?? this.type,
    turmaId: turmaId ?? this.turmaId,
    alunoId: alunoId ?? this.alunoId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Usuario && runtimeType == other.runtimeType && id == other.id;
  /*Define código hash do objeto
Para que: Usar em Set, Map, comparações eficientes
Por que id: ID é único, então serve como hash */
  @override
  int get hashCode => id.hashCode;

  get toJasonSafe => null;

  Map<String, dynamic> toJsonSafe() {
    return {
      'id': id,
      'name': name,
      'cpf': cpf,
      'type': type.name,
      'turmaId': turmaId,
      'alunoId': alunoId,
      // senha não incluída por segurança
    };
  }
}
