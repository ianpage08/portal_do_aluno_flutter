/* Cadastrar/editar/excluir professores, alunos e responsáveis.

Reset de senha e permissões.*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portal_do_aluno/core/utils/cpf_input_fomatado.dart';
import 'package:portal_do_aluno/core/user/user.dart';
import 'package:portal_do_aluno/features/auth/data/datasouces/cadastro_service.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class GestaoDeUsuarios extends StatefulWidget {
  const GestaoDeUsuarios({super.key});

  @override
  State<GestaoDeUsuarios> createState() => _GestaoDeUsuariosState();
}

class _GestaoDeUsuariosState extends State<GestaoDeUsuarios> {
  final List<String> tipoUsuario = [
    'Professor',
    'Aluno',
    'Responsável',
    'Administrador',
  ];
  String? isSelectedTipo;
  bool isPasswordVisible = false;
  final TextEditingController nomeController = TextEditingController();

  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmarSenhaController =
      TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  UserType _mapTipo(String? tipo) {
    switch (tipo) {
      case 'Professor':
        return UserType.teacher;
      case 'Aluno':
        return UserType.student;
      case 'Responsável':
        return UserType.parent;
      case 'Administrador':
        return UserType.admin;
      default:
        return UserType.student;
    }
  }

  void showtipoPerfilModal() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      context: context,
      builder: (context) {
        return ListView(
          children: tipoUsuario.map((tipo) {
            return ListTile(
              title: Text(tipo),
              onTap: () {
                setState(() {
                  isSelectedTipo = tipo;

                  Navigator.pop(context);
                });
              },
            );
          }).toList(),
        );
      },
    );
  }

  void _limparCampos() {
    setState(() {
      nomeController.clear();
      senhaController.clear();
      confirmarSenhaController.clear();
      cpfController.clear();
      isSelectedTipo = null;
    });
  }

  void _adicionarUsuario() async {
    if (_formKey.currentState!.validate()) {
      final nome = nomeController.text.trim();

      final senha = senhaController.text.trim();
      final confirmarSenha = confirmarSenhaController.text.trim();
      final cpf = cpfController.text.replaceAll(RegExp(r'[^0-9]'), '');

      if (nome.isNotEmpty &&
          senha.isNotEmpty &&
          confirmarSenha.isNotEmpty &&
          cpf.isNotEmpty) {
        final verificarCpf = await FirebaseFirestore.instance
            .collection('usuarios')
            .where('cpf', isEqualTo: cpf)
            .get();
        if (verificarCpf.docs.isNotEmpty) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('CPF já cadastrado!'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 2),
              ),
            );
          }
          return;
        }
        final novoUsuario = Usuario(
          id: '',
          name: nome,
          cpf: cpf,
          password: senha,
          type: _mapTipo(isSelectedTipo),
        );
        try {
          await CadastroService().cadastroUsuario(novoUsuario);

          //feddback visual
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Usuário cadastrado com sucesso!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          }

          _limparCampos();
        } catch (e) {
          if (e is Exception) {
            debugPrint(e.toString());
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Gestão de Usuários'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nomeController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.person),
                            labelText: 'Nome Completo do Aluno',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira o nome';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: cpfController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(11),
                            CpfInputFormatter(),
                          ],
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.note),
                            labelText: 'CPF',
                            hintText: '000.000.000-00',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira o CPF';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: senhaController,
                          obscureText: !isPasswordVisible,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                              icon: isPasswordVisible
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility),
                            ),
                            labelText: 'Senha',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira a senha';
                            }
                            if (value.length < 8) {
                              return 'Senha deve ter no minimo 8 caracteres';
                            }
                            if (!value.contains(RegExp(r'[A-Z]'))) {
                              return 'Senha deve conter ao menos uma letra maiúscula';
                            }
                            if (!value.contains(RegExp(r'[a-z]'))) {
                              return 'Senha deve conter ao menos uma letra minúscula';
                            }
                            if (!value.contains(RegExp(r'[0-9]'))) {
                              return 'Senha deve conter ao menos um número';
                            }
                            if (!value.contains(
                              RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
                            )) {
                              return 'Senha deve conter ao menos um símbolo especial';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: confirmarSenhaController,
                          obscureText: !isPasswordVisible,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                              icon: isPasswordVisible
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility),
                            ),
                            labelText: 'Confirmar Senha',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                          validator: (value) {
                            if (value != senhaController.text) {
                              return 'Senhas não coincidem';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        const SizedBox(
                          child: Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ListTile(
                                  leading: Icon(Icons.info, color: Colors.blue),
                                  title: Text('Dica de Senha Segura'),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Mínimo de 8 caracteres'),

                                      Text(
                                        'Incluir letras maiúsculas e minúsculas',
                                      ),
                                      Text(
                                        'Incluir números e símbolos especiais',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: showtipoPerfilModal,
                            child: Text(
                              'Tipo de Usuário: ${isSelectedTipo ?? '_______'}',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: SizedBox(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              elevation: 3,
                            ),
                            onPressed: _adicionarUsuario,
                            child: const Text(
                              'Adicionar',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SizedBox(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              elevation: 3,
                            ),
                            onPressed: _limparCampos,
                            child: const Text(
                              'Limpar Dados',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
