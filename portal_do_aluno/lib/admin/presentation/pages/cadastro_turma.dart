import 'package:flutter/material.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/text_form_fild_cadastro.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Cadastro turma '),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Form(
                    child: Column(
                      children: [
                        CadastroTextFormField(
                          controller: _professorTitularController,
                          ico: const Icon(Icons.person),
                          labelText: 'Professor titular',
                          hintText: 'ex: Maria Silva',
                          keyboardType: TextInputType.name,
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
