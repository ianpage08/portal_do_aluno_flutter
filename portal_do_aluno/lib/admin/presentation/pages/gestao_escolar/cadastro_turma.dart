import 'package:flutter/material.dart';
import 'package:portal_do_aluno/admin/data/firestore_services/cadastro_turma_service.dart';
import 'package:portal_do_aluno/admin/data/models/turma.dart';
import 'package:portal_do_aluno/admin/helper/form_helper.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/botao_salvar.dart';
import 'package:portal_do_aluno/admin/helper/snack_bar_personalizado.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/text_form_field.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class CadastroTurma extends StatefulWidget {
  const CadastroTurma({super.key});

  @override
  State<CadastroTurma> createState() => _CadastroTurmaState();
}

class _CadastroTurmaState extends State<CadastroTurma> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CadastroTurmaService cadastrarNovaTurma = CadastroTurmaService();
  final Map<String, TextEditingController> _mapController = {
    'serie': TextEditingController(),
    'turno': TextEditingController(),
    'qtdAlunos': TextEditingController(),
    'professorTitular': TextEditingController(),
  };
  List<TextEditingController> get _allControllers =>
      _mapController.values.toList();

  Future<void> _cadastroTurma() async {
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

    final novaTurma = ClasseDeAula(
      id: '',
      serie: _mapController['serie']!.text,
      turno: _mapController['turno']!.text,
      qtdAlunos: int.parse(_mapController['qtdAlunos']!.text),
      professorTitular: _mapController['professorTitular']!.text,
    );
    try {
      await cadastrarNovaTurma.cadatrarNovaTurma(novaTurma);
      if (mounted) {
        snackBarPersonalizado(
          context: context,
          mensagem: 'Turma cadastrada com sucesso! 🎉',
          cor: Colors.green,
        );
        FormHelper.limparControllers(controllers: _allControllers);
      }
    } catch (e) {
      if (mounted) {
        snackBarPersonalizado(
          context: context,
          mensagem: 'Erro ao cadastrar turma. Tente novamente.',
          cor: Colors.red,
        );
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _allControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Cadastro turma '),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              const Text(
                'Dados da turma',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormFieldPersonalizado(
                          controller: _mapController['professorTitular']!,
                          prefixIcon: const Icon(Icons.person),
                          label: 'Professor titular',
                          hintText: 'ex: Maria Silva',
                          keyboardType: TextInputType.name,
                        ),
                        const SizedBox(height: 16),
                        TextFormFieldPersonalizado(
                          controller: _mapController['turno']!,
                          prefixIcon: const Icon(Icons.timer),
                          label: 'Turno',
                          hintText: 'ex: Matutino',
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 16),
                        TextFormFieldPersonalizado(
                          controller: _mapController['serie']!,
                          prefixIcon: const Icon(Icons.home_work_outlined),
                          label: 'Serie',
                          hintText: '9º Ano',
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 16),
                        TextFormFieldPersonalizado(
                          controller: _mapController['qtdAlunos']!,
                          prefixIcon: const Icon(Icons.group),
                          label: 'Quantidade de alunos',
                          hintText: 'ex: 25',
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        BotaoSalvar(
                          salvarconteudo: () async {
                            await _cadastroTurma();
                          },
                        ),
                      ],
                    ),
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
