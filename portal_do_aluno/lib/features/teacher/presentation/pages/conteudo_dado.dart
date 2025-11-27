import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:portal_do_aluno/features/teacher/data/datasources/conteudo_service.dart';
import 'package:portal_do_aluno/features/teacher/data/models/conteudo_presenca.dart';
import 'package:portal_do_aluno/features/admin/presentation/providers/selected_provider.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/botao_salvar.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/data_picker_calendario.dart';
import 'package:portal_do_aluno/shared/helpers/snack_bar_helper.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/stream_drop.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/text_form_field.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/widget_value_notifier/botao_selecionar_turma.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';
import 'package:provider/provider.dart';

class OqueFoiDado extends StatefulWidget {
  const OqueFoiDado({super.key});

  @override
  State<OqueFoiDado> createState() => _OqueFoiDadoState();
}

class _OqueFoiDadoState extends State<OqueFoiDado> {
  final TextEditingController _conteudoMinistradoController =
      TextEditingController();
  final TextEditingController _observacoesController = TextEditingController();
  String? turmaId;
  final ValueNotifier<String?> turmaSelecionada = ValueNotifier<String?>(null);
  DateTime? dataSelecionada;
  String? disciplinaId;
  bool isLoading = false;

  final ConteudoPresencaService _conteudoPresencaService =
      ConteudoPresencaService();

  Stream<QuerySnapshot<Map<String, dynamic>>> getTurma() {
    return FirebaseFirestore.instance.collection('turmas').snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getDisciplinas() {
    return FirebaseFirestore.instance.collection('disciplinas').snapshots();
  }

  Future<void> salvarconteudo() async {
    if (turmaId == null ||
        disciplinaId == null ||
        dataSelecionada == null ||
        _conteudoMinistradoController.text.isEmpty) {
      snackBarPersonalizado(
        context: context,
        mensagem: 'Preencha todos os campos',
        cor: Colors.redAccent,
      );
      return;
    }

    final novoVinculo = ConteudoPresenca(
      id: '',
      classId: turmaId!,
      conteudo: _conteudoMinistradoController.text,
      data: dataSelecionada!,
      observacoes: _observacoesController.text,
    );

    try {
      await _conteudoPresencaService.cadastrarPresencaConteudoProfessor(
        conteudoPresenca: novoVinculo,
        turmaId: turmaId!,
      );
      if (mounted) {
        snackBarPersonalizado(
          context: context,
          mensagem: 'Conteúdo ministrado salvo com sucesso!',
          cor: Colors.green,
        );
      }

      // Limpar campos
      _conteudoMinistradoController.clear();
      _observacoesController.clear();

      // Limpar seleções do provider
      if (mounted) {
        context.read<SelectedProvider>().limparDrop('disciplina');
      }
    } catch (e) {
      if (mounted) {
        snackBarPersonalizado(
          context: context,
          mensagem: 'Erro ao salvar o conteúdo: $e',
          cor: Colors.redAccent,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Conteúdo dado'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      // ✅ Apenas um dropdown de turma
                      BotaoSelecionarTurma(
                        turmaSelecionada: turmaSelecionada,

                        onTurmaSelecionada: (id, turmaNome) {
                          turmaId = id;
                          debugPrint(
                            '✅ Turma selecionada: $turmaNome (ID: $turmaId)',
                          );
                        },
                      ),

                      const SizedBox(height: 20),
                      StreamDrop(
                        dropId: 'disciplina',
                        minhaStream: getDisciplinas(),
                        mensagemError: 'Nenhuma Disciplina Encontrada',
                        textLabel: 'Selecione uma Disciplina',
                        nomeCampo: 'nome',
                        icon: const Icon(Icons.note),
                        onSelected: (id, nome) {
                          setState(() {
                            disciplinaId = id;
                          });
                          debugPrint(
                            '✅ Disciplina selecionada: $nome (ID: $id)',
                          );
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
                      Form(
                        child: Column(
                          children: [
                            TextFormFieldPersonalizado(
                              prefixIcon: CupertinoIcons.book,
                              maxLines: 5,
                              controller: _conteudoMinistradoController,
                              label: 'Conteúdo Ministrado em Aula',
                              hintText:
                                  'Ex: "Revisão de equações do 1º grau e introdução a inequações"',
                            ),

                            const SizedBox(height: 20),
                            TextFormFieldPersonalizado(
                              prefixIcon: 
                                CupertinoIcons.doc_on_clipboard,
                              
                              controller: _observacoesController,
                              label: 'Observações',
                              hintText:
                                  'Ex: 1- O que ficou pendente pra próxima aula. 2- Materiais que precisam ser preparados',
                              maxLines: 2,
                            ),
                            const SizedBox(height: 20),
                            BotaoSalvar(
                              salvarconteudo: () async {
                                await salvarconteudo();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
