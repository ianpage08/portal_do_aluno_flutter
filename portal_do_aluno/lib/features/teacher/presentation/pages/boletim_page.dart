// mexer no UI completo da pagina de boletim 
// Estou sentido que está muito poluido 




import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/helper/boletim_helper.dart';
import 'package:portal_do_aluno/shared/helpers/snack_bar_helper.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/botao_desativado.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/botao_limpar.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/botao_salvar.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/fixed_drop.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/stream_drop_generico.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/text_form_field.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/widget_value_notifier/botao_selecionar_aluno.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/widget_value_notifier/botao_selecionar_turma.dart';
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

  final BoletimHelper _boletimHelper = BoletimHelper();

  // VALUE NOTIFIERS
  final ValueNotifier<String?> turmaSelecionada = ValueNotifier<String?>(null);
  final ValueNotifier<String?> alunoSelecionado = ValueNotifier<String?>(null);

  // MAP de valores selecionados
  final Map<String, String?> selected = {
    'turmaId': null,
    'alunoId': null,
    'disciplinaId': null,
    'disciplinaNome': null,
    'unidade': null,
    'tipoAvaliacao': null,
  };

  final List<String> unidades = [
    'Unidade 1',
    'Unidade 2',
    'Unidade 3',
    'Unidade 4',
  ];
  final List<String> avaliacao = ['Teste', 'Prova', 'Trabalho', 'Nota Extra'];

  Stream<QuerySnapshot<Map<String, dynamic>>> getDisciplinas() =>
      _firestore.collection('disciplinas').snapshots();

  void limparCampos() {
    setState(() {
      selected['alunoId'] = null;
      alunoSelecionado.value = null;
      selected['disciplinaId'] = null;
      selected['disciplinaNome'] = null;
      selected['unidade'] = null;
      selected['tipoAvaliacao'] = null;
      _notaController.clear();
    });
  }

  Future<void> salvarNota() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await _boletimHelper.salvarNota(
        alunoId: selected['alunoId']!,
        turmaId: selected['turmaId']!,
        disciplinaNome: selected['disciplinaNome']!,
        disciplinaId: selected['disciplinaId']!,
        unidade: selected['unidade']!,
        tipoDeNota: selected['tipoAvaliacao']!,
        nota: double.parse(_notaController.text.replaceAll(',', '.')),
      );

      snackBarPersonalizado(
        context: context,
        mensagem: 'Nota salva com sucesso!',
        cor: Colors.green,
      );
      limparCampos();
    } catch (e) {
      snackBarPersonalizado(
        context: context,
        mensagem: 'Erro ao salvar nota!',
        cor: Colors.red,
      );
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //------------------ TURMA ------------------
                        const Text(
                          'Turma',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        BotaoSelecionarTurma(
                          turmaSelecionada: turmaSelecionada,
                          onTurmaSelecionada: (id, turmaNome) {
                            setState(() {
                              selected['turmaId'] = id;
                              limparCampos();
                            });
                          },
                        ),

                        const SizedBox(height: 16),

                        //------------------ ALUNO ------------------
                        const Text(
                          'Aluno',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        selected['turmaId'] != null
                            ? BotaoSelecionarAluno(
                                alunoSelecionado: alunoSelecionado,
                                turmaId: selected['turmaId'],
                                onAlunoSelecionado: (id, nome, cpf) {
                                  setState(() => selected['alunoId'] = id);
                                },
                              )
                            : const BotaoDesativado(
                                label: 'Selecione um Aluno',
                                icon: CupertinoIcons.person_fill,
                              ),

                        const SizedBox(height: 16),

                        //------------------ DISCIPLINA ------------------
                        const Text(
                          'Disciplina',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        StreamDropGenerico(
                          tipo: 'disciplina',
                          titulo: 'Selecione uma Disciplina',
                          stream: getDisciplinas(),
                          selecionado: selected['disciplinaNome'],
                          icon: Icons.book,
                          habilitado: selected['alunoId'] != null,
                          onSelected: (id, nome) {
                            setState(() {
                              selected['disciplinaId'] = id;
                              selected['disciplinaNome'] = nome;
                            });
                          },
                        ),

                        const SizedBox(height: 16),

                        //------------------ UNIDADE ------------------
                        const Text(
                          'Unidade',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        FixedDrop(
                          itens: unidades,
                          selecionado: selected['unidade'],
                          titulo: 'Selecione uma Unidade',
                          icon: Icons.note_alt,
                          onSelected: (valor) {
                            setState(() => selected['unidade'] = valor);
                          },
                          habilitado: selected['disciplinaId'] != null,
                        ),

                        const SizedBox(height: 16),

                        //------------------ TIPO AVALIAÇÃO ------------------
                        const Text(
                          'Tipo de Avaliação',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        FixedDrop(
                          itens: avaliacao,
                          selecionado: selected['tipoAvaliacao'],
                          titulo: 'Selecione um Tipo de Avaliação',
                          icon: Icons.assignment,
                          onSelected: (valor) {
                            setState(() => selected['tipoAvaliacao'] = valor);
                          },
                          habilitado: selected['unidade'] != null,
                        ),

                        const SizedBox(height: 16),

                        //------------------ NOTA ------------------
                        const Text(
                          'Nota',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormFieldPersonalizado(
                          controller: _notaController,
                          hintText: 'Ex: 8.5',
                          prefixIcon: CupertinoIcons.pencil,
                          keyboardType: TextInputType.number,
                          enable: selected['tipoAvaliacao'] != null,
                          validator: (value) => (value == null || value.isEmpty)
                              ? 'Digite a nota'
                              : null,
                          fillColor: selected['tipoAvaliacao'] != null
                              ? Colors.white
                              : Colors.grey[200],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                //------------------ BOTÕES ------------------
                BotaoSalvar(salvarconteudo: salvarNota),
                const SizedBox(height: 10),
                BotaoLimpar(
                  limparconteudo: () async {
                    setState(() {
                      turmaSelecionada.value = null;
                      selected['turmaId'] = null;
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
