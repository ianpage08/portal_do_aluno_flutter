import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/helper/form_helper.dart';
import 'package:portal_do_aluno/shared/helpers/snack_bar_helper.dart';
import 'package:portal_do_aluno/shared/widgets/botao_salvar.dart';
import 'package:portal_do_aluno/shared/widgets/text_form_field.dart';
import 'package:portal_do_aluno/features/auth/data/datasouces/cadastro_service.dart';
import 'package:portal_do_aluno/navigation/navigation_sevice.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<FormState> _formaKey = GlobalKey<FormState>();
  final CadastroService _cadastroService = CadastroService();
  bool isObscure = true;

  final Map<String, TextEditingController> _mapTextEditing = {
    'novaSenha': TextEditingController(),
    'repetirSenha': TextEditingController(),
  };
  List<TextEditingController> get listControllers =>
      _mapTextEditing.values.toList();

  Future<void> _salvarSenha(String usuarioId) async {
    final novaSenha = _mapTextEditing['novaSenha']!.text;
    final repetirSenha = _mapTextEditing['repetirSenha']!.text;

    if (FormHelper.isFormValid(
      formKey: _formaKey,
      listControllers: listControllers,
    )) {
      if (novaSenha != repetirSenha) {
        return snackBarPersonalizado(
          context: context,
          mensagem: 'As senhas não são iguais',
        );
      }
      try {
        await _cadastroService.atualizarSenha(usuarioId, novaSenha);
      } catch (e) {
        if (mounted) {
          snackBarPersonalizado(
            context: context,
            mensagem: 'Erro ao atualizar a senha',
            cor: Colors.red,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final usuarioId = args['usuarioId'] ?? '';

    return Scaffold(
      appBar: const CustomAppBar(title: ''),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formaKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Atualizar Senha',
                        style: Theme.of(context).textTheme.headlineSmall!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),

                      /// Nova Senha
                      Text(
                        'Nova Senha',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      TextFormFieldPersonalizado(
                        obscureText: isObscure,
                        hintText: 'Digite sua nova senha',
                        controller: _mapTextEditing['novaSenha']!,
                        prefixIcon: Icons.lock,
                        suffixIcon: IconButton(
                          onPressed: () =>
                              setState(() => isObscure = !isObscure),
                          icon: Icon(
                            isObscure ? Icons.visibility_off : Icons.visibility,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira a senha';
                          }
                          if (value.length < 8) {
                            return 'Senha deve ter no mínimo 8 caracteres';
                          }
                          if (!value.contains(RegExp(r'[A-Z]'))) {
                            return 'Inclua ao menos 1 letra maiúscula';
                          }
                          if (!value.contains(RegExp(r'[a-z]'))) {
                            return 'Inclua ao menos 1 letra minúscula';
                          }
                          if (!value.contains(RegExp(r'[0-9]'))) {
                            return 'Inclua ao menos 1 número';
                          }
                          if (!value.contains(
                            RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
                          )) {
                            return 'Inclua ao menos 1 símbolo especial';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      /// Repetir Senha
                      Text(
                        'Confirmar Nova Senha',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      TextFormFieldPersonalizado(
                        obscureText: isObscure,
                        controller: _mapTextEditing['repetirSenha']!,
                        hintText: 'Confirme sua nova senha',
                        prefixIcon: Icons.lock_outline,
                        suffixIcon: IconButton(
                          onPressed: () =>
                              setState(() => isObscure = !isObscure),
                          icon: Icon(
                            isObscure ? Icons.visibility_off : Icons.visibility,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// Info Card
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.07),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const ListTile(
                          leading: Icon(Icons.info, color: Colors.blue),
                          title: Text('Dicas de Senha Segura'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('• Mínimo de 8 caracteres'),
                              Text('• Letras maiúsculas e minúsculas'),
                              Text('• Números e símbolos especiais'),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// Botão Salvar
                      BotaoSalvar(
                        salvarconteudo: () async {
                          _salvarSenha(usuarioId);
                          NavigatorService.navigateReplaceWith(
                            RouteNames.sucessResetPassword,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
