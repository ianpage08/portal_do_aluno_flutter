import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portal_do_aluno/shared/helpers/snack_bar_helper.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/text_form_field.dart';
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

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira seu CPF';
                          }
                          final cpfLimpo = _cpfController.text.replaceAll(
                            RegExp(r'\D'),
                            '',
                          );
                          if (cpfLimpo.length != 11) {
                            return 'CPF deve ter 11 dígitos';
                          }
                          return null;
                        },
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

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira sua senha';
                          }
                          if (value.length < 6) {
                            return 'Senha deve ter pelo menos 6 caracteres';
                          }
                          return null;
                        },

                        enable: !isLoading,
                      ),
                      const SizedBox(height: 24),

                      // Botão Login
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: Theme.of(context).elevatedButtonTheme.style,
                          onPressed: isLoading
                              ? null
                              : () async {
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }

                                  setState(() => isLoading = true);

                                  try {
                                    final cpf = _cpfController.text.trim();
                                    final senha = _passwordController.text
                                        .trim();

                                    final usuario = await AuthServico()
                                        .loginCpfsenha(cpf, senha);
                                    if (!mounted) return;

                                    // Se chegou aqui, login ok
                                    NavigatorService.setCurrentUser(usuario);
                                    await NavigatorService.navigateToDashboard();
                                  } catch (e) {
                                    // Aqui você mostra a mensagem de erro

                                    if (mounted) {
                                      snackBarPersonalizado(
                                        context: context,
                                        mensagem: 'Erro ao fazer login',
                                      );
                                    }
                                  } finally {
                                    if (mounted) {
                                      setState(() => isLoading = false);
                                    }
                                  }
                                },
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

                      // Link Esqueci Senha
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

  /*Future<void> _simularLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));
      final cpf = _cpfController.text;
      final password = _passwordController.text;

      UserType userType = UserType.student;
      if (cpf == '85300011122') {
        userType = UserType.student;
      } else if (cpf == '11122233344') {
        userType = UserType.teacher;
      } else if (cpf == '55566677788') {
        userType = UserType.admin;
      }

      final user = Usuario(
        id: 'ui d',
        name: 'Usuário de teste',
        cpf: cpf,
        password: password,
        type: userType,
      );

      if (mounted) {
        NavigatorService.setCurrentUser(user);
        await NavigatorService.navigateToDashboard();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login realizado como ${userType.name}!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao fazer login: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
*/

  void _handleForgotPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Funcionalidade em desenvolvimento')),
    );
  }
}
