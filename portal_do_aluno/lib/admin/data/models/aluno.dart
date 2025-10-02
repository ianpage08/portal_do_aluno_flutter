import 'package:cloud_firestore/cloud_firestore.dart';

class DadosAluno {
  final String? id;
  final String nome;
  final String cpf;
  final String sexo;
  final DateTime dataNascimento;
  final String naturalidade;

  DadosAluno({
    this.id,
    required this.nome,
    required this.cpf,
    required this.sexo,
    required this.naturalidade,
    required this.dataNascimento,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'cpf': cpf,
        'sexo': sexo,
        'naturalidade': naturalidade,
        'dataNascimento': Timestamp.fromDate(dataNascimento),
      };

  factory DadosAluno.fromJson(Map<String, dynamic> json) {
    return DadosAluno(
      id: json['id'] as String,
      nome: json['nome'] as String,
      cpf: json['cpf'] as String,
      sexo: json['sexo'] as String,
      naturalidade: json['naturalidade'] as String,
      dataNascimento: (json['dataNascimento'] as Timestamp).toDate(),
    );
  }

  DadosAluno copyWith({
    String? id,
    String? nome,
    String? cpf,
    String? sexo,
    String? naturalidade,
    DateTime? dataNascimento,
  }) {
    return DadosAluno(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      cpf: cpf ?? this.cpf,
      sexo: sexo ?? this.sexo,
      naturalidade: naturalidade ?? this.naturalidade,
      dataNascimento: dataNascimento ?? this.dataNascimento,
    );
  }

  int calcularIdade() {
    final hoje = DateTime.now();
    int idade = hoje.year - dataNascimento.year;
    if (hoje.month < dataNascimento.month ||
        (hoje.month == dataNascimento.month && hoje.day < dataNascimento.day)) {
      idade--;
    }
    return idade;
  }

  String get formatarDataNascimento {
    return '${dataNascimento.day.toString().padLeft(2, '0')}/'
        '${dataNascimento.month.toString().padLeft(2, '0')}/'
        '${dataNascimento.year}';
  }
}

class EnderecoAluno {
  final String cep;
  final String rua;
  final String cidade;
  final String estado;
  final String bairro;
  final String numero;

  EnderecoAluno({
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

  factory EnderecoAluno.fromJson(Map<String, dynamic> json) => EnderecoAluno(
        cep: json['cep'] as String? ?? '',
        rua: json['rua'] as String? ?? '',
        cidade: json['cidade'] as String? ?? '',
        estado: json['estado'] as String? ?? '',
        bairro: json['bairro'] as String? ?? '',
        numero: json['numero'] as String? ?? '',
      );

  EnderecoAluno copyWith({
    String? cep,
    String? rua,
    String? cidade,
    String? estado,
    String? bairro,
    String? numero,
  }) {
    return EnderecoAluno(
      cep: cep ?? this.cep,
      rua: rua ?? this.rua,
      cidade: cidade ?? this.cidade,
      estado: estado ?? this.estado,
      bairro: bairro ?? this.bairro,
      numero: numero ?? this.numero,
    );
  }
}

class ResponsaveisAluno {
  final String? nomeMae;
  final String? cpfMae;
  final String? telefoneMae;
  final String? nomePai;
  final String? cpfPai;
  final String? telefonePai;

  ResponsaveisAluno({
    this.nomeMae,
    this.cpfMae,
    this.telefoneMae,
    this.nomePai,
    this.cpfPai,
    this.telefonePai,
  });

  Map<String, dynamic> toJson() => {
        'nomeMae': nomeMae,
        'cpfMae': cpfMae,
        'telefoneMae': telefoneMae,
        'nomePai': nomePai,
        'cpfPai': cpfPai,
        'telefonePai': telefonePai,
      };

  factory ResponsaveisAluno.fromJson(Map<String, dynamic> json) =>
      ResponsaveisAluno(
        nomeMae: json['nomeMae'] as String? ?? '---',
        cpfMae: json['cpfMae'] as String? ?? '---',
        telefoneMae: json['telefoneMae'] as String? ?? '---',
        nomePai: json['nomePai'] as String? ?? '---',
        cpfPai: json['cpfPai'] as String? ?? '---',
        telefonePai: json['telefonePai'] as String? ?? '---',
      );

  ResponsaveisAluno copyWith({
    String? nomeMae,
    String? cpfMae,
    String? telefoneMae,
    String? nomePai,
    String? cpfPai,
    String? telefonePai,
  }) {
    return ResponsaveisAluno(
      nomeMae: nomeMae ?? this.nomeMae,
      cpfMae: cpfMae ?? this.cpfMae,
      telefoneMae: telefoneMae ?? this.telefoneMae,
      nomePai: nomePai ?? this.nomePai,
      cpfPai: cpfPai ?? this.cpfPai,
      telefonePai: telefonePai ?? this.telefonePai,
    );
  }
}

class DadosAcademicos {
  final String numeroMatricula;
  final String turma;
  final String anoLetivo;
  final String turno;
  final String situacao;
  final DateTime dataMatricula;

  DadosAcademicos({
    required this.numeroMatricula,
    required this.turma,
    required this.anoLetivo,
    required this.turno,
    required this.situacao,
    required this.dataMatricula,
  });

  Map<String, dynamic> toJson() => {
        'numeroMatricula': numeroMatricula,
        'turma': turma,
        'anoLetivo': anoLetivo,
        'turno': turno,
        'situacao': situacao,
        'dataMatricula': Timestamp.fromDate(dataMatricula),
      };

  factory DadosAcademicos.fromJson(Map<String, dynamic> json) =>
      DadosAcademicos(
        numeroMatricula: json['numeroMatricula'] as String,
        turma: json['turma'] as String,
        anoLetivo: json['anoLetivo'] as String,
        turno: json['turno'] as String,
        situacao: json['situacao'] as String,
        dataMatricula: (json['dataMatricula'] as Timestamp).toDate(),
      );

  DadosAcademicos copyWith({
    String? numeroMatricula,
    String? turma,
    String? anoLetivo,
    String? turno,
    String? situacao,
    DateTime? dataMatricula,
  }) {
    return DadosAcademicos(
      numeroMatricula: numeroMatricula ?? this.numeroMatricula,
      turma: turma ?? this.turma,
      anoLetivo: anoLetivo ?? this.anoLetivo,
      turno: turno ?? this.turno,
      situacao: situacao ?? this.situacao,
      dataMatricula: dataMatricula ?? this.dataMatricula,
    );
  }
}

class InformacoesMedicasAluno {
  final String? alergia;
  final String? medicacao;
  final String? observacoes;

  InformacoesMedicasAluno({
    this.alergia,
    this.medicacao,
    this.observacoes,
  });

  Map<String, dynamic> toJson() => {
        'alergia': alergia,
        'medicacao': medicacao,
        'observacoes': observacoes,
      };

  factory InformacoesMedicasAluno.fromJson(Map<String, dynamic> json) =>
      InformacoesMedicasAluno(
        alergia: json['alergia'] as String? ?? '',
        medicacao: json['medicacao'] as String? ?? '',
        observacoes: json['observacoes'] as String? ?? '',
      );

  InformacoesMedicasAluno copyWith({
    String? alergia,
    String? medicacao,
    String? observacoes,
  }) {
    return InformacoesMedicasAluno(
      alergia: alergia ?? this.alergia,
      medicacao: medicacao ?? this.medicacao,
      observacoes: observacoes ?? this.observacoes,
    );
  }
}
