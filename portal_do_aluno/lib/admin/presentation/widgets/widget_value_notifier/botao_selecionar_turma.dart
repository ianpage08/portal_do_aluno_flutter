import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BotaoSelecionarTurma extends StatefulWidget {
  final ValueNotifier<String?> turmaSelecionada;
  final void Function(String id, String turmaNome)? onTurmaSelecionada;
  const BotaoSelecionarTurma({
    super.key,
    required this.turmaSelecionada,
    required this.onTurmaSelecionada,
  });

  @override
  State<BotaoSelecionarTurma> createState() => _BotaoSelecionarTurmaState();
}

class _BotaoSelecionarTurmaState extends State<BotaoSelecionarTurma> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.turmaSelecionada,
      builder: (context, value, child) {
        return StreamBuilder(
          stream: FirebaseFirestore.instance.collection('turmas').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final docTurmas = snapshot.data!.docs;

            if (docTurmas.isEmpty) {
              return const Text('Nenhuma turma encontrada');
            }

            return AnimatedContainer(
              width: double.infinity,
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 300),
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                label: Text(
                  value ?? 'Selecione Uma Turma',
                  style: const TextStyle(fontSize: 16),
                ),
                icon: const Icon(Icons.class_),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return DraggableScrollableSheet(
                        initialChildSize: 0.6,
                        maxChildSize: 0.9,
                        minChildSize: 0.4,
                        builder: (_, controller) {
                          return Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            child: ListView.builder(
                              controller: controller,
                              itemCount: docTurmas.length,
                              itemBuilder: (context, index) {
                                final turma = docTurmas[index];
                                final nome = turma['serie'] as String;
                                final turno = turma['turno'] as String;
                                final nomeCompleto = '$nome - $turno';
                                return ListTile(
                                  title: Text(nomeCompleto.toUpperCase()),
                                  onTap: () {
                                    widget.turmaSelecionada.value =
                                        nomeCompleto;
                                    widget.onTurmaSelecionada?.call(
                                      turma.id,
                                      nomeCompleto,
                                    );
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
