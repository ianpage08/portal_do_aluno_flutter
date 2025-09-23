import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portal_do_aluno/core/user/user.dart';
import 'package:portal_do_aluno/navigation/navigation_sevice.dart';

//import 'package:portal_do_aluno/navigation/route_names.dart';
import '../../core/app_constants/app_constants.dart';
import '../../core/app_constants/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(); // ✅ Com underscore
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // ✅ Com underscore
  bool _obscurePassword = true; // ✅ Com underscore

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
                  key: _formKey, // ✅ Corrigido
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // ✅ Melhor layout
                    children: [
                      // Logo
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          Icons.school,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                      const SizedBox(height: 24), // ✅ Espaçamento
                      // Título
                      Text(
                        AppConstants.nameApp,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
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
                      TextFormField(
                        controller: _cpfController,
                        keyboardType: TextInputType.number, // ✅ Melhor para CPF
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly, // ✅ Só números
                          LengthLimitingTextInputFormatter(
                            11,
                          ), // ✅ Máximo 11 dígitos
                        ],
                        decoration: const InputDecoration(
                          labelText: 'CPF',
                          prefixIcon: Icon(Icons.person),
                          hintText: 'Digite seu CPF (apenas números)',
                          border: OutlineInputBorder(), // ✅ Borda
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira seu CPF';
                          }
                          if (value.length != 11) {
                            return 'CPF deve ter 11 dígitos';
                          }
                          return null;
                        },
                        enabled: !_isLoading, // ✅ Corrigido
                      ),
                      const SizedBox(height: 16),

                      // Campo Senha
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword, // ✅ Corrigido
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          hintText: 'Digite sua senha', // ✅ Corrigido
                          prefixIcon: const Icon(Icons.lock),
                          border: const OutlineInputBorder(), // ✅ Borda
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword =
                                    !_obscurePassword; // ✅ Corrigido
                              });
                            },
                            icon: Icon(
                              _obscurePassword // ✅ Corrigido
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        ),
                        // ✅ VALIDAÇÃO ADICIONADA
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira sua senha';
                          }
                          if (value.length < 6) {
                            return 'Senha deve ter pelo menos 6 caracteres';
                          }
                          return null;
                        },
                        enabled: !_isLoading, // ✅ Adicionar
                      ),
                      const SizedBox(height: 24),

                      // Botão Login
                      SizedBox(
                        width: double.infinity,
                        height: 50, // ✅ Altura melhor
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor:
                                Colors.white, // ✅ Melhor que definir no Text
                          ),
                          onPressed: _isLoading
                              ? null
                              : _simularLogin, // ✅ Função adicionada
                          child:
                              _isLoading // ✅ Loading melhorado
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
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Link Esqueci Senha
                      TextButton(
                        onPressed: _isLoading ? null : _handleForgotPassword,
                        child: const Text('Esqueci minha senha'),
                      ),
                      const SizedBox(height: 24),

                      // Usuários de Teste
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Usuários de Teste:',
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            _buildTestUser('Aluno', '85300011122', 'senha123'),
                            _buildTestUser(
                              'Professor',
                              '11122233344',
                              'senha123',
                            ),
                            _buildTestUser(
                              'Responsável',
                              '55566677788',
                              'senha123',
                            ), // ✅ Corrigido
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
              '$tipo: $cpf / $senha', // ✅ Vírgula removida
              style: const TextStyle(fontSize: 12),
            ),
          ),
          IconButton(
            onPressed: () {
              _cpfController.text = cpf;
              _passwordController.text = senha;
            },
            icon: const Icon(Icons.copy, size: 16),
          ),
        ],
      ),
    );
  }

  // ✅ MÉTODO DE LOGIN DENTRO DA CLASSE
  Future<void> _simularLogin() async {
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

      final user = User(
        id: 1,
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

  void _handleForgotPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Funcionalidade em desenvolvimento')),
    );
  }
}
