class Endereco {
  final String cep;
  final String rua;
  final String cidade;
  final String estado;
  final String bairro;
  final String numero;

  Endereco({
    required this.cep,
    required this.rua,
    required this.cidade,
    required this.estado,
    required this.bairro,
    required this.numero,
  });
  Map<String, dynamic> toJson() => {
    'cep': cep,
    'rua': rua,
    'cidade': cidade,
    'estado': estado,
    'bairro': bairro,
    'numero': numero,
  };

  factory Endereco.fromJson(Map<String, dynamic> json) => Endereco(
    cep: json['cep'] as String? ?? '',
    rua: json['rua'] as String? ?? '',
    cidade: json['cidade'] as String? ?? '',
    estado: json['estado'] as String? ?? '',
    bairro: json['bairro'] as String? ?? '',
    numero: json['numero'] as String? ?? '',
  );
  Endereco copyWith({
    String? cep,
    String? rua,
    String? cidade,
    String? estado,
    String? bairro,
    String? numero,
  }) {
    return Endereco(
      cep: cep ?? this.cep,
      rua: rua ?? this.rua,
      cidade: cidade ?? this.cidade,
      estado: estado ?? this.estado,
      bairro: bairro ?? this.bairro,
      numero: numero ?? this.numero,
    );
  }
}
