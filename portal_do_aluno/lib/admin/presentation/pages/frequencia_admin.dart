import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/admin/data/firestore_services/frequencia_service.dart';
import 'package:portal_do_aluno/admin/data/models/frequencia.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class FrequenciaAdmin extends StatefulWidget {
  const FrequenciaAdmin({super.key});

  @override
  State<FrequenciaAdmin> createState() => _FrequenciaAdminState();
}

class _FrequenciaAdminState extends State<FrequenciaAdmin> {
  final FrequenciaService _frequenciaService = FrequenciaService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final minhaStream = FirebaseFirestore.instance
      .collection('turmas')
      .snapshots();

  String? turmaSelcionada;
  String? turmaId;
  DateTime? dataSelecionada;

  Map<String, dynamic> presencasSelecionadas = {};

  Stream<QuerySnapshot<Map<String, dynamic>>> getAlunosPorTurma(
    String turmaId,
  ) {
    return _firestore
        .collection('matriculas')
        .where('dadosAcademicos.classId', isEqualTo: turmaId)
        .snapshots();
  }

  Widget streamDrop() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: minhaStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Nenhuma turma encontrada'));
        }

        final docs = snapshot.data!.docs;

        return SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            icon: const Icon(Icons.school),
            label: Text(
              turmaSelcionada ?? 'Selecione uma turma',
              style: const TextStyle(fontSize: 20),
            ),
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF5921F3),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return ListView(
                    children: docs.map((item) {
                      return ListTile(
                        title: Text(item['serie']),
                        onTap: () {
                          setState(() {
                            turmaSelcionada = item['serie'];
                            turmaId = item.id;
                            presencasSelecionadas.clear();
                          });
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget buildSelecionardia() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5921F3),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () async {
          final DateTime? data = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2025),
            lastDate: DateTime(2050),
          );
          if (data != null) {
            setState(() {
              dataSelecionada = data;
            });
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calendar_today),
            const SizedBox(width: 10),
            Text(
              dataSelecionada == null
                  ? 'Selecionar Data'
                  : ' ${dataSelecionada!.day}/${dataSelecionada!.month}/${dataSelecionada!.year}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget listAluno() {
    if (turmaId == null) return const SizedBox();

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: getAlunosPorTurma(turmaId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Nenhum aluno encontrado'));
        }

        final docs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: docs.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final aluno = docs[index];
            final nome = aluno['dadosAluno']['nome'];
            final alunoId = aluno.id;
            final presencaAtual = presencasSelecionadas[alunoId];

            Color cardColor;
            if (presencaAtual == Presenca.presente) {
              cardColor = Colors.green.shade100;
            } else if (presencaAtual == Presenca.falta) {
              cardColor = Colors.red.shade100;
            } else if (presencaAtual == Presenca.justificativa) {
              cardColor = Colors.yellow.shade100;
            } else {
              cardColor = Colors.white;
            }

            return Card(
              elevation: 4,
              color: cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  'Aluno: $nome',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Wrap(
                    spacing: 8,
                    children: [
                      SizedBox(
                        width: (MediaQuery.of(context).size.width / 2) - 45,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.check, size: 18),
                          label: const Text('Presente'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              presencasSelecionadas[alunoId] =
                                  Presenca.presente;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width / 2) - 45,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.block, size: 18),
                          label: const Text('Falta'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              presencasSelecionadas[alunoId] = Presenca.falta;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.note, size: 18),
                          label: const Text('Justificativa'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              presencasSelecionadas[alunoId] =
                                  Presenca.justificativa;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget salvarPresenca() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.save),
        label: const Text('Salvar Presenças', style: TextStyle(fontSize: 18)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5921F3),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed:
            presencasSelecionadas.isEmpty ||
                turmaId == null ||
                dataSelecionada == null
            ? null
            : () async {
                //  Buscar todos os alunos da turma
                final alunosSnapshot = await _firestore
                    .collection('matriculas')
                    .where('dadosAcademicos.classId', isEqualTo: turmaId)
                    .get();
                final totalAlunos = alunosSnapshot.docs.length;

                //  Verificar se todos os alunos foram marcados
                if (presencasSelecionadas.keys.length != totalAlunos) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Marque a presença de todos os alunos antes de salvar!',
                      ),
                      backgroundColor: Colors.orange,
                      duration: Duration(seconds: 3),
                    ),
                  );
                  return;
                }

                //  Salvar cada frequência
                for (var pre in presencasSelecionadas.entries) {
                  final frequencia = Frequencia(
                    id: '',
                    alunoId: pre.key,
                    classId: turmaId!,
                    data: dataSelecionada!,
                    presenca: pre.value,
                  );

                  try {
                    await _frequenciaService.salvarFrequenciaPorTurma(
                      alunoId: pre.key,
                      turmaId: turmaId!,
                      frequencia: frequencia,
                    );
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Algumas presenças já foram registradas neste dia.',
                        ),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 3),
                      ),
                    );
                    return;
                  }
                }

                //  Sucesso
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Presenças salvas com sucesso!'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );

                setState(() {
                  presencasSelecionadas.clear();
                  dataSelecionada = null;
                  turmaSelcionada = null;
                });
              },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Frequência por Aluno'),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: salvarPresenca(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            streamDrop(),
            const SizedBox(height: 20),
            buildSelecionardia(),
            const SizedBox(height: 20),
            turmaSelcionada != null
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: listAluno(),
                  )
                : const Text('Selecione uma turma para ver os alunos'),
          ],
        ),
      ),
    );
  }
}
