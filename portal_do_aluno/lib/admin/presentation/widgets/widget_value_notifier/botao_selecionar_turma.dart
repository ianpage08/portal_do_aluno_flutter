import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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
  final ValueNotifier<bool> _aberto = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.turmaSelecionada,
      builder: (context, value, _) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('turmas').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CupertinoActivityIndicator();
            }

            final turmas = snapshot.data!.docs;

            return GestureDetector(
              onTap: () async {
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
                          const Text(
                            "Selecionar Turma",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),

                          Expanded(
                            child: ListView.builder(
                              itemCount: turmas.length,
                              itemBuilder: (context, i) {
                                final turma = turmas[i];
                                final nome = turma['serie'];
                                final turno = turma['turno'];
                                final nomeCompleto = "$nome - $turno";

                                return Card(
                                  elevation: 0,
                                  color: Colors.grey.shade100,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    leading: const Icon(
                                      CupertinoIcons.person_2_fill,
                                      color: Colors.deepPurple,
                                    ),
                                    title: Text(
                                      nomeCompleto,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    onTap: () {
                                      widget.turmaSelecionada.value =
                                          nomeCompleto;
                                      widget.onTurmaSelecionada?.call(
                                        turma.id,
                                        nomeCompleto,
                                      );
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
              },
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
                            const Icon(CupertinoIcons.person_2, size: 22),
                            const SizedBox(width: 12),
                            Text(
                              value ?? "Selecionar turma",
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
                          child: const Icon(
                            CupertinoIcons.chevron_down,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
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
