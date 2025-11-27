import 'package:cloud_firestore/cloud_firestore.dart';

class Calendario {
  final String id;
  final String titulo;
  final String? descricao;
  final DateTime data;
  

  Calendario({
    required this.id,
    required this.titulo,
    this.descricao,
    required this.data,
    
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'titulo': titulo,
    'descricao': descricao,
    'data': data,
    
  };

  factory Calendario.fromJson(Map<String, dynamic> json) => Calendario(
    id: json['id'] as String,
    titulo: json['titulo'] as String,
    descricao: json[' descricao'] as String,
    data: (json['data'] as Timestamp).toDate(),
    
  );

  Calendario copyWith({
    String? id,
    String? titulo,
    String? descricao,
    DateTime? data,
    
  }) {
    return Calendario(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      data: data ?? this.data,
      
    );
  }
}
