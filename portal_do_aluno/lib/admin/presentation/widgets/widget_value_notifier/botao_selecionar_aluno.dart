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
  String capitalizar(String texto) {
    return texto
        .split(' ')
        .map((palavra) {
          if (palavra.isEmpty) return palavra;
          return palavra[0].toUpperCase() + palavra.substring(1).toLowerCase();
        })
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
              return const Center(child: CircularProgressIndicator());
            }
            final docsAlunos = snapshot.data?.docs ?? [];
            if (docsAlunos.isEmpty) {
              return const Text('Nenhum aluno encontrado');
            }

            return AnimatedContainer(
              width: double.infinity,
              duration: const Duration(seconds: 1),
              curve: Curves.bounceIn,
              child: TextButton.icon(
                style: Theme.of(context).textButtonTheme.style,
                onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return ListView.builder(
                      itemCount: docsAlunos.length,
                      itemBuilder: (context, index) {
                        final aluno = docsAlunos[index];
                        final alunoNome = capitalizar(
                          aluno['dadosAluno']['nome'],
                        );
                        final alunoCpf = aluno['dadosAluno']['cpf'];

                        final alunoId = aluno['dadosAluno']['id'];
                        return ListTile(
                          title: Text(
                            alunoNome,
                            style: const TextStyle(fontSize: 18),
                          ),
                          onTap: () {
                            widget.onAlunoSelecionado.call(
                              alunoId,
                              alunoNome,
                              alunoCpf,
                            );
                            widget.alunoSelecionado.value = alunoNome;
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  },
                ),
                label: Text(
                  value ?? 'Selecione um Aluno',
                  style: const TextStyle(fontSize: 18),
                ),
                icon: const Icon(CupertinoIcons.person),
              ),
            );
          },
        );
      },
    );
  }
}
