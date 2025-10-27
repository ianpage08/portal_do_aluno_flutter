import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/admin/data/firestore_services/frequencia_service.dart';
import 'package:portal_do_aluno/admin/data/models/frequencia.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/botao_salvar.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/data_picker_calendario.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/scaffold_messeger.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/stream_drop.dart';
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

  Future<void> salvarFrequencia() async {
    final alunosSnapshot = await _firestore
        .collection('matriculas')
        .where('dadosAcademicos.classId', isEqualTo: turmaId)
        .get();
    final totalAlunos = alunosSnapshot.docs.length;
    final dataCorreta = DateTime.utc(
      dataSelecionada!.year,
      dataSelecionada!.month,
      dataSelecionada!.day,
    );

    //)

    //  Verificar se todos os alunos foram marcados
    if (presencasSelecionadas.keys.length != totalAlunos) {
      if (mounted) {
        snackBarPersonalizado(
          context: context,
          mensagem: 'Marque a presença de todos os alunos antes de salvar!',
          cor: Colors.orange,
        );
      }

      return;
    }

    //  Salvar cada frequência
    for (var pre in presencasSelecionadas.entries) {
      final frequencia = Frequencia(
        id: '',
        alunoId: pre.key,
        classId: turmaId!,
        data: DateTime.now(),
        presenca: pre.value,
      );

      try {
        await _frequenciaService.salvarFrequenciaPorTurma(
          alunoId: pre.key,
          turmaId: turmaId!,
          frequencia: frequencia,
        );
      } catch (e) {
        if (mounted) {
          snackBarPersonalizado(
            context: context,
            mensagem: '$e',
            cor: Colors.red,
          );
        }

        return;
      }
    }

    //  Sucesso
    if (mounted) {
      snackBarPersonalizado(
        context: context,
        mensagem: 'Presenças salvas com sucesso!',
        cor: Colors.green,
      );
    }

    setState(() {
      presencasSelecionadas.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Frequência por Aluno'),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: BotaoSalvar(
          salvarconteudo: () async {
            await salvarFrequencia();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            StreamDrop(
              minhaStream: minhaStream,
              onSelected: (id, nome) {
                setState(() {
                  turmaSelcionada = nome;
                  turmaId = id;
                });
              },
              mensagemError: 'Nenhuma Turma Encontrada',
              textLabel: 'Selecione uma turma',
              nomeItem: 'serie',
              icon: const Icon(Icons.school),
            ),

            const SizedBox(height: 20),
            DataPickerCalendario(
              onDate: (data) {
                setState(() {
                  dataSelecionada = data;
                });
              },
            ),
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
