import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BotaoSelecionarAluno extends StatefulWidget {
  final ValueNotifier<String?> alunoSelecionado;
  final String? turmaId;
  final void Function(String id, String nomeCompleto, String cpf)
  onAlunoSelecionado;

  const BotaoSelecionarAluno({
    super.key,
    required this.alunoSelecionado,
    required this.onAlunoSelecionado,
    this.turmaId,
  });

  @override
  State<BotaoSelecionarAluno> createState() => _BotaoSelecionarAlunoState();
}

class _BotaoSelecionarAlunoState extends State<BotaoSelecionarAluno> {
  final ValueNotifier<bool> _aberto = ValueNotifier(false);

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
    return ValueListenableBuilder(
      valueListenable: widget.alunoSelecionado,
      builder: (context, value, child) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('matriculas')
              .where('dadosAcademicos.classId', isEqualTo: widget.turmaId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CupertinoActivityIndicator();
            }

            final alunos = snapshot.data?.docs ?? [];
            if (alunos.isEmpty) {
              return const Text("Nenhum aluno encontrado");
            }

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
                            "Selecionar Aluno",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),

                          Expanded(
                            child: ListView.builder(
                              itemCount: alunos.length,
                              itemBuilder: (context, i) {
                                final aluno = alunos[i];
                                final nome = capitalizar(
                                  aluno['dadosAluno']['nome'],
                                );
                                final cpf = aluno['dadosAluno']['cpf'];
                                final alunoId = aluno['dadosAluno']['id'];

                                return Card(
                                  elevation: 0,
                                  color: Colors.grey.shade100,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    leading: const Icon(
                                      CupertinoIcons.person_fill,
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
                                      widget.onAlunoSelecionado.call(
                                        alunoId,
                                        nome,
                                        cpf,
                                      );
                                      widget.alunoSelecionado.value = nome;
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
                              value ?? "Selecione um aluno",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
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
