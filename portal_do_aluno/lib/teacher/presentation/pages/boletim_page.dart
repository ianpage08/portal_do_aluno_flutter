import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/admin/helper/boletim_helper.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/botao_desativado.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/botao_limpar.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/botao_salvar.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/fixed_drop.dart';
import 'package:portal_do_aluno/admin/helper/snack_bar_personalizado.dart';
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
  final Map<String, String?> _mapSelectedValues = {
    'turmaId': null,
    'alunoId': null,
    'disciplinaId': null,
    'disciplinaNome': null,
    'unidadeSelecionada': null,
    'tipoDeNota': null,
  };

  final ValueNotifier<String?> alunoSelecionado = ValueNotifier<String?>(null);

  final BoletimHelper _boletimHelper = BoletimHelper();

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

  Stream<QuerySnapshot<Map<String, dynamic>>> getDisciplinas() =>
      _firestore.collection('disciplinas').snapshots();

  void limparCampos() {
    setState(() {
      _mapSelectedValues['alunoId'] = null;

      _mapSelectedValues['disciplinaId'] = null;
      _mapSelectedValues['disciplinaNome'] = null;
      _mapSelectedValues['unidadeSelecionada'] = null;
      _mapSelectedValues['tipoDeNota'] = null;
      _notaController.clear();
    });
  }

  Future<void> salvarNota() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      await _boletimHelper.salvarNota(
        alunoId: _mapSelectedValues['alunoId']!,
        turmaId: _mapSelectedValues['turmaId']!,
        disciplinaNome: _mapSelectedValues['disciplinaNome']!,
        disciplinaId: _mapSelectedValues['disciplinaId']!,
        unidade: _mapSelectedValues['unidadeSelecionada']!,
        tipoDeNota: _mapSelectedValues['tipoDeNota']!,
        nota: double.parse(_notaController.text),
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
                              _mapSelectedValues['turmaId'] = id;
                              limparCampos();
                            });
                            debugPrint(
                              '✅ Turma selecionada: $turmaNome (ID: ${_mapSelectedValues['turmaId']})',
                            );
                          },
                        ),

                        const SizedBox(height: 16),

                        // 🔹 Aluno
                        _mapSelectedValues['turmaId'] != null
                            ? BotaoSelecionarAluno(
                                alunoSelecionado: alunoSelecionado,
                                turmaId: _mapSelectedValues['turmaId'],
                                onAlunoSelecionado: (id, nomeCompleto, cpf) {
                                  setState(() {
                                    _mapSelectedValues['alunoId'] = id;
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
                          selecionado: _mapSelectedValues['disciplinaNome'],
                          icon: Icons.book,
                          onSelected: (id, nome) {
                            setState(() {
                              _mapSelectedValues['disciplinaId'] = id;
                              _mapSelectedValues['disciplinaNome'] = nome;
                            });
                          },
                          habilitado: _mapSelectedValues['alunoId'] != null,
                        ),
                        const SizedBox(height: 16),

                        // 🔹 Unidade
                        FixedDrop(
                          itens: unidades,
                          selecionado: _mapSelectedValues['unidadeSelecionada'],
                          titulo: 'Selecione uma Unidade',
                          icon: Icons.note_alt,
                          onSelected: (valor) {
                            setState(() {
                              _mapSelectedValues['unidadeSelecionada'] = valor;
                            });
                          },
                          habilitado:
                              _mapSelectedValues['disciplinaId'] != null,
                        ),
                        const SizedBox(height: 16),

                        // 🔹 Tipo de Avaliação
                        FixedDrop(
                          itens: tiposDeAvaliacao,
                          selecionado: _mapSelectedValues['tipoDeNota'],
                          titulo: 'Selecione um Tipo de Avaliação',
                          icon: Icons.assignment,
                          onSelected: (valor) {
                            setState(() {
                              _mapSelectedValues['tipoDeNota'] = valor;
                            });
                          },
                          habilitado:
                              _mapSelectedValues['unidadeSelecionada'] != null,
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
                          enable: _mapSelectedValues['tipoDeNota'] != null,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Digite a nota'
                              : null,
                          fillColor: _mapSelectedValues['tipoDeNota'] != null
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
                    salvarNota();
                  },
                ),
                const SizedBox(height: 8),
                // 🔹 Botão Limpar
                BotaoLimpar(
                  limparconteudo: () async {
                    setState(() {
                      _mapSelectedValues['turmaId'] = null;
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
