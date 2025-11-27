import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portal_do_aluno/features/admin/data/datasources/matricula_firestore.dart';
import 'package:portal_do_aluno/features/admin/data/models/aluno.dart';
import 'package:portal_do_aluno/features/admin/helper/form_helper.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/data_picker_calendario.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/fixed_drop.dart';
import 'package:portal_do_aluno/shared/helpers/snack_bar_helper.dart';

import 'package:portal_do_aluno/features/admin/presentation/widgets/text_form_field.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/widget_value_notifier/botao_selecionar_turma.dart';
import 'package:portal_do_aluno/core/utils/formatters.dart';
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
  final Map<String, TextEditingController> _mapController = {
    'nomeAluno': TextEditingController(),
    'cpfAluno': TextEditingController(),
    'naturalidade': TextEditingController(),
    'cep': TextEditingController(),
    'rua': TextEditingController(),
    'numero': TextEditingController(),
    'bairro': TextEditingController(),
    'cidade': TextEditingController(),
    'estado': TextEditingController(),
    'nomeMae': TextEditingController(),
    'cpfMae': TextEditingController(),
    'telefoneMae': TextEditingController(),
    'nomePai': TextEditingController(),
    'cpfPai': TextEditingController(),
    'telefonePai': TextEditingController(),
    'numeroMatricula': TextEditingController(),
    'anoLetivo': TextEditingController(),

    'alergias': TextEditingController(),
    'medicamentos': TextEditingController(),
    'observacoes': TextEditingController(),
  };
  List<TextEditingController> get _allControllers =>
      _mapController.values.toList();

  final Map<String, ValueNotifier<String?>> _mapValueNotifier = {
    'turmaNome': ValueNotifier<String?>(null),
    'sexoSelecionado': ValueNotifier<String?>(null),
    'turnoSelecionado': ValueNotifier<String?>(null),
    'turmaId': ValueNotifier<String?>(null),
  };

  final ValueNotifier<DateTime?> dataSelecionada = ValueNotifier<DateTime?>(
    null,
  );

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
    for (var controller in _allControllers) {
      controller.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  void _cadastrarAluno() async {
    debugPrint(
      'Iniciando cadastro do aluno... ${_mapController['nomeAluno']!.text}',
    );
    _mapController.forEach((key, controller) {
      debugPrint('Campo: $key, Valor: ${controller.text}');
    });
    if (!FormHelper.isFormValid(
          formKey: _formKey,
          listControllers: _allControllers,
        ) ||
        dataSelecionada.value == null ||
        _mapValueNotifier['turmaId']!.value == null) {
      snackBarPersonalizado(
        context: context,
        mensagem:
            'Por favor, preencha todos os campos obrigatórios corretamente.',
        cor: Colors.red,
      );
      return;
    }

    final dadosAluno = DadosAluno(
      nome: _mapController['nomeAluno']!.text,
      cpf: _mapController['cpfAluno']!.text,
      sexo: _mapValueNotifier['sexoSelecionado']!.value ?? '',
      naturalidade: _mapController['naturalidade']!.text,
      dataNascimento: dataSelecionada.value!,
    );

    final enderecoAluno = EnderecoAluno(
      cep: _mapController['cep']!.text,
      rua: _mapController['rua']!.text,

      numero: _mapController['numero']!.text,
      bairro: _mapController['bairro']!.text,
      cidade: _mapController['cidade']!.text,
      estado: _mapController['estado']!.text,
    );

    final responsaveisAluno = ResponsaveisAluno(
      nomeMae: _mapController['nomeMae']!.text,
      cpfMae: _mapController['cpfMae']!.text,
      telefoneMae: _mapController['telefoneMae']!.text,
      nomePai: _mapController['nomePai']!.text,
      cpfPai: _mapController['cpfPai']!.text,
      telefonePai: _mapController['telefonePai']!.text,
    );

    final dadosAcademicos = DadosAcademicos(
      classId: _mapValueNotifier['turmaId']!.value!,
      numeroMatricula: _mapController['numeroMatricula']!.text,
      turma: _mapValueNotifier['turmaNome']!.value ?? '',
      anoLetivo: _mapController['anoLetivo']!.text,
      turno: _mapValueNotifier['turnoSelecionado']!.value ?? '',
      situacao: 'Matriculado',
      dataMatricula: DateTime.now(),
    );

    final informacoesMedicasAluno = InformacoesMedicasAluno(
      alergia: _mapController['alergias']!.text,
      medicacao: _mapController['medicamentos']!.text,
      observacoes: _mapController['observacoes']!.text,
    );

    try {
      await _matriculaService.cadastrarAlunoCompleto(
        turmaId: _mapValueNotifier['turmaId']!.value!,
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
    FormHelper.limparControllers(controllers: _allControllers);
    _mapValueNotifier['turmaNome']!.value = null;
    _mapValueNotifier['sexoSelecionado']!.value = null;
    _mapValueNotifier['turnoSelecionado']!.value = null;
    _mapValueNotifier['turmaId']!.value = null;
    dataSelecionada.value = null;
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
                Text(
                  'Formulário de Cadastro de Matrícula',
                  style: Theme.of(context).textTheme.titleLarge,
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: Theme.of(context).elevatedButtonTheme.style,
                    icon: const Icon(CupertinoIcons.floppy_disk),
                    label: const Text(
                      'Cadastrar Aluno',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: _cadastrarAluno,
                  ),
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
        controller: _mapController['nomeAluno']!,
        prefixIcon: CupertinoIcons.person_fill,
      ),
      TextFormFieldPersonalizado(
        label: 'CPF',
        controller: _mapController['cpfAluno']!,
        prefixIcon: CupertinoIcons.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(11),
          CpfInputFormatter(),
        ],
      ),
      TextFormFieldPersonalizado(
        label: 'Naturalidade',
        controller: _mapController['naturalidade']!,
        prefixIcon: CupertinoIcons.location_solid,
      ),
      ValueListenableBuilder<String?>(
        valueListenable: _mapValueNotifier['sexoSelecionado']!,
        builder: (context, sexo, child) => FixedDrop(
          itens: const ['Masculino', 'Feminino'],
          selecionado: sexo,
          titulo: 'Selecione o sexo do aluno(a)',
          icon: CupertinoIcons.person_2_fill,
          onSelected: (valor) =>
              _mapValueNotifier['sexoSelecionado']!.value = valor,
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
        controller: _mapController['cep']!,
        prefixIcon: CupertinoIcons.map_pin_ellipse,
      ),
      TextFormFieldPersonalizado(
        label: 'Rua',
        controller: _mapController['rua']!,
        prefixIcon: CupertinoIcons.location,
      ),
      TextFormFieldPersonalizado(
        label: 'Número',
        controller: _mapController['numero']!,
        prefixIcon: CupertinoIcons.number_square,
      ),
      TextFormFieldPersonalizado(
        label: 'Bairro',
        controller: _mapController['bairro']!,
        prefixIcon: CupertinoIcons.map_pin,
      ),
      TextFormFieldPersonalizado(
        label: 'Cidade',
        controller: _mapController['cidade']!,
        prefixIcon: CupertinoIcons.building_2_fill,
      ),
      TextFormFieldPersonalizado(
        label: 'Estado',
        controller: _mapController['estado']!,
        prefixIcon:CupertinoIcons.flag,
      ),
    ],
  );

  Widget _buildCardResponsaveis() => _cardSection(
    title: 'Responsáveis',
    children: [
      TextFormFieldPersonalizado(
        label: 'Nome da Mãe',
        controller: _mapController['nomeMae']!,
        prefixIcon: 
          CupertinoIcons.person_crop_circle_fill_badge_checkmark,
        
      ),
      TextFormFieldPersonalizado(
        label: 'CPF da Mãe',
        controller: _mapController['cpfMae']!,
        prefixIcon: CupertinoIcons.number_circle,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(11),
          CpfInputFormatter(),
        ],
      ),
      TextFormFieldPersonalizado(
        label: 'Telefone da Mãe',
        controller: _mapController['telefoneMae']!,
        prefixIcon: CupertinoIcons.phone_fill,
        maxLength: 11,
      ),
      TextFormFieldPersonalizado(
        label: 'Nome do Pai',
        controller: _mapController['nomePai']!,
        prefixIcon: CupertinoIcons.person_crop_circle_fill,
      ),
      TextFormFieldPersonalizado(
        label: 'CPF do Pai',
        controller: _mapController['cpfPai']!,
        prefixIcon: CupertinoIcons.number_circle_fill,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(11),
          CpfInputFormatter(),
        ],
      ),
      TextFormFieldPersonalizado(
        label: 'Telefone do Pai',
        controller: _mapController['telefonePai']!,
        prefixIcon:CupertinoIcons.phone,
        maxLength: 11,
      ),
    ],
  );

  Widget _buildCardAcademicos() => _cardSection(
    title: 'Dados Acadêmicos',
    children: [
      TextFormFieldPersonalizado(
        label: 'Número da Matrícula',
        controller: _mapController['numeroMatricula']!,
        prefixIcon: CupertinoIcons.doc_text,
      ),
      TextFormFieldPersonalizado(
        label: 'Ano Letivo',
        controller: _mapController['anoLetivo']!,
        prefixIcon:CupertinoIcons.calendar_today,
      ),
      ValueListenableBuilder<String?>(
        valueListenable: _mapValueNotifier['turnoSelecionado']!,
        builder: (context, value, child) {
          return FixedDrop(
            itens: const ['Matutino', 'Vespertino'],
            selecionado: value,
            titulo: 'Selecione o turno',
            icon: CupertinoIcons.time_solid,
            onSelected: (valor) =>
                _mapValueNotifier['turnoSelecionado']!.value = valor,
          );
        },
      ),
      BotaoSelecionarTurma(
        turmaSelecionada: _mapValueNotifier['turmaNome']!,
        onTurmaSelecionada: (id, turmaNome) {
          _mapValueNotifier['turmaNome']!.value = turmaNome;
          _mapValueNotifier['turmaId']!.value = id;
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
        controller: _mapController['alergias']!,
        prefixIcon: CupertinoIcons.bandage_fill,
        obrigatorio: false,
      ),
      TextFormFieldPersonalizado(
        label: 'Medicações',
        controller: _mapController['medicamentos']!,
        prefixIcon: CupertinoIcons.capsule_fill,
        obrigatorio: false,
      ),
      TextFormFieldPersonalizado(
        label: 'Observações',
        controller: _mapController['observacoes']!,
        prefixIcon: CupertinoIcons.text_bubble_fill,
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
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            ...children.expand((child) => [child, const SizedBox(height: 12)]),
          ],
        ),
      ),
    );
  }
}
