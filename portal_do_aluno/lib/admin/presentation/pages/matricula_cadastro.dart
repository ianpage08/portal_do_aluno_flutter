import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portal_do_aluno/admin/data/firestore_services/matricula_service.dart';
import 'package:portal_do_aluno/admin/data/models/aluno.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/scaffold_messeger.dart';
import 'package:portal_do_aluno/core/utils/cpf_input_fomatado.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class MatriculaCadastro extends StatefulWidget {
  const MatriculaCadastro({super.key});

  @override
  State<MatriculaCadastro> createState() => _MatriculaCadastroState();
}

class _MatriculaCadastroState extends State<MatriculaCadastro> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final MatriculaService _matriculaService = MatriculaService();

  // Controllers
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _naturalidadeController = TextEditingController();
  final TextEditingController _sexoController = TextEditingController();
  DateTime? _dataNascimentoController;

  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();

  final TextEditingController _nomeMaeController = TextEditingController();
  final TextEditingController _cpfMaeController = TextEditingController();
  final TextEditingController _telefoneMaeController = TextEditingController();
  final TextEditingController _nomePaiController = TextEditingController();
  final TextEditingController _cpfPaiController = TextEditingController();
  final TextEditingController _telefonePaiController = TextEditingController();

  final TextEditingController _numeroMatriculaController =
      TextEditingController();
  final TextEditingController _tumarControler = TextEditingController();
  final TextEditingController _anoLetivoController = TextEditingController();
  final TextEditingController _turnoController = TextEditingController();
  final TextEditingController _situacaoController = TextEditingController();

  final TextEditingController _alergiasController = TextEditingController();
  final TextEditingController _medicamentosController = TextEditingController();
  final TextEditingController _observacoesController = TextEditingController();

  // 👇 Armazenar o ID real da turma
  String? _turmaIdSelecionada;

  @override
  void dispose() {
    final List<TextEditingController> controlles = [
      _nomeController,
      _cpfController,
      _naturalidadeController,
      _sexoController,
      _cepController,
      _ruaController,
      _numeroController,
      _bairroController,
      _cidadeController,
      _estadoController,
      _nomeMaeController,
      _cpfMaeController,
      _telefoneMaeController,
      _nomePaiController,
      _cpfPaiController,
      _telefonePaiController,
      _numeroMatriculaController,
      _tumarControler,
      _anoLetivoController,
      _turnoController,
      _situacaoController,
      _alergiasController,
      _medicamentosController,
      _observacoesController,
    ];
    for (var controller in controlles) {
      controller.dispose();
    }
    super.dispose();
  }

  void _cadastrarAluno() async {
    if (!_formKey.currentState!.validate() ||
        _dataNascimentoController == null ||
        _turmaIdSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos obrigatórios corretamente'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final dadosAluno = DadosAluno(
      nome: _nomeController.text,
      cpf: _cpfController.text,
      sexo: _sexoController.text,
      naturalidade: _naturalidadeController.text,
      dataNascimento: _dataNascimentoController!,
    );

    final enderecoAluno = EnderecoAluno(
      cep: _cepController.text,
      rua: _ruaController.text,
      numero: _numeroController.text,
      bairro: _bairroController.text,
      cidade: _cidadeController.text,
      estado: _estadoController.text,
    );

    final responsaveisAluno = ResponsaveisAluno(
      nomeMae: _nomeMaeController.text,
      cpfMae: _cpfMaeController.text,
      telefoneMae: _telefoneMaeController.text,
      nomePai: _nomePaiController.text,
      cpfPai: _cpfPaiController.text,
      telefonePai: _telefonePaiController.text,
    );

    final dadosAcademicos = DadosAcademicos(
      classId: _turmaIdSelecionada!, // 👈 ID real da turma
      numeroMatricula: _numeroMatriculaController.text,
      turma: _tumarControler.text,
      anoLetivo: _anoLetivoController.text,
      turno: _turnoController.text,
      situacao: _situacaoController.text,
      dataMatricula: DateTime.now(),
    );

    final informacoesMedicasAluno = InformacoesMedicasAluno(
      alergia: _alergiasController.text,
      medicacao: _medicamentosController.text,
      observacoes: _observacoesController.text,
    );

    try {
      await _matriculaService.cadastrarAlunoCompleto(
        turmaId: _turmaIdSelecionada!, // 👈 ID real da turma
        dadosAluno: dadosAluno,
        enderecoAluno: enderecoAluno,
        responsaveisAluno: responsaveisAluno,
        dadosAcademicos: dadosAcademicos,
        informacoesMedicasAluno: informacoesMedicasAluno,
      );

      if (mounted) {
        snackBarPersonalizado(
          context: context,
          mensagem: 'Aluno cadastrado com sucesso! 🎉',
        );
      }
      _limparCampos();
    } catch (e) {
      if (mounted) {
        snackBarPersonalizado(
          context: context,
          mensagem: 'Erro ao cadastrar aluno',
        );
      }
    }
  }

  void _limparCampos() {
    final List<TextEditingController> controlles = [
      _nomeController,
      _cpfController,
      _naturalidadeController,
      _sexoController,
      _cepController,
      _ruaController,
      _numeroController,
      _bairroController,
      _cidadeController,
      _estadoController,
      _nomeMaeController,
      _cpfMaeController,
      _telefoneMaeController,
      _nomePaiController,
      _cpfPaiController,
      _telefonePaiController,
      _numeroMatriculaController,
      _tumarControler,
      _anoLetivoController,
      _turnoController,
      _alergiasController,
      _medicamentosController,
      _observacoesController,
      _situacaoController,
    ];

    for (var controller in controlles) {
      controller.clear();
    }

    setState(() {
      _dataNascimentoController = null;
      _turmaIdSelecionada = null; // 👈 resetar ID da turma
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Cadastro de Matrícula'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Formulário de Cadastro de Matrícula',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildCardAluno(),
              const SizedBox(height: 16),
              _buildCardEndereco(),
              const SizedBox(height: 16),
              _buildCardResponsaveis(),
              const SizedBox(height: 16),
              _buildCardAcademicos(),
              const SizedBox(height: 16),
              _buildCardMedicas(),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 28, 1, 104),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: _cadastrarAluno,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save),
                    SizedBox(width: 8),
                    Text('Cadastrar Aluno', style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== Widgets por seção ====================

  Widget _buildCardAluno() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text(
              'Dados do Aluno',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildTextForm(
              title: 'Nome Completo Aluno',
              controller: _nomeController,
            ),
            const SizedBox(height: 12),
            _buildTextForm(
              title: 'CPF',
              controller: _cpfController,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
                CpfInputFormatter(),
              ],
            ),
            const SizedBox(height: 12),
            _buildTextForm(
              title: 'Naturalidade',
              controller: _naturalidadeController,
            ),
            const SizedBox(height: 12),
            _buildTextForm(title: 'Sexo', controller: _sexoController),
            const SizedBox(height: 12),
            _buildDataNascimento(),
          ],
        ),
      ),
    );
  }

  Widget _buildCardEndereco() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text(
              'Endereço',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildTextForm(
              title: 'CEP',
              controller: _cepController,
              maxLength: 8,
            ),
            const SizedBox(height: 12),
            _buildTextForm(title: 'Rua', controller: _ruaController),
            const SizedBox(height: 12),
            _buildTextForm(title: 'Número', controller: _numeroController),
            const SizedBox(height: 12),
            _buildTextForm(title: 'Bairro', controller: _bairroController),
            const SizedBox(height: 12),
            _buildTextForm(title: 'Cidade', controller: _cidadeController),
            const SizedBox(height: 12),
            _buildTextForm(title: 'Estado', controller: _estadoController),
          ],
        ),
      ),
    );
  }

  Widget _buildCardResponsaveis() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text(
              'Responsáveis',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildTextForm(
              title: 'Nome da Mãe',
              controller: _nomeMaeController,
            ),
            const SizedBox(height: 12),
            _buildTextForm(
              title: 'CPF da Mãe',
              controller: _cpfMaeController,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
                CpfInputFormatter(),
              ],
            ),
            const SizedBox(height: 12),
            _buildTextForm(
              title: 'Telefone da Mãe',
              controller: _telefoneMaeController,
              maxLength: 11,
            ),
            const SizedBox(height: 12),
            _buildTextForm(
              title: 'Nome do Pai',
              controller: _nomePaiController,
            ),
            const SizedBox(height: 12),
            _buildTextForm(
              title: 'CPF do Pai',
              controller: _cpfPaiController,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
                CpfInputFormatter(),
              ],
            ),
            const SizedBox(height: 12),
            _buildTextForm(
              title: 'Telefone do Pai',
              controller: _telefonePaiController,
              maxLength: 11,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardAcademicos() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text(
              'Dados Acadêmicos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildTextForm(
              title: 'Número da Matrícula',
              controller: _numeroMatriculaController,
            ),
            const SizedBox(height: 12),
            _buildTextForm(
              title: 'Ano Letivo',
              controller: _anoLetivoController,
            ),
            const SizedBox(height: 12),
            _buildTextForm(title: 'Turno', controller: _turnoController),
            const SizedBox(height: 12),
            _buildTextForm(title: 'Situação', controller: _situacaoController),
            const SizedBox(height: 12),
            _buildEscolherNomeTurma(), // 👈 seleção da turma
          ],
        ),
      ),
    );
  }

  Widget _buildCardMedicas() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text(
              'Informações Médicas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildTextForm(
              title: 'Alergias',
              controller: _alergiasController,
              obrigatorio: false,
            ),
            const SizedBox(height: 12),
            _buildTextForm(
              title: 'Medicações',
              controller: _medicamentosController,
              obrigatorio: false,
            ),
            const SizedBox(height: 12),
            _buildTextForm(
              title: 'Observações',
              controller: _observacoesController,
              obrigatorio: false,
            ),
          ],
        ),
      ),
    );
  }

  // ==================== Campos auxiliares ====================
  Widget _buildTextForm({
    required String title,
    required TextEditingController controller,
    List<TextInputFormatter>? inputFormatters,
    bool obrigatorio = true,
    int? maxLength,
  }) {
    return TextFormField(
      controller: controller,
      maxLength: maxLength,
      inputFormatters: [if (inputFormatters != null) ...inputFormatters],
      validator: obrigatorio
          ? (value) =>
                (value == null || value.isEmpty) ? 'Campo obrigatório' : null
          : null,
      decoration: InputDecoration(
        labelText: title,
        filled: true,
        fillColor: const Color.fromARGB(48, 218, 194, 250),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 28, 1, 104),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }

  Widget _buildDataNascimento() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Data de Nascimento:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 29, 0, 107),
            foregroundColor: Colors.white,
          ),
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
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildEscolherNomeTurma() {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        icon: const Icon(Icons.school),
        style: TextButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        label: Text(
          _tumarControler.text.isEmpty
              ? 'Selecione uma Turma'
              : _tumarControler.text,
          style: const TextStyle(fontSize: 18),
        ),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('turmas')
                    .orderBy('serie')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;

                  return ListView(
                    children: docs.map((item) {
                      final nome = item['serie'] != null
                          ? '${item['serie']} - ${item['turno'] ?? ''}'
                          : 'Turma sem nome';
                      return ListTile(
                        title: Text(nome),
                        onTap: () {
                          setState(() {
                            _turmaIdSelecionada =
                                item.id; // 👈 salva ID real da turma
                            _tumarControler.text = nome; // mostra o nome
                            Navigator.pop(context);
                          });
                        },
                      );
                    }).toList(),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
