import 'package:flutter/material.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/text_form_field.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/widget_value_notifier/botao_selecionar_aluno.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/widget_value_notifier/botao_selecionar_turma.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<FormState> _formaKey = GlobalKey<FormState>();

  final Map<String, TextEditingController> _mapTextEditing = {
    'novaSenha': TextEditingController(),
    'repetirSenha': TextEditingController(),
  };

  final Map<String, String?> _mapSelectedValue = {
    'turmaId': null,
    'alunoId': null,
  };
  final Map<String, ValueNotifier<String?>> _mapValueNotifier = {
    'turma': ValueNotifier<String?>(null),
    'aluno': ValueNotifier<String?>(null),
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Mudar Senha'),
      body: Padding(
        padding: const EdgeInsetsGeometry.all(16),
        child: Card(
          child: Column(
            children: [
              BotaoSelecionarTurma(
                turmaSelecionada: _mapValueNotifier['turma']!,
                onTurmaSelecionada: (id, turmaNome) {
                  _mapSelectedValue['turmaId'] = id;
                },
              ),
              BotaoSelecionarAluno(
                alunoSelecionado: _mapValueNotifier['aluno']!,
                onAlunoSelecionado: (id, nomeCompleto, cpf) {
                  _mapSelectedValue['alunoId'] = id;
                },
              ),
              TextFormFieldPersonalizado(
                controller: _mapTextEditing['novaSenha']!,
                label: 'Nova Senha',
                prefixIcon: Icons.edit,
              ),
              TextFormFieldPersonalizado(
                controller: _mapTextEditing['repetirSenha']!,
                label: 'Repetir Senha',
                prefixIcon: Icons.edit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
