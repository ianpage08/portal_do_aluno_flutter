import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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
  final ValueNotifier<bool> _aberto = ValueNotifier(false);
  String? selecionadoInterno;

  @override
  void initState() {
    super.initState();
    selecionadoInterno = widget.selecionado;
  }

  String capitalizar(String texto) {
    return texto
        .split(' ')
        .map(
          (p) =>
              p.isEmpty ? p : p[0].toUpperCase() + p.substring(1).toLowerCase(),
        )
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: widget.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CupertinoActivityIndicator();
        }

        final docs = snapshot.data!.docs;
        if (docs.isEmpty) return Text('Nenhum ${widget.tipo} encontrado');

        return GestureDetector(
          onTap: widget.habilitado
              ? () async {
                  _aberto.value = true;

                  await showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(18),
                      ),
                    ),
                    builder: (_) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Selecionar ${capitalizar(widget.tipo)}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),

                            Expanded(
                              child: ListView.builder(
                                itemCount: docs.length,
                                itemBuilder: (context, i) {
                                  final doc = docs[i];
                                  final data = doc.data();
                                  String nome;
                                  String id = doc.id;

                                  // Definindo nome conforme o tipo
                                  switch (widget.tipo) {
                                    case 'turma':
                                      nome =
                                          "${data['serie']} - ${data['turno']}";
                                      break;

                                    case 'aluno':
                                      if (widget.camposNome != null) {
                                        final c1 =
                                            widget.camposNome!.keys.first;
                                        final c2 =
                                            widget.camposNome!.values.first;
                                        nome =
                                            data[c1]?[c2] ?? "Aluno sem nome";
                                        nome = capitalizar(nome);
                                      } else {
                                        nome = data['nome'] ?? 'Aluno sem nome';
                                      }
                                      break;

                                    case 'disciplina':
                                      nome =
                                          data['nome'] ??
                                          data['titulo'] ??
                                          "Sem nome";
                                      break;

                                    default:
                                      nome = "Sem nome";
                                  }

                                  return Card(
                                    elevation: 0,
                                    color: Colors.grey.shade100,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ListTile(
                                      leading: Icon(
                                        widget.icon ??
                                            CupertinoIcons.list_bullet,
                                        color: Colors.deepPurple,
                                      ),
                                      title: Text(
                                        nome,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      onTap: () {
                                        setState(
                                          () => selecionadoInterno = nome,
                                        );
                                        widget.onSelected(id, nome);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );

                  _aberto.value = false;
                }
              : null,
          child: ValueListenableBuilder(
            valueListenable: _aberto,
            builder: (context, aberto, _) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color.fromARGB(31, 158, 158, 158),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(26, 0, 0, 0),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          widget.icon ?? CupertinoIcons.square_list,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          selecionadoInterno ?? widget.titulo,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    AnimatedRotation(
                      turns: aberto ? 0.5 : 0,
                      duration: const Duration(milliseconds: 250),
                      child: const Icon(CupertinoIcons.chevron_down, size: 20),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
