import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/data/datasources/cadastrar_diciplina_firestore.dart';
import 'package:portal_do_aluno/features/admin/data/models/diciplinas.dart';
import 'package:portal_do_aluno/features/admin/helper/form_helper.dart';
import 'package:portal_do_aluno/shared/widgets/botao_limpar.dart';
import 'package:portal_do_aluno/shared/widgets/botao_salvar.dart';
import 'package:portal_do_aluno/shared/helpers/snack_bar_helper.dart';
import 'package:portal_do_aluno/shared/widgets/text_form_field.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class CadastrarDisciplina extends StatefulWidget {
  const CadastrarDisciplina({super.key});

  @override
  State<CadastrarDisciplina> createState() => _CadastrarDisciplinaState();
}

class _CadastrarDisciplinaState extends State<CadastrarDisciplina> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _mapController = {
    'nomeDisciplina': TextEditingController(),
    'nomeProfessor': TextEditingController(),
    'aulasPrevistas': TextEditingController(),
    'cargaHoraria': TextEditingController(),
  };
  List<TextEditingController> get _allControllers =>
      _mapController.values.toList();

  final DisciplinaService cadastrarNovaDisciplina = DisciplinaService();
  void _limparCampos() {
    FormHelper.limparControllers(controllers: _allControllers);
  }

  Future<void> _cadastrarMateria() async {
    if (!FormHelper.isFormValid(
      formKey: _formKey,
      listControllers: _allControllers,
    )) {
      snackBarPersonalizado(
        context: context,
        mensagem: 'Por favor, preencha todos os campos corretamente.',
        cor: Colors.red,
      );
      return;
    }
    final disciplina = Disciplina(
      id: '',
      nome: _mapController['nomeDisciplina']!.text,
      professor: _mapController['nomeProfessor']!.text,
      cargaHoraria: int.parse(_mapController['cargaHoraria']!.text),
      aulaPrevistas: int.parse(_mapController['aulasPrevistas']!.text),
    );
    try {
      await cadastrarNovaDisciplina.cadastrarNovaDisciplina(disciplina);
      if (mounted) {
        snackBarPersonalizado(
          context: context,
          mensagem: 'Disciplina cadastrada com sucesso! 🎉',
          cor: Colors.green,
        );
        FormHelper.limparControllers(controllers: _allControllers);
      }
    } catch (e) {
      return;
    }
  }

  @override
  void dispose() {
    for (var controller in _mapController.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Cadastro de disciplinas'),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          const Text(
                            'Dados da Disciplinas',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormFieldPersonalizado(
                            controller: _mapController['nomeDisciplina']!,
                            prefixIcon: Icons.book,
                            label: 'Nome da Disciplina',
                            hintText: 'ex: Matemática',
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(height: 16),
                          TextFormFieldPersonalizado(
                            controller: _mapController['aulasPrevistas']!,
                            prefixIcon: Icons.calendar_month_outlined,

                            label: 'Quantidade de Aulas Previstas',
                            hintText: 'ex: 20 ',
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                          TextFormFieldPersonalizado(
                            controller: _mapController['cargaHoraria']!,
                            prefixIcon: Icons.lock_clock_outlined,
                            label: 'Carga Horaria',
                            hintText: 'ex: 180',
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                          TextFormFieldPersonalizado(
                            controller: _mapController['nomeProfessor']!,
                            prefixIcon: Icons.person,
                            label: 'Nome do Professor',
                            hintText: 'ex: Paulo José',
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  BotaoSalvar(
                    salvarconteudo: () async {
                      await _cadastrarMateria();
                    },
                  ),
                  const SizedBox(height: 16),

                  BotaoLimpar(
                    limparconteudo: () async {
                      _limparCampos();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
