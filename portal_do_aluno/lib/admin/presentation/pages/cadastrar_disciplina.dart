import 'package:flutter/material.dart';
import 'package:portal_do_aluno/admin/data/firestore_services/cadastrar_diciplina_service.dart';
import 'package:portal_do_aluno/admin/data/models/disciplinas/diciplinas.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/botao_limpar.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/botao_salvar.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/text_form_field.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class CadastrarDisciplina extends StatefulWidget {
  const CadastrarDisciplina({super.key});

  @override
  State<CadastrarDisciplina> createState() => _CadastrarDisciplinaState();
}

class _CadastrarDisciplinaState extends State<CadastrarDisciplina> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeDisciplinaController =
      TextEditingController();
  final TextEditingController _nomeProfessorController =
      TextEditingController();
  final TextEditingController _aulasPrevistasController =
      TextEditingController();
  final TextEditingController _cargaHorariaController = TextEditingController();
  final DisciplinaService cadastrarNovaDisciplina = DisciplinaService();

  Future<void> _cadastrarMateria() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os dados Corretamente'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final disciplina = Disciplina(
      id: '',
      nome: _nomeDisciplinaController.text,
      professor: _nomeProfessorController.text,
      cargaHoraria: int.parse(_cargaHorariaController.text),
      aulaPrevistas: int.parse(_aulasPrevistasController.text),
    );
    try {
      await cadastrarNovaDisciplina.cadastrarNovaDisciplina(disciplina);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Disciplina cadastrada com sucesso'),
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
      _nomeDisciplinaController.clear();
      _nomeProfessorController.clear();
      _aulasPrevistasController.clear();
      _cargaHorariaController.clear();
    });
  }

  @override
  void dispose() {
    _nomeDisciplinaController.dispose();
    _nomeProfessorController.dispose();
    _aulasPrevistasController.dispose();
    _cargaHorariaController.dispose();
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
                            controller: _nomeDisciplinaController,
                            prefixIcon: const Icon(Icons.book),
                            label: 'Nome da Disciplina',
                            hintText: 'ex: Matemática',
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(height: 16),
                          TextFormFieldPersonalizado(
                            controller: _aulasPrevistasController,
                            prefixIcon: const Icon(
                              Icons.calendar_month_outlined,
                            ),
                            label: 'Quantidade de Aulas Previstas',
                            hintText: 'ex: 20 ',
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                          TextFormFieldPersonalizado(
                            controller: _cargaHorariaController,
                            prefixIcon: const Icon(Icons.lock_clock_outlined),
                            label: 'Carga Horaria',
                            hintText: 'ex: 180',
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                          TextFormFieldPersonalizado(
                            controller: _nomeProfessorController,
                            prefixIcon: const Icon(Icons.person),
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
