import 'package:flutter/material.dart';
import 'package:portal_do_aluno/admin/data/datasources/cadastro_turma_service.dart';
import 'package:portal_do_aluno/admin/data/models/turma.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/text_form_fild_cadastro.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';
import 'package:portal_do_aluno/teacher/presentation/pages/class_page.dart';

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

  void _cadastroTurma() async {
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
                        CadastroTextFormField(
                          controller: _professorTitularController,
                          ico: const Icon(Icons.person),
                          labelText: 'Professor titular',
                          hintText: 'ex: Maria Silva',
                          keyboardType: TextInputType.name,
                        ),
                        const SizedBox(height: 16),
                        CadastroTextFormField(
                          controller: _turnoController,
                          ico: const Icon(Icons.timer),
                          labelText: 'Turno',
                          hintText: 'ex: Matutino',
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 16),
                        CadastroTextFormField(
                          controller: _serieController,
                          ico: const Icon(Icons.home_work_outlined),
                          labelText: 'Serie',
                          hintText: '9º Ano',
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 16),
                        CadastroTextFormField(
                          controller: _qtdAlunosController,
                          ico: const Icon(Icons.group),
                          labelText: 'Quantidade de alunos',
                          hintText: 'ex: 25',
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _cadastroTurma,
                                icon: const Icon(Icons.save),
                                label: const Text('Salvar'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    28,
                                    1,
                                    104,
                                  ),
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
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
