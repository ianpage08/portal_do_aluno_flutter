import 'package:flutter/material.dart';
import 'package:portal_do_aluno/admin/data/datasources/matricula_service.dart';
import 'package:portal_do_aluno/admin/data/models/aluno.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class MatriculaCadastro extends StatefulWidget {
  const MatriculaCadastro({super.key});

  @override
  State<MatriculaCadastro> createState() => _MatriculaCadastroState();
}

class _MatriculaCadastroState extends State<MatriculaCadastro> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final MatriculaService _matriculaService = MatriculaService();

  void _cadastrarAluno() async {
    if (_formKey.currentState!.validate() ||
        _dataNascimentoController == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos corretamente')),
      );
      return;
    }
    final DadosAluno dadosAluno = DadosAluno(
      id: '',
      nome: _nomeController.text,
      cpf: _cpfController.text,
      sexo: _sexoController.text,
      naturalidade: _naturalidadeController.text,
      dataNascimento: _dataNascimentoController!,
    );
    final EnderecoAluno enderecoAluno = EnderecoAluno(
      cep: _cepController.text,
      rua: _ruaController.text,
      numero: _numeroController.text,
      bairro: _bairroController.text,
      cidade: _cidadeController.text,
      estado: _estadoController.text,
    );
    final ResponsaveisAluno responsaveisAluno = ResponsaveisAluno(
      nomeMae: _nomeMaeController.text,
      cpfMae: _cpfMaeController.text,
      telefoneMae: _telefoneMaeController.text,
      nomePai: _nomePaiController.text,
      cpfPai: _cpfPaiController.text,
      telefonePai: _telefonePaiController.text,
    );
    final DadosAcademicos dadosAcademicos = DadosAcademicos(
      numeroMatricula: _numeroMatriculaController.text,
      turma: _tumarControler.text,
      anoLetivo: _anoLetivoController.text,
      turno: _turnoController.text,
      situacao: _situacaoController.text,
      dataMatricula: DateTime.now(),
    );
    final InformacoesMedicasAluno informacoesMedicasAluno =
        InformacoesMedicasAluno(
          alergia: _alergiasController.text,
          medicacao: _medicamentosController.text,
          observacoes: _observacoesController.text,
        );
  }

  // Controller para aluno
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _naturalidadeController = TextEditingController();
  final TextEditingController _sexoController = TextEditingController();
  DateTime? _dataNascimentoController;

  // Controller para endereço
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();

  // Controller para responsáveis
  final TextEditingController _nomeMaeController = TextEditingController();
  final TextEditingController _cpfMaeController = TextEditingController();
  final TextEditingController _telefoneMaeController = TextEditingController();
  final TextEditingController _nomePaiController = TextEditingController();
  final TextEditingController _cpfPaiController = TextEditingController();
  final TextEditingController _telefonePaiController = TextEditingController();

  // Controller para dados acadêmicos
  final TextEditingController _numeroMatriculaController =
      TextEditingController();
  final TextEditingController _tumarControler = TextEditingController();
  final TextEditingController _anoLetivoController = TextEditingController();
  final TextEditingController _turnoController = TextEditingController();
  final TextEditingController _situacaoController = TextEditingController();

  // Controller para informações médicas
  final TextEditingController _alergiasController = TextEditingController();
  final TextEditingController _medicamentosController = TextEditingController();
  final TextEditingController _observacoesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Cadastro de Matrícula'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              const Text('Formulário de Cadastro de Matrícula'),
              const SizedBox(height: 12),
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
                              'Dados do Aluno',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildCardForm(
                              title: 'Nome Completo Aluno',
                              controller: _nomeController,
                            ),
                            const SizedBox(height: 8),
                            _buildCardForm(
                              title: 'CPF',
                              controller: _cpfController,
                            ),
                            const SizedBox(height: 8),
                            _buildCardForm(
                              title: 'Sexo',
                              controller: _sexoController,
                            ),
                            const SizedBox(height: 8),
                            _buildCardForm(
                              title: 'Naturalidade',
                              controller: _naturalidadeController,
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Data de Nascimento: ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    final DateTime? data = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now().subtract(
                                        const Duration(days: 365 * 10),
                                      ),
                                      firstDate: DateTime(1950),
                                      lastDate: DateTime.now(),
                                    );
                                    if (data != null) {
                                      setState(() {
                                        _dataNascimentoController = data;
                                      });
                                    }
                                  },
                                  child: Text(
                                    _dataNascimentoController == null
                                        ? 'Selecionar Data'
                                        : '${_dataNascimentoController!.day}/${_dataNascimentoController!.month}/${_dataNascimentoController!.year}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            const Text(
                              'Endereço',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildCardForm(
                              title: 'Cep',
                              controller: _cepController,
                            ),
                            const SizedBox(height: 8),
                            _buildCardForm(
                              title: 'Rua',
                              controller: _ruaController,
                            ),
                            const SizedBox(height: 8),
                            _buildCardForm(
                              title: 'Número',
                              controller: _numeroController,
                            ),
                            const SizedBox(height: 8),
                            _buildCardForm(
                              title: 'Bairro',
                              controller: _bairroController,
                            ),
                            const SizedBox(height: 8),
                            _buildCardForm(
                              title: 'Cidade',
                              controller: _cidadeController,
                            ),
                            const SizedBox(height: 8),
                            _buildCardForm(
                              title: 'Estado',
                              controller: _estadoController,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardForm({
    required String title,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }
}
