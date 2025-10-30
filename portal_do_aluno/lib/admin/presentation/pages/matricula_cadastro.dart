import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portal_do_aluno/admin/data/firestore_services/matricula_service.dart';
import 'package:portal_do_aluno/admin/data/models/aluno.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/data_picker_calendario.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/fixed_drop.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/scaffold_messeger.dart';

import 'package:portal_do_aluno/admin/presentation/widgets/text_form_field.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/widget_value_notifier/botao_selecionar_turma.dart';
import 'package:portal_do_aluno/core/utils/cpf_input_fomatado.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class MatriculaCadastro extends StatefulWidget {
  const MatriculaCadastro({super.key});

  @override
  State<MatriculaCadastro> createState() => _MatriculaCadastroState();
}

class _MatriculaCadastroState extends State<MatriculaCadastro>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final MatriculaService _matriculaService = MatriculaService();

  // Controllers
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _naturalidadeController = TextEditingController();

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

  final ValueNotifier<String?> _turmaId = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _turmaNome = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _sexoSelecionado = ValueNotifier<String?>(null);
  final ValueNotifier<DateTime?> dataSelecionada = ValueNotifier<DateTime?>(
    null,
  );
  final ValueNotifier<String?> turnoSelecionado = ValueNotifier<String?>(null);

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    for (final c in [
      _nomeController,
      _cpfController,
      _naturalidadeController,
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
    ]) {
      c.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  void _cadastrarAluno() async {
    if (!_formKey.currentState!.validate() ||
        dataSelecionada.value == null ||
        _turmaId.value == null) {
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
      sexo: _sexoSelecionado.value ?? '',
      naturalidade: _naturalidadeController.text,
      dataNascimento: dataSelecionada.value!,
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
      classId: _turmaId.value!,
      numeroMatricula: _numeroMatriculaController.text,
      turma: _tumarControler.text,
      anoLetivo: _anoLetivoController.text,
      turno: turnoSelecionado.value ?? '',
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
        turmaId: _turmaId.value!,
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
    for (final c in [
      _nomeController,
      _cpfController,
      _naturalidadeController,
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
    ]) {
      c.clear();
    }
    _sexoSelecionado.value = null;
    dataSelecionada.value = null;
    turnoSelecionado.value = null;
    _turmaId.value = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Cadastro de Matrícula'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: FadeTransition(
          opacity: _fadeAnimation,
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
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 28, 1, 104),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  icon: const Icon(CupertinoIcons.floppy_disk),
                  label: const Text(
                    'Cadastrar Aluno',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: _cadastrarAluno,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==================== Widgets por seção ====================

  Widget _buildCardAluno() => _cardSection(
    title: 'Dados do Aluno',
    children: [
      TextFormFieldPersonalizado(
        label: 'Nome Completo do Aluno',
        controller: _nomeController,
        prefixIcon: const Icon(CupertinoIcons.person_fill),
      ),
      TextFormFieldPersonalizado(
        label: 'CPF',
        controller: _cpfController,
        prefixIcon: const Icon(CupertinoIcons.number),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(11),
          CpfInputFormatter(),
        ],
      ),
      TextFormFieldPersonalizado(
        label: 'Naturalidade',
        controller: _naturalidadeController,
        prefixIcon: const Icon(CupertinoIcons.location_solid),
      ),
      ValueListenableBuilder<String?>(
        valueListenable: _sexoSelecionado,
        builder: (context, sexo, child) => FixedDrop(
          itens: const ['Masculino', 'Feminino'],
          selecionado: sexo,
          titulo: 'Selecione o sexo do aluno(a)',
          icon: CupertinoIcons.person_2_fill,
          onSelected: (valor) => _sexoSelecionado.value = valor,
        ),
      ),
      ValueListenableBuilder<DateTime?>(
        valueListenable: dataSelecionada,
        builder: (context, dataEscolhida, child) {
          return DataPickerCalendario(
            onDate: (data) => dataSelecionada.value = data,
          );
        },
      ),
    ],
  );

  Widget _buildCardEndereco() => _cardSection(
    title: 'Endereço',
    children: [
      TextFormFieldPersonalizado(
        label: 'CEP',
        controller: _cepController,
        prefixIcon: const Icon(CupertinoIcons.map_pin_ellipse),
      ),
      TextFormFieldPersonalizado(
        label: 'Rua',
        controller: _ruaController,
        prefixIcon: const Icon(CupertinoIcons.location),
      ),
      TextFormFieldPersonalizado(
        label: 'Número',
        controller: _numeroController,
        prefixIcon: const Icon(CupertinoIcons.number_square),
      ),
      TextFormFieldPersonalizado(
        label: 'Bairro',
        controller: _bairroController,
        prefixIcon: const Icon(CupertinoIcons.map_pin),
      ),
      TextFormFieldPersonalizado(
        label: 'Cidade',
        controller: _cidadeController,
        prefixIcon: const Icon(CupertinoIcons.building_2_fill),
      ),
      TextFormFieldPersonalizado(
        label: 'Estado',
        controller: _estadoController,
        prefixIcon: const Icon(CupertinoIcons.flag),
      ),
    ],
  );

  Widget _buildCardResponsaveis() => _cardSection(
    title: 'Responsáveis',
    children: [
      TextFormFieldPersonalizado(
        label: 'Nome da Mãe',
        controller: _nomeMaeController,
        prefixIcon: const Icon(
          CupertinoIcons.person_crop_circle_fill_badge_checkmark,
        ),
      ),
      TextFormFieldPersonalizado(
        label: 'CPF da Mãe',
        controller: _cpfMaeController,
        prefixIcon: const Icon(CupertinoIcons.number_circle),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(11),
          CpfInputFormatter(),
        ],
      ),
      TextFormFieldPersonalizado(
        label: 'Telefone da Mãe',
        controller: _telefoneMaeController,
        prefixIcon: const Icon(CupertinoIcons.phone_fill),
        maxLength: 11,
      ),
      TextFormFieldPersonalizado(
        label: 'Nome do Pai',
        controller: _nomePaiController,
        prefixIcon: const Icon(CupertinoIcons.person_crop_circle_fill),
      ),
      TextFormFieldPersonalizado(
        label: 'CPF do Pai',
        controller: _cpfPaiController,
        prefixIcon: const Icon(CupertinoIcons.number_circle_fill),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(11),
          CpfInputFormatter(),
        ],
      ),
      TextFormFieldPersonalizado(
        label: 'Telefone do Pai',
        controller: _telefonePaiController,
        prefixIcon: const Icon(CupertinoIcons.phone),
        maxLength: 11,
      ),
    ],
  );

  Widget _buildCardAcademicos() => _cardSection(
    title: 'Dados Acadêmicos',
    children: [
      TextFormFieldPersonalizado(
        label: 'Número da Matrícula',
        controller: _numeroMatriculaController,
        prefixIcon: const Icon(CupertinoIcons.doc_text),
      ),
      TextFormFieldPersonalizado(
        label: 'Ano Letivo',
        controller: _anoLetivoController,
        prefixIcon: const Icon(CupertinoIcons.calendar_today),
      ),
      ValueListenableBuilder<String?>(
        valueListenable: turnoSelecionado,
        builder: (context, value, child) {
          return FixedDrop(
            itens: const ['Matutino', 'Vespertino'],
            selecionado: value,
            titulo: 'Selecione o turno',
            icon: CupertinoIcons.time_solid,
            onSelected: (valor) => turnoSelecionado.value = valor,
          );
        },
      ),
      BotaoSelecionarTurma(
        turmaSelecionada: _turmaNome,
        onTurmaSelecionada: (id, turmaNome) {
          _turmaNome.value = turmaNome;
          _turmaId.value = id;
          debugPrint('Turma selecionada: $turmaNome (ID: $id)');
        },
      ),
    ],
  );

  Widget _buildCardMedicas() => _cardSection(
    title: 'Informações Médicas',
    children: [
      TextFormFieldPersonalizado(
        label: 'Alergias',
        controller: _alergiasController,
        prefixIcon: const Icon(CupertinoIcons.bandage_fill),
        obrigatorio: false,
      ),
      TextFormFieldPersonalizado(
        label: 'Medicações',
        controller: _medicamentosController,
        prefixIcon: const Icon(CupertinoIcons.capsule_fill),
        obrigatorio: false,
      ),
      TextFormFieldPersonalizado(
        label: 'Observações',
        controller: _observacoesController,
        prefixIcon: const Icon(CupertinoIcons.text_bubble_fill),
        obrigatorio: false,
      ),
    ],
  );

  Widget _cardSection({required String title, required List<Widget> children}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...children.expand((child) => [child, const SizedBox(height: 12)]),
          ],
        ),
      ),
    );
  }
}
