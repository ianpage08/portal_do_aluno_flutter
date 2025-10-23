import 'package:flutter/material.dart';
import 'package:portal_do_aluno/admin/data/firestore_services/cadastro_turma_service.dart';
import 'package:portal_do_aluno/admin/data/models/turma.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/botao_salvar.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/text_form_field.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class CadastroTurma extends StatefulWidget {
  const CadastroTurma({super.key});

  @override
  State<CadastroTurma> createState() => _CadastroTurmaState();
}

class _CadastroTurmaState extends State<CadastroTurma> {
  final TextEditingController _serieController = TextEditingController();
  final TextEditingController _turnoController = TextEditingController();
  final TextEditingController _qtdAlunosController = TextEditingController();
  final TextEditingController _professorTitularController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CadastroTurmaService cadastrarNovaTurma = CadastroTurmaService();

  Future<void> _cadastroTurma() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os dados corretamente'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final novaTurma = ClasseDeAula(
      id: '',
      serie: _serieController.text,
      turno: _turnoController.text,
      qtdAlunos: int.parse(_qtdAlunosController.text),
      professorTitular: _professorTitularController.text,
    );
    try {
      await cadastrarNovaTurma.cadatrarNovaTurma(novaTurma);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Turma cadastrada com sucesso'),
            backgroundColor: Colors.green,
          ),
        );
        _limparCampos();
      }
    } catch (e) {
      return;
    }
  }

  void _limparCampos() {
    setState(() {
      _serieController.clear();
      _turnoController.clear();
      _qtdAlunosController.clear();
      _professorTitularController.clear();
    });
  }

  @override
  void dispose() {
    _serieController.dispose();
    _turnoController.dispose();
    _qtdAlunosController.dispose();
    _professorTitularController.dispose();
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
                          controller: _professorTitularController,
                          prefixIcon: const Icon(Icons.person),
                          label: 'Professor titular',
                          hintText: 'ex: Maria Silva',
                          keyboardType: TextInputType.name,
                        ),
                        const SizedBox(height: 16),
                        TextFormFieldPersonalizado(
                          controller: _turnoController,
                          prefixIcon: const Icon(Icons.timer),
                          label: 'Turno',
                          hintText: 'ex: Matutino',
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 16),
                        TextFormFieldPersonalizado(
                          controller: _serieController,
                          prefixIcon: const Icon(Icons.home_work_outlined),
                          label: 'Serie',
                          hintText: '9º Ano',
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 16),
                        TextFormFieldPersonalizado(
                          controller: _qtdAlunosController,
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
