enum Destinatario { todos, alunos, professores, responsaveis }

class Comunicado {
  final String id;
  final String titulo;
  final String mensagem;
  final DateTime dataPublicacao;
  final Destinatario destinatario;

  Comunicado({
    required this.id,
    required this.titulo,
    required this.mensagem,
    required this.dataPublicacao,
    required this.destinatario,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'titulo': titulo,
    'mensagem': mensagem,
    'dataPublicacao': dataPublicacao.toIso8601String(),
    'destinatario': destinatario.toString().split('.').last,
  };

  factory Comunicado.fromJson(Map<String, dynamic> json) => Comunicado(
    id: json['id'] as String? ?? '',
    titulo: json['titulo'] as String? ?? '',
    mensagem: json['mensagem'] as String? ?? '',
    dataPublicacao: DateTime.parse(json['dataPublicacao'] as String? ?? ''),
    destinatario: json['destinatario'] != null
        ? Destinatario.values.byName(json['destinatario'] as String)
        : Destinatario.todos,
  );

  Comunicado copyWith({
    String? id,
    String? titulo,
    String? mensagem,
    DateTime? dataPublicacao,
    Destinatario? destinatario,
  }) => Comunicado(
    id: id ?? this.id,
    titulo: titulo ?? this.titulo,
    mensagem: mensagem ?? this.mensagem,
    dataPublicacao: dataPublicacao ?? this.dataPublicacao,
    destinatario: destinatario ?? this.destinatario,
  );
}
