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
  final ValueNotifier<bool> _aberto = ValueNotifier<bool>(false);

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
              child: TextButton(
                style: Theme.of(context).textButtonTheme.style,

                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Text(
                            value ?? 'Selecione uma turma',
                            style: const TextStyle(fontSize: 18),
                            overflow: TextOverflow.ellipsis,
                          ),
                          ValueListenableBuilder(
                            valueListenable: _aberto,
                            builder: (context, aberto, child) {
                              return AnimatedRotation(
                                curve: Curves.easeInOut,
                                turns: aberto ? 0.25 : 0,
                                duration: const Duration(milliseconds: 300),
                                child: const Icon(CupertinoIcons.chevron_right),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                onPressed: () async {
                  _aberto.value = true;
                  await showModalBottomSheet(
                    context: context,

                    backgroundColor: const Color.fromARGB(238, 46, 46, 46),
                    builder: (context) {
                      return ListView.builder(
                        itemCount: docTurmas.length,
                        itemBuilder: (context, index) {
                          final turma = docTurmas[index];
                          final nome = turma['serie'] as String;
                          final turno = turma['turno'] as String;
                          final nomeCompleto = '$nome - $turno';
                          final nomeFormatado = nomeCompleto
                              .split(' ')
                              .map((palavra) {
                                if (palavra.isEmpty) return palavra;
                                return palavra[0].toUpperCase() +
                                    palavra.substring(1);
                              })
                              .join(' ');
                          return ListTile(
                            title: Text(nomeFormatado),
                            onTap: () {
                              widget.turmaSelecionada.value = nomeCompleto;
                              widget.onTurmaSelecionada?.call(
                                turma.id,
                                nomeCompleto,
                              );
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    },
                  );
                  _aberto.value = false;
                },
              ),
            );
          },
        );
      },
    );
  }
}
