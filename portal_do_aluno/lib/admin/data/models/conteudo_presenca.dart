import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portal_do_aluno/admin/data/models/frequencia.dart';

class ConteudoPresenca {
  final String id;
  final String classId;
  final String conteudo;
  final DateTime data;
  final Presenca presenca;
  final String? observacoes;
  

  ConteudoPresenca({
    required this.id,
    required this.classId,
    required this.conteudo,
    required this.data,
    this.observacoes,
    this.presenca = Presenca.presente,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'classId': classId,
    'conteudo': conteudo,
    'data': data,
    'observacoes': observacoes,
    'presenca': presenca.name,

  };
  factory ConteudoPresenca.fromJson(Map<String, dynamic> json) =>
      ConteudoPresenca(
        id: json['id'],
        classId: json['classId'],
        conteudo: json['onteudo'],
        data: (json['data'] as Timestamp).toDate(),
        observacoes: json['observacoes'],
        presenca: json['presenca'],
      );

  ConteudoPresenca copyWith({
    String? id,
    String? classId,
    String? conteudo,
    DateTime? data,
    String? observacoes,
    Presenca? presenca,
  }) {
    return ConteudoPresenca(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      conteudo: this.conteudo,
      data: data ?? this.data,
      observacoes: observacoes ?? this.observacoes,
      presenca: presenca ?? this.presenca,
    );
  }
}
