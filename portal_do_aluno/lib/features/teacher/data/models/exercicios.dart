import 'package:cloud_firestore/cloud_firestore.dart';

class Exercicios {
  final String id;
  final String titulo;
  final String professorId;
  final String nomeDoProfessor;
  final String turmaId;
  final String conteudoDoExercicio;
  final Timestamp dataDeEnvio;
  final Timestamp dataDeEntrega;
  final Timestamp dataDeExpiracao;

  Exercicios({
    required this.id,
    required this.titulo,
    required this.professorId,
    required this.nomeDoProfessor,
    required this.turmaId,
    required this.conteudoDoExercicio,
    required this.dataDeEnvio,
    required this.dataDeEntrega,
    required this.dataDeExpiracao,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'titulo': titulo,
    'professorId': professorId,
    'nomeDoProfessor': nomeDoProfessor,
    'turmaId': turmaId,
    'conteudoDoExercicio': conteudoDoExercicio,
    'dataDeEnvio': dataDeEnvio,
    'dataDeEntrega': dataDeEntrega,
    'dataDeExpiracao': dataDeExpiracao,
  };

  factory Exercicios.fromJson(Map<String, dynamic> json) => Exercicios(
    id: json['id'] as String,
    titulo: json['titulo'] as String,
    professorId: json['professorId'] as String,
    nomeDoProfessor: json['nomeDoProfessor'] as String,
    turmaId: json['turmaId'] as String,
    conteudoDoExercicio: json['conteudoDoExercicio'] as String,
    dataDeEnvio: json['dataDeEnvio'] as Timestamp,
    dataDeEntrega: json['dataDeEntrega'] as Timestamp,
    dataDeExpiracao: json['dataDeExpiracao'] as Timestamp,
  );

  Exercicios copyWith({
    String? id,
    String? titulo,
    String? professorId,
    String? nomeDoProfessor,
    String? turmaId,
    String? conteudoDoExercicio,
    Timestamp? dataDeEnvio,
    Timestamp? dataDeEntrega,
    Timestamp? dataDeExpiracao,
  }) {
    return Exercicios(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      professorId: professorId ?? this.professorId,
      nomeDoProfessor: nomeDoProfessor ?? this.nomeDoProfessor,
      turmaId: turmaId ?? this.turmaId,
      conteudoDoExercicio: conteudoDoExercicio ?? this.conteudoDoExercicio,
      dataDeEnvio: dataDeEnvio ?? this.dataDeEnvio,
      dataDeEntrega: dataDeEntrega ?? this.dataDeEntrega,
      dataDeExpiracao: dataDeExpiracao ?? this.dataDeExpiracao,
    );
  }
}
