import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/admin/data/firestore_services/frequencia_service.dart';
import 'package:portal_do_aluno/admin/data/models/frequencia.dart';
import 'package:portal_do_aluno/admin/presentation/providers/selected_provider.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/botao_salvar.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/data_picker_calendario.dart';
import 'package:portal_do_aluno/admin/helper/snack_bar_personalizado.dart';

import 'package:portal_do_aluno/admin/presentation/widgets/widget_value_notifier/botao_selecionar_turma.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';
import 'package:portal_do_aluno/teacher/presentation/providers/presenca_provider.dart';
import 'package:provider/provider.dart';

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

  final ValueNotifier<String?> turmaSelecionada = ValueNotifier<String?>(null);
  String? turmaId;
  DateTime? dataSelecionada;

  bool _isSaving = false;

  Stream<QuerySnapshot<Map<String, dynamic>>> getAlunosPorTurma(
    String turmaId,
  ) {
    return _firestore
        .collection('matriculas')
        .where('dadosAcademicos.classId', isEqualTo: turmaId)
        .snapshots();
  }

  Widget listAluno() {
    final providerRead = context.read<PresencaProvider>();

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

        return Consumer<PresencaProvider>(
          builder: (context, provider, _) {
            return ListView.builder(
              itemCount: docs.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final aluno = docs[index];
                final nome = aluno['dadosAluno']['nome'];
                final alunoId = aluno.id;
                final presencaAtual = provider.presencas[alunoId];

                Color cardColor;
                switch (presencaAtual) {
                  case Presenca.presente:
                    cardColor = Colors.green.shade100;
                    break;
                  case Presenca.falta:
                    cardColor = Colors.red.shade100;
                    break;
                  case Presenca.justificativa:
                    cardColor = Colors.yellow.shade100;
                    break;
                  default:
                    cardColor = Colors.white;
                }

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    title: Text(
                      'Aluno: $nome',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
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
                                foregroundColor: const Color.fromARGB(
                                  255,
                                  0,
                                  0,
                                  0,
                                ),// ajustar depois 
                              ),
                              onPressed: () {
                                providerRead.marcarPresenca(
                                  alunoId,
                                  Presenca.presente,
                                );
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
                                foregroundColor: const Color.fromARGB(
                                  255,
                                  0,
                                  0,
                                  0,
                                ),// ajustar depois 
                              ),
                              onPressed: () {
                                providerRead.marcarPresenca(
                                  alunoId,
                                  Presenca.falta,
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.note, size: 18),
                              label: const Text('Justificativa'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  216,
                                  213,
                                  57,
                                ),// ajustar depois 
                                foregroundColor: const Color.fromARGB(
                                  255,
                                  0,
                                  0,
                                  0,
                                ),// ajustar depois 
                              ),
                              onPressed: () {
                                providerRead.marcarPresenca(
                                  alunoId,
                                  Presenca.justificativa,
                                );
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
      },
    );
  }

  Future<void> salvarFrequencia() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    final frequenciaProvider = context.read<PresencaProvider>();
    final presencas = frequenciaProvider.presencas;

    if (dataSelecionada == null || turmaId == null) {
      snackBarPersonalizado(
        context: context,
        mensagem: 'Selecione uma turma e uma data!',
        cor: Colors.orange,
      );
      setState(() {
        _isSaving = false;
      });
      return;
    }

    final alunosSnapshot = await _firestore
        .collection('matriculas')
        .where('dadosAcademicos.classId', isEqualTo: turmaId)
        .get();
    final totalAlunos = alunosSnapshot.docs.length;

    if (presencas.keys.length != totalAlunos && mounted) {
      snackBarPersonalizado(
        context: context,
        mensagem: 'Marque a presença de todos os alunos antes de salvar!',
        cor: Colors.orange,
      );
      setState(() {
        _isSaving = false;
      });
      return;
    }

    final dataCorreta = DateTime.utc(
      dataSelecionada!.year,
      dataSelecionada!.month,
      dataSelecionada!.day,
    );

    try {
      for (var pre in presencas.entries) {
        final frequencia = Frequencia(
          id: '',
          alunoId: pre.key,
          classId: turmaId!,
          data: dataCorreta,
          presenca: pre.value,
        );

        await _frequenciaService.salvarFrequenciaPorTurma(
          alunoId: pre.key,
          turmaId: turmaId!,
          frequencia: frequencia,
        );
      }
      if (mounted) {
        snackBarPersonalizado(
          context: context,
          mensagem: 'Presenças salvas com sucesso!',
          cor: Colors.green,
        );
      }

      frequenciaProvider.limpar();
      if (mounted) {
        context.read<SelectedProvider>().limparDrop('turma');
      }
    } catch (e) {
      if (mounted) {
        snackBarPersonalizado(
          context: context,
          mensagem: 'Erro ao salvar: $e',
          cor: Colors.red,
        );
      }
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Frequência por Aluno'),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: BotaoSalvar(salvarconteudo: salvarFrequencia),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BotaoSelecionarTurma(
              turmaSelecionada: turmaSelecionada,

              onTurmaSelecionada: (id, nomeCompleto) {
                setState(() {
                  turmaId = id;
                });
                turmaSelecionada.value = nomeCompleto;
              },
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
            turmaSelecionada.value != null
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
