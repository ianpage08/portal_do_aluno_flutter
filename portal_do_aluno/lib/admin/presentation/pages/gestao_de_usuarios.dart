/* Cadastrar/editar/excluir professores, alunos e responsáveis.

Reset de senha e permissões.*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portal_do_aluno/admin/data/models/aluno.dart';

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
  final List<String> tipoUsuario = ['Professor', 'Aluno', 'Administrador'];
  String? turmaId;

  Stream<QuerySnapshot<Map<String, dynamic>>> getstreamTurma() {
    return FirebaseFirestore.instance.collection('turmas').snapshots();
  }

  Stream<QuerySnapshot> getAluno(String classId) {
    return FirebaseFirestore.instance
        .collection('matriculas')
        .where('dadosAcademicos.classId', isEqualTo: classId)
        .snapshots();
  }

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

  String? cpfSelecionado;
  String? alunoId;
  String? alunoSelecionado;
  String? turmaSelecionada;

  Widget showStream() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: getstreamTurma(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar turmas'));
        }

        final docsTurma = snapshot.data!.docs;

        return SizedBox(
          width: double.infinity,
          height: 50,
          child: TextButton.icon(
            label: turmaSelecionada != null
                ? Text(turmaSelecionada!)
                : const Text('Selecione uma turma'),
            style: TextButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 128, 37, 247),
              foregroundColor: const Color.fromARGB(255, 255, 232, 232),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
            icon: const Icon(Icons.school),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return ListView(
                    children: docsTurma.map((item) {
                      return ListTile(
                        title: Text(item['serie']),
                        subtitle: Text(item['turno']),
                        onTap: () {
                          turmaSelecionada = item['serie'];
                          setState(() {
                            turmaId = item.id;
                          });
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget showStreamAluno() {
    if (turmaId == null) {
      return const SizedBox();
    }

    return StreamBuilder<QuerySnapshot>(
      stream: getAluno(turmaId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar alunos'));
        }
        final docsAluno = snapshot.data!.docs;

        return SizedBox(
          width: double.infinity,
          height: 50,
          child: TextButton.icon(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return ListView(
                    children: docsAluno.map((docAluno) {
                      final dadosAluno = DadosAluno.fromJson(
                        docAluno['dadosAluno'],
                      );
                      return ListTile(
                        title: Text(dadosAluno.nome),
                        onTap: () {
                          setState(() {
                            alunoId = dadosAluno.id;
                            alunoSelecionado = dadosAluno.nome;
                            cpfSelecionado = dadosAluno.cpf;
                          });
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  );
                },
              );
            },
            label: alunoSelecionado != null
                ? Text(alunoSelecionado!)
                : const Text('Selecione um aluno'),
            style: TextButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 128, 37, 247),
              foregroundColor: const Color.fromARGB(255, 224, 223, 214),
            ),
            icon: const Icon(Icons.person),
          ),
        );
      },
    );
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

      cpfSelecionado = null;
      turmaSelecionada = null;
      turmaId = null;
      alunoId = null;
      alunoSelecionado = null;
    });
  }

  Widget _professorcadastro() {
    return Column(
      children: [
        TextFormField(
          controller: nomeController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            prefixIcon: const Icon(Icons.person),
            labelText: 'Nome',
            hintText: 'Leila Miranda Maciel',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: (value) =>
              value == null || value.isEmpty ? 'Digite o nome' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: cpfController,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            CpfInputFormatter(),
          ],
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            prefixIcon: const Icon(Icons.document_scanner),
            labelText: 'CPF',
            hintText: '853.654.895-59',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: (value) =>
              value == null || value.isEmpty ? 'Digite o Cpf' : null,
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _administradorcadastro() {
    return Column(
      children: [
        TextFormField(
          controller: nomeController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            prefixIcon: const Icon(Icons.person),
            labelText: 'Nome',
            hintText: 'Leila Miranda Maciel',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: (value) =>
              value == null || value.isEmpty ? 'Digite o nome' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: cpfController,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            CpfInputFormatter(),
          ],
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            prefixIcon: const Icon(Icons.document_scanner),
            labelText: 'CPF',
            hintText: '853.654.895-59',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: (value) =>
              value == null || value.isEmpty ? 'Digite o Cpf' : null,
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  void _adicionarUsuario() async {
    if (_formKey.currentState!.validate()) {
      final nome = nomeController.text.trim();
      final senha = senhaController.text.trim();
      final confirmarSenha = confirmarSenhaController.text.trim();
      final cpf = cpfController.text.replaceAll(RegExp(r'[^0-9]'), '');
      if (isSelectedTipo == 'Aluno' &&
          (alunoId == null || alunoSelecionado == null)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selecione turma e aluno antes de cadastrar'),
          ),
        );
      }
      if (isSelectedTipo == 'Professor' &&
          (nomeController.text.isEmpty || cpfController.text.isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Preencha nome e CPF do professor')),
        );
        return;
      }
      if (isSelectedTipo == 'Aluno' &&
          (cpfSelecionado == null || cpfSelecionado!.isEmpty) &&
          alunoId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selecione o aluno antes de cadastrar.'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      if (senha.isNotEmpty &&
          confirmarSenha.isNotEmpty &&
          cpf.isNotEmpty &&
          nome.isNotEmpty) {
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
          turmaId: turmaId ?? '',
          alunoId: alunoId ?? '',
          name: alunoSelecionado ?? nome,
          cpf: cpfSelecionado ?? cpf,
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
      body: SingleChildScrollView(
        child: Padding(
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
                          const SizedBox(height: 12),

                          SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
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
                          const SizedBox(height: 12),
                          Column(
                            children: [
                              if (isSelectedTipo == 'Aluno') ...[
                                showStream(),
                                const SizedBox(height: 12),
                                showStreamAluno(),
                                const SizedBox(height: 12),
                              ],

                              if (isSelectedTipo == 'Professor') ...[
                                _professorcadastro(),
                              ],
                              if (isSelectedTipo == 'Administrador') ...[
                                _administradorcadastro(),
                              ],
                            ],
                          ),

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
                                    leading: Icon(
                                      Icons.info,
                                      color: Colors.blue,
                                    ),
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
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
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
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
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
      ),
    );
  }
}
