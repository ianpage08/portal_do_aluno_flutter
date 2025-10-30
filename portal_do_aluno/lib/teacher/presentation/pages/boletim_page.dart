import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/admin/data/firestore_services/boletim_service.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/botao_desativado.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/botao_limpar.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/botao_salvar.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/fixed_drop.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/scaffold_messeger.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/stream_drop_generico.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/text_form_field.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/widget_value_notifier/botao_selecionar_aluno.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/widget_value_notifier/botao_selecionar_turma.dart';

import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class BoletimAddNotaPage extends StatefulWidget {
  const BoletimAddNotaPage({super.key});

  @override
  State<BoletimAddNotaPage> createState() => _BoletimAddNotaPageState();
}

class _BoletimAddNotaPageState extends State<BoletimAddNotaPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _notaController = TextEditingController();

  // IDs e nomes selecionados
  String? turmaId;
  String? turmaNome;

  String? alunoId;
  final ValueNotifier<String?> alunoSelecionado = ValueNotifier<String?>(null);

  String? disciplinaId;
  String? disciplinaNome;

  String? unidadeSelecionada;
  String? tipoDeNota;

  final List<String> unidades = [
    'Unidade 1',
    'Unidade 2',
    'Unidade 3',
    'Unidade 4',
  ];

  final List<String> tiposDeAvaliacao = [
    'Teste',
    'Prova',
    'Trabalho',
    'Nota Extra',
  ];

  final ValueNotifier<String?> turmaSelecionada = ValueNotifier<String?>(null);

  Stream<QuerySnapshot<Map<String, dynamic>>> getTurmas() =>
      _firestore.collection('turmas').orderBy('serie').snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> getAlunos(String classId) =>
      _firestore
          .collection('matriculas')
          .where('dadosAcademicos.classId', isEqualTo: classId)
          .snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> getDisciplinas() =>
      _firestore.collection('disciplinas').snapshots();

  void limparCampos() {
    setState(() {
      alunoId = null;
      turmaId = null;
      disciplinaId = null;
      disciplinaNome = null;
      unidadeSelecionada = null;
      tipoDeNota = null;
      _notaController.clear();
    });
  }

  Future<void> salvarBoletim() async {
    if (!_formKey.currentState!.validate()) return;

    if (turmaId == null ||
        alunoId == null ||
        disciplinaId == null ||
        unidadeSelecionada == null ||
        tipoDeNota == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos!')),
      );
      return;
    }

    final double nota = double.tryParse(_notaController.text) ?? 0.0;
    final int unidade = int.parse(
      unidadeSelecionada!.split(' ')[1],
    ); // "Unidade 1" → 1
    final String tipo = tipoDeNota!.toLowerCase().replaceAll(
      ' ',
      '',
    ); // "Nota Extra" → "notaextra"

    final boletimService = BoletimService();

    try {
      await boletimService.salvarOuAtualizarNota(
        alunoId: alunoId!,
        matriculaId: turmaId!,
        disciplinaId: disciplinaId!,
        nomeDisciplina: disciplinaNome!,
        unidade: unidade,
        tipo: tipo,
        nota: nota,
      );
      if (mounted) {
        snackBarPersonalizado(
          context: context,
          mensagem: 'Nota salva com sucesso!',
          cor: Colors.green,
        );
      }

      _notaController.clear();
    } catch (e) {
      if (mounted) {
        snackBarPersonalizado(
          context: context,
          mensagem: 'Erro ao salvar nota.',
          cor: Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Boletim'),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        // 🔹 Turma
                        BotaoSelecionarTurma(
                          turmaSelecionada: turmaSelecionada,
                          onTurmaSelecionada: (id, turmaNome) {
                            setState(() {
                              turmaId = id;
                              limparCampos();
                            });
                            debugPrint(
                              '✅ Turma selecionada: $turmaNome (ID: $turmaId)',
                            );
                          },
                        ),

                        const SizedBox(height: 16),

                        // 🔹 Aluno
                        turmaId != null
                            ? BotaoSelecionarAluno(
                                alunoSelecionado: alunoSelecionado,
                                turmaId: turmaId,
                                onAlunoSelecionado: (id, nomeCompleto) {
                                  setState(() {
                                    alunoId = id;
                                  });
                                },
                              )
                            : const BotaoDesativado(
                                label: 'Selecione uma Aluno',
                                icon: CupertinoIcons.person_fill,
                              ),

                        const SizedBox(height: 16),

                        // 🔹 Disciplina
                        StreamDropGenerico(
                          tipo: 'disciplina',
                          titulo: 'Selecione uma Disciplina',
                          stream: getDisciplinas(),
                          selecionado: disciplinaNome,
                          icon: Icons.book,
                          onSelected: (id, nome) {
                            setState(() {
                              disciplinaId = id;
                              disciplinaNome = nome;
                            });
                          },
                          habilitado: alunoId != null,
                        ),
                        const SizedBox(height: 16),

                        // 🔹 Unidade
                        FixedDrop(
                          itens: unidades,
                          selecionado: unidadeSelecionada,
                          titulo: 'Selecione uma Unidade',
                          icon: Icons.note_alt,
                          onSelected: (valor) {
                            setState(() {
                              unidadeSelecionada = valor;
                            });
                          },
                          habilitado: disciplinaId != null,
                        ),
                        const SizedBox(height: 16),

                        // 🔹 Tipo de Avaliação
                        FixedDrop(
                          itens: tiposDeAvaliacao,
                          selecionado: tipoDeNota,
                          titulo: 'Selecione um Tipo de Avaliação',
                          icon: Icons.assignment,
                          onSelected: (valor) {
                            setState(() {
                              tipoDeNota = valor;
                            });
                          },
                          habilitado: unidadeSelecionada != null,
                        ),
                        const SizedBox(height: 16),

                        TextFormFieldPersonalizado(
                          prefixIcon: const Icon(
                            CupertinoIcons.pencil_ellipsis_rectangle,
                          ),
                          controller: _notaController,
                          label: 'Nota',
                          hintText: 'Ex: 8.5',
                          keyboardType: TextInputType.number,
                          enable: tipoDeNota != null,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Digite a nota'
                              : null,
                          fillColor: tipoDeNota != null
                              ? Colors.white
                              : Colors.grey[200],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 🔹 Botão Salvar
                BotaoSalvar(
                  salvarconteudo: () async {
                    salvarBoletim();
                  },
                ),
                const SizedBox(height: 8),
                // 🔹 Botão Limpar
                BotaoLimpar(
                  limparconteudo: () async {
                    setState(() {
                      turmaId = null;
                      limparCampos();
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
