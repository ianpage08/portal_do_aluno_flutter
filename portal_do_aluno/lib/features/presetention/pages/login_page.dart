import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portal_do_aluno/core/utils/validacao.dart';
import 'package:portal_do_aluno/shared/helpers/single_execution_flag.dart';
import 'package:portal_do_aluno/shared/helpers/snack_bar_helper.dart';

import 'package:portal_do_aluno/shared/widgets/text_form_field.dart';
import 'package:portal_do_aluno/core/utils/formatters.dart';

import 'package:portal_do_aluno/features/auth/data/datasouces/auth_service_datasource.dart';
import 'package:portal_do_aluno/navigation/navigation_sevice.dart';

//import 'package:portal_do_aluno/navigation/route_names.dart';
import '../../../core/app_constants/app_constants.dart';
import '../../../core/app_constants/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final SingleExecutionFlag _navigationFlag = SingleExecutionFlag();

  bool isLoading = false;
  bool _obscurePassword = true; //  Com underscore

  @override
  void dispose() {
    _cpfController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          Icons.school,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Título
                      Text(
                        AppConstants.nameApp,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                      const SizedBox(height: 8),

                      // Subtítulo
                      Text(
                        'Faça login para continuar',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Campo CPF
                      TextFormFieldPersonalizado(
                        controller: _cpfController,
                        keyboardType: TextInputType.number, //  Melhor para CPF
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly, //  Só números
                          LengthLimitingTextInputFormatter(
                            11,
                          ), //  Máximo 11 dígitos
                          CpfInputFormatter(), //  Formatação CPF
                        ],

                        label: 'CPF',

                        prefixIcon: Icons.person,
                        hintText: '000.000.000-00',

                        validator: (value) => validarCpf(value),
                        enable: !isLoading,
                      ),
                      const SizedBox(height: 16),

                      // Campo Senha
                      TextFormFieldPersonalizado(
                        controller: _passwordController,
                        obscureText: _obscurePassword,

                        label: 'Senha',
                        hintText: 'Digite sua senha',
                        prefixIcon: Icons.lock,

                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),

                        validator: (value) => validarSenha(value),

                        enable: !isLoading,
                      ),
                      const SizedBox(height: 24),

                      // Botão Login
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: Theme.of(context).elevatedButtonTheme.style,
                          onPressed: isLoading ? null : _handleLogin,
                          child:
                              isLoading //  Loading melhorado
                              ? const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text('Entrando...'),
                                  ],
                                )
                              : const Text(
                                  'Entrar',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 5),

                      //  Esqueci Senha
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: TextButton(
                          onPressed: isLoading ? null : _handleForgotPassword,
                          style: TextButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              0,
                              172,
                              160,
                              228,
                            ),
                            side: const BorderSide(
                              color: Color.fromARGB(0, 0, 123, 255),
                            ),
                          ),

                          child: const Text(
                            'Esqueci Minha Senha',
                            style: TextStyle(
                              color: Color.fromARGB(255, 151, 151, 151),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Usuários de Teste
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 95, 100, 122),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Usuários de Teste:',
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            _buildTestUser(
                              'Aluno',
                              '888.888.888-88',
                              '@Maciel2003',
                            ),
                            _buildTestUser(
                              'Professor',
                              '666.666.666-66',
                              '@Maciel2003',
                            ),
                            _buildTestUser(
                              'admin',
                              '853.523.000-00',
                              '@Maciel2003',
                            ),
                          ],
                        ),
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

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    _navigationFlag.execute(() async {
      try {
        final cpf = _cpfController.text.trim();
        final senha = _passwordController.text.trim();

        final usuario = await AuthServico().loginCpfsenha(cpf, senha);

        if (!mounted) return;

        // Define usuário atual e navega
        NavigatorService.setCurrentUser(usuario);
        await NavigatorService.navigateToDashboard();
      } catch (e) {
        if (mounted) {
          snackBarPersonalizado(
            context: context,
            mensagem: 'Cpf ou senha inválidos',
            cor: Colors.red,
          );
        }
        _navigationFlag.reset();
      } finally {
        if (mounted) {
          setState(() => isLoading = false);
        }
      }
    });
  }

  // ✅ MÉTODO DENTRO DA CLASSE
  Widget _buildTestUser(String tipo, String cpf, String senha) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$tipo: $cpf / $senha',
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
          IconButton(
            onPressed: () {
              _cpfController.text = cpf;
              _passwordController.text = senha;
            },
            icon: const Icon(Icons.copy, size: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }

  void _handleForgotPassword() {
    snackBarPersonalizado(
      context: context,
      mensagem: 'Falar com o suporte',
      cor: Colors.orange,
    );
  }
}
