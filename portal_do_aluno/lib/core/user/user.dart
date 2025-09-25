
enum UserType { student, teacher, parent, admin }

class Usuario {
  final String id;
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
  });

  //Converte objeto Usuario em Map (dicionário)
  //Para que: Enviar dados para API, salvar no banco
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'password': password,
    'cpf': cpf,
    'type': type.name, // Converte enum em string
  };
  /*factory = Construtor especial que pode retornar instância existente
  Converte Map em objeto Usuario
  Para que: Receber dados da API, carregar do banco
  UserType.values.byName() = Converte string em enum*/
  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
    id: json['id'],
    name: json['name'],
    password: json['password'],
    cpf: json['cpf'],
    type: UserType.values.byName(json['type']),
  );

  Usuario copyWith({
    String? id,
    String? name,
    String? password,
    String? cpf,
    UserType? type,
  }) => Usuario(
    id: id ?? this.id,
    name: name ?? this.name,
    password: password ?? this.password,
    cpf: cpf ?? this.cpf,
    type: type ?? this.type,
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
      // senha não incluída por segurança
    };
  }

  
}
