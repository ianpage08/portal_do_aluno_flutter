import 'package:cloud_firestore/cloud_firestore.dart';

enum Presenca { presente, falta, justificativa }

class Frequencia {
  final String id;
  final String alunoId;
  final String classId;

  final DateTime data;
  final Presenca presenca;

  Frequencia({
    required this.id,
    required this.alunoId,
    required this.classId,
    required this.data,
    required this.presenca,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'alunoId': alunoId,
    'classId': classId,
    'data': data,
    'presenca': presenca.name,
  };
  factory Frequencia.fromJson(Map<String, dynamic> json) => Frequencia(
    id: json['id'] as String,
    alunoId: json['alunoId'] as String,
    classId: json['classId'] as String,
    data: (json['data'] as Timestamp).toDate(),

    presenca: json['presenca'] != null
        ? Presenca.values.byName(json['presenca'] as String)
        : Presenca.falta,
  );

  Frequencia copyWith(
    {String? id,
    String? alunoId,
    String? classId,
    DateTime? data,
    Presenca? presenca,}
  ) {
    return Frequencia(
      id: id ?? this.id,
      alunoId: alunoId ?? this.alunoId,
      classId: classId ?? this.classId,
      data: data ?? this.data,
      presenca: presenca ?? this.presenca,
    );
  }
}
