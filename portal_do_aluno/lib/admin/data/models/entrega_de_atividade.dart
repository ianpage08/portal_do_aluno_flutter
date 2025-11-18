import 'package:cloud_firestore/cloud_firestore.dart';

class EntregaDeAtividade {
  final String alunoId;
  final String exercicioId;
  final String status;
  final Timestamp dataEntrega;
  final List<String> anexos;
  EntregaDeAtividade({
    required this.alunoId,
    required this.exercicioId,
    this.status = 'Entregue',
    required this.dataEntrega,
    required this.anexos,
  });

  Map<String, dynamic> toJson() => {
    'alunoId': alunoId,
    'exercicioId': exercicioId,
    'status': status,
    'dataEntrega': dataEntrega,
    'anexos': anexos,
  };

  factory EntregaDeAtividade.fromJson(Map<String, dynamic> json) =>
      EntregaDeAtividade(
        alunoId: json ['alunoId'] as String,
        exercicioId: json ['exercicioId'] as String,
        dataEntrega: json ['dataEntrega'] as Timestamp,
        anexos: json ['anexos'] as List<String>,
      );

}
