class Visualizacao {
  final String id;
  final String alunoId;
  final bool visualiado;

  Visualizacao({
    required this.id,
    required this.alunoId,
    required this.visualiado,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'alunoId': alunoId,
    'visualiado': visualiado,
  };

  factory Visualizacao.fromJson(Map<String, dynamic> json) =>
      Visualizacao(
        id: json ['id'] as String, 
        alunoId: json['alunoId'] as String, 
        visualiado: json  ['visualiado'] as bool,
      ) ;

  
}
