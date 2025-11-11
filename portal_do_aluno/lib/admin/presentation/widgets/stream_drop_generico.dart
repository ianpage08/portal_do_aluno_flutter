import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StreamDropGenerico extends StatefulWidget {
  final String tipo;
  final String titulo;
  final Stream<QuerySnapshot<Map<String, dynamic>>> stream;
  final String? selecionado;
  final void Function(String id, String nome) onSelected;
  final IconData? icon;
  final Map<String, String>? camposNome;
  final bool habilitado;

  const StreamDropGenerico({
    super.key,
    required this.tipo,
    required this.titulo,
    required this.stream,
    required this.selecionado,
    required this.onSelected,
    this.icon,
    this.camposNome,
    this.habilitado = true,
  });

  @override
  State<StreamDropGenerico> createState() => _StreamDropGenericoState();
}

class _StreamDropGenericoState extends State<StreamDropGenerico> {
  String? selecionadoInterno;

  @override
  void initState() {
    super.initState();
    selecionadoInterno = widget.selecionado;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: widget.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;
        if (docs.isEmpty) return Text('Nenhum ${widget.tipo} encontrado');

        return SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            icon: Icon(
              widget.icon ?? Icons.arrow_drop_down,
              color: widget.habilitado ? Colors.white : Colors.grey[600],
            ),
            label: Text(
              selecionadoInterno ?? widget.titulo,
              style: TextStyle(
                fontSize: 16,
                color: widget.habilitado ? Colors.white : Colors.grey[600],
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: widget.habilitado
                  ? Theme.of(context).primaryColor
                  : Colors.grey[300],
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: widget.habilitado
                ? () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => ListView(
                        children: docs.map((doc) {
                          final data = doc.data();
                          String nome;
                          String id = doc.id;

                          switch (widget.tipo) {
                            case 'turma':
                              nome =
                                  '${data['serie'] ?? 'Turma sem série'} - ${data['turno'] ?? ''}';
                              if (data.containsKey('classId')) {
                                id = data['classId'];
                              }
                              break;
                            case 'aluno':
                              if (widget.camposNome != null &&
                                  widget.camposNome!.isNotEmpty) {
                                final nivel1 = widget.camposNome!.keys.first;
                                final nivel2 = widget.camposNome!.values.first;
                                nome =
                                    (data[nivel1]?[nivel2] ?? 'Aluno sem nome')
                                        .toString();
                              } else {
                                nome = data['nome'] ?? 'Aluno sem nome';
                              }
                              break;
                            case 'disciplina':
                              nome =
                                  data['nome'] ??
                                  data['titulo'] ??
                                  'Disciplina sem nome';
                              break;
                            default:
                              nome = 'Sem nome';
                          }

                          return ListTile(
                            title: Text(nome),
                            onTap: () {
                              setState(() {
                                selecionadoInterno = nome;
                              });
                              widget.onSelected(id, nome);
                              Navigator.pop(context);
                            },
                          );
                        }).toList(),
                      ),
                    );
                  }
                : null,
          ),
        );
      },
    );
  }
}
