import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/admin/data/firestore_services/exercicio_sevice.dart';
import 'package:portal_do_aluno/admin/data/models/exercicios.dart';
import 'package:portal_do_aluno/admin/helper/form_helper.dart';
import 'package:portal_do_aluno/admin/presentation/providers/user_provider.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/botao_salvar.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/data_picker_calendario.dart';
import 'package:portal_do_aluno/admin/helper/snack_bar_personalizado.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/text_form_field.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/widget_value_notifier/botao_selecionar_turma.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';
import 'package:provider/provider.dart';

class CadastroExercicio extends StatefulWidget {
  const CadastroExercicio({super.key});

  @override
  State<CadastroExercicio> createState() => _CadastroExercicioState();
}

class _CadastroExercicioState extends State<CadastroExercicio> {
  final Map<String, TextEditingController> _mapController = {
    'titulo': TextEditingController(),
    'conteudo': TextEditingController(),
  };
  final Map<String, ValueNotifier<String?>> _mapValueNotifier = {
    'turmaId': ValueNotifier<String?>(null),
    'turmaNome': ValueNotifier<String?>(null),
  };

  List<TextEditingController> get _allControllers =>
      _mapController.values.toList();
  DateTime? dataSelecionada;
  final ValueNotifier<DateTime?> dataDeEntrega = ValueNotifier<DateTime?>(null);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ExercicioSevice _exercicioSevice = ExercicioSevice();
  void limparCampos() {
    FormHelper.limparControllers(controllers: _allControllers);
    _mapValueNotifier['turmaId']!.value = null;
    _mapValueNotifier['turmaNome']!.value = null;
    dataSelecionada = null;
  }

  Future<void> _cadastrarExercicio(String professorId) async {
    if (!FormHelper.isFormValid(
      formKey: _formKey,
      listControllers: _allControllers,
    )) {
      return snackBarPersonalizado(
        context: context,
        mensagem: 'Por favor, preencha todos os campos corretamente.',
        cor: Colors.orange,
      );
    }
    try {
      final profDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(professorId)
          .get();
      final profNome = profDoc.data()?['name'];
      final turmaId = _mapValueNotifier['turmaId']!.value;
      if (dataSelecionada == null && mounted) {
        return snackBarPersonalizado(
          context: context,
          mensagem: 'Por favor, selecione uma data de entrega',
          cor: Colors.orange,
        );
      }

      final exercicio = Exercicios(
        id: '',
        titulo: _mapController['titulo']!.text,
        conteudoDoExercicio: _mapController['conteudo']!.text,
        professorId: professorId,
        nomeDoProfessor: profNome,
        turmaId: turmaId!,
        dataDeEnvio: Timestamp.now(),
        dataDeEntrega: Timestamp.fromDate(dataSelecionada!),
      );

      await _exercicioSevice.cadastrarNovoExercicio(exercicio, turmaId);

      if (mounted) {
        snackBarPersonalizado(
          context: context,
          mensagem: 'Exercicio cadastrado com sucesso',
          cor: Colors.green,
        );
      }

      limparCampos();
    } catch (e) {
      if (mounted) {
        snackBarPersonalizado(
          context: context,
          mensagem: 'erro ao cadastrar exercicio',
          cor: Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final professorId = Provider.of<UserProvider>(context).userId;

    if (professorId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: const CustomAppBar(title: 'tela de  Exercicios'),

      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text(
              'Cadastro de Exercicios',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Turma',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      BotaoSelecionarTurma(
                        turmaSelecionada: _mapValueNotifier['turmaNome']!,
                        onTurmaSelecionada: (id, turmaNome) {
                          _mapValueNotifier['turmaId']!.value = id;
                          _mapValueNotifier['turmaNome']!.value = turmaNome;
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Titulo',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      TextFormFieldPersonalizado(
                        prefixIcon: const Icon(Icons.title),
                        controller: _mapController['titulo']!,

                        hintText: 'Ex: Atividade Para casa',
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Conteudo',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      TextFormFieldPersonalizado(
                        maxLines: 3,
                        prefixIcon: const Icon(Icons.notes),
                        controller: _mapController['conteudo']!,

                        hintText: 'Ex: Atividade da pagina 10  á 20 ',
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Data de Entrega',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      DataPickerCalendario(
                        isSelecionada: dataSelecionada,
                        onDate: (data) {
                          dataSelecionada = data;
                          debugPrint(dataSelecionada.toString());
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            BotaoSalvar(
              salvarconteudo: () async {
                await _cadastrarExercicio(professorId);
              },
            ),
          ],
        ),
      ),
    );
  }
}
