import 'package:flutter/material.dart';
import 'package:portal_do_aluno/admin/data/firestore_services/cadastrar_diciplina_service.dart';
import 'package:portal_do_aluno/admin/data/models/disciplinas/diciplinas.dart';
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

  void _cadastrarMateria() async {
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
                          _buildTextFormFieldCadastro(
                            _nomeDisciplinaController,
                            const Icon(Icons.book),
                            'Nome da Disciplina',
                            'ex: Matemática',
                            TextInputType.text,
                          ),
                          const SizedBox(height: 16),
                          _buildTextFormFieldCadastro(
                            _aulasPrevistasController,
                            const Icon(Icons.calendar_month_outlined),
                            'Quantidade de Aulas Previstas',
                            'ex: 20 ',
                            TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                          _buildTextFormFieldCadastro(
                            _cargaHorariaController,
                            const Icon(Icons.lock_clock_outlined),
                            'Carga Horaria',
                            'ex: 180',
                            TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                          _buildTextFormFieldCadastro(
                            _nomeProfessorController,
                            const Icon(Icons.person),
                            'Nome do Professor',
                            'ex: Paulo José',
                            TextInputType.text,
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Botão Cadastrar
                      ElevatedButton.icon(
                        onPressed: () {
                          _cadastrarMateria();
                        },
                        icon: const Icon(Icons.save, size: 24),
                        label: const Text(
                          'Cadastrar',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            28,
                            1,
                            104,
                          ),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 24,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 6,
                          shadowColor: Colors.black.withValues(alpha: 0.3),
                        ),
                      ),

                      // Botão Limpar
                      ElevatedButton.icon(
                        onPressed: () {
                          _limparCampos();
                        },
                        icon: const Icon(Icons.clear, size: 24),
                        label: const Text(
                          'Limpar',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            255,
                            114,
                            114,
                          ),
                          foregroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 24,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                          shadowColor: Colors.black.withValues(alpha: 0.3),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormFieldCadastro(
    TextEditingController controller,
    Icon ico,
    String labelText,
    String hintText,
    TextInputType? keyboardType,
  ) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            width: 2,
            color: Color.fromARGB(255, 74, 1, 92),
          ),
        ),
        hintText: hintText,
        labelText: labelText,
        prefixIcon: ico,
        filled: true,
        fillColor: const Color.fromARGB(15, 72, 1, 204),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (value == null) {
          return 'Campo obrigatório';
        }
        return null;
      },
    );
  }
}
