import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portal_do_aluno/admin/helper/form_helper.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/scaffold_messeger.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/text_form_field.dart';

import 'package:portal_do_aluno/admin/presentation/widgets/widget_value_notifier/botao_selecionar_aluno.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/widget_value_notifier/botao_selecionar_turma.dart';

import 'package:portal_do_aluno/core/utils/cpf_input_fomatado.dart';
import 'package:portal_do_aluno/core/user/user.dart';
import 'package:portal_do_aluno/features/auth/data/datasouces/cadastro_service.dart';

/// Página para adicionar um novo usuário no sistema.
/// Pode ser professor, aluno ou administrador.
class AddUsuarioPage extends StatefulWidget {
  const AddUsuarioPage({super.key});

  @override
  State<AddUsuarioPage> createState() => _AddUsuarioPageState();
}

class _AddUsuarioPageState extends State<AddUsuarioPage> {
  // Controllers para os campos de texto do formulário.
  final Map<String, TextEditingController> _mapController = {
    'nome': TextEditingController(),
    'senha': TextEditingController(),
    'confirmarSenha': TextEditingController(),
    'cpf': TextEditingController(),
  };
  List<TextEditingController> get _allControllers =>
      _mapController.values.toList();

  // Controladores obrigatórios para validação
  List<TextEditingController> get controllersObrigatorios => [
    _mapController['senha']!,
    _mapController['confirmarSenha']!,
  ];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Estado que guarda o tipo de usuário selecionado.
  String? isSelectedTipo;

  // Stream para obter turmas do Firestore.
  Stream<QuerySnapshot<Map<String, dynamic>>> getstreamTurma() {
    return FirebaseFirestore.instance.collection('turmas').snapshots();
  }

  // Stream para obter alunos da turma selecionada.
  Stream<QuerySnapshot> getAluno(String classId) {
    return FirebaseFirestore.instance
        .collection('matriculas')
        .where('dadosAcademicos.classId', isEqualTo: classId)
        .snapshots();
  }

  // Map que mantém ValueNotifiers para seleção dinâmica.
  final Map<String, ValueNotifier<String?>> _mapValueNotifier = {
    'alunoSelecionado': ValueNotifier<String?>(null),
    'turmaSelecionada': ValueNotifier<String?>(null),
  };

  // Variáveis que armazenam dados selecionados.
  String? turmaId;
  String? cpfSelecionado;
  String? alunoId;
  String? nomeAluno;

  // Controle para visibilidade da senha no formulário.
  bool isPasswordVisible = false;

  // Conversão de tipo de usuário string para enum UserType.
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

  @override
  void dispose() {
    // Liberar recursos dos controllers para evitar vazamento de memória
    for (var controller in _mapController.values) {
      controller.dispose();
    }
    super.dispose();
  }

  /// Exibe modal para seleção do tipo de usuário
  void showtipoPerfilModal() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      context: context,
      builder: (context) {
        return ListView(
          children: ['Professor', 'Aluno', 'Administrador'].map((tipo) {
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

  /// Limpa os campos e variáveis selecionadas no formulário
  void _limparCampos() {
    setState(() {
      isSelectedTipo = null;
      turmaId = null;
      cpfSelecionado = null;
      alunoId = null;
      nomeAluno = null;

      // Resetar valores nos ValueNotifiers para atualizar UI
      _mapValueNotifier['alunoSelecionado']!.value = null;
      _mapValueNotifier['turmaSelecionada']!.value = null;

      // Limpar campos de texto
      for (var controller in _allControllers) {
        controller.clear();
      }
    });
  }

  /// Widget para campos de cadastro do professor
  /// O parâmetro [enabled] controla se os campos podem ser editados ou não
  Widget _professorcadastro({required bool enabled}) {
    return Column(
      children: [
        TextFormField(
          controller: _mapController['nome']!,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            prefixIcon: const Icon(Icons.person),
            labelText: 'Nome',
            hintText: 'Leila Miranda Maciel',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          enabled: enabled,
          validator: (value) =>
              value == null || value.isEmpty ? 'Digite o nome' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _mapController['cpf']!,
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
          enabled: enabled,
          validator: (value) =>
              value == null || value.isEmpty ? 'Digite o Cpf' : null,
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  /// Widget para campos de cadastro do administrador
  /// Similar ao professor, com controle de habilitação [enabled]
  Widget _administradorcadastro({required bool enabled}) {
    return Column(
      children: [
        TextFormField(
          controller: _mapController['nome']!,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            prefixIcon: const Icon(Icons.person),
            labelText: 'Nome',
            hintText: 'Leila Miranda Maciel',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          enabled: enabled,
          validator: (value) =>
              value == null || value.isEmpty ? 'Digite o nome' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _mapController['cpf']!,
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
          enabled: enabled,
          validator: (value) =>
              value == null || value.isEmpty ? 'Digite o Cpf' : null,
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  /// Método para adicionar um usuário ao banco de dados
  /// Faz validações e interage com o serviço de cadastro
  void _adicionarUsuario() async {
    if (FormHelper.isFormValid(
      formKey: _formKey,
      listControllers: controllersObrigatorios,
    )) {
      final nome = _mapController['nome']!.text.trim();
      final senha = _mapController['senha']!.text.trim();
      final confirmarSenha = _mapController['confirmarSenha']!.text.trim();
      final cpf = _mapController['cpf']!.text.replaceAll(RegExp(r'[^0-9]'), '');

      // Validações específicas para tipo Aluno
      if (isSelectedTipo == 'Aluno' && (alunoId == null || nomeAluno == null)) {
        snackBarPersonalizado(
          context: context,
          mensagem: 'Selecione um aluno antes de cadastrar.',
          cor: Colors.orange,
        );
        return;
      }

      // Validação para professor
      if (isSelectedTipo == 'Professor' &&
          (_mapController['nome']!.text.isEmpty ||
              _mapController['cpf']!.text.isEmpty)) {
        snackBarPersonalizado(
          context: context,
          mensagem: 'Preencha todos os campos antes de cadastrar.',
          cor: Colors.orange,
        );
        return;
      }

      // Continuação se todos os campos de senha, cpf e nome estiverem preenchidos
      if (senha.isNotEmpty &&
          confirmarSenha.isNotEmpty &&
          (cpf.isNotEmpty || cpfSelecionado != null) &&
          (nome.isNotEmpty || nomeAluno != null)) {
        // Verificação para CPF duplicado no Firestore
        final verificarCpf = await FirebaseFirestore.instance
            .collection('usuarios')
            .where('cpf', isEqualTo: cpf)
            .get();

        if (verificarCpf.docs.isNotEmpty) {
          if (mounted) {
            snackBarPersonalizado(
              context: context,
              mensagem: 'CPF já cadastrado no sistema.',
              cor: Colors.red,
            );
          }
          return;
        }

        // Criar novo objeto Usuario para salvar
        final novoUsuario = Usuario(
          id: '',
          turmaId: turmaId ?? '',
          alunoId: alunoId ?? '',
          name: nomeAluno ?? nome,
          cpf: cpfSelecionado ?? cpf,
          password: senha,
          type: _mapTipo(isSelectedTipo),
        );

        try {
          await CadastroService().cadastroUsuario(novoUsuario);

          // Feedback visual para usuário
          if (mounted) {
            snackBarPersonalizado(
              context: context,
              mensagem: 'Usuário cadastrado com sucesso! 🎉',
              cor: Colors.green,
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
      appBar: AppBar(
        title: const Text('Cadastrar Usuário'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
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
                    // Formulário que agrupa os campos de entrada e validação
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 12),

                          // Botão para selecionar o tipo de usuário
                          SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
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
                                isSelectedTipo ?? 'Selecione o tipo de usuário',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Coluna que exibe widgets de seleção dinâmicos conforme o tipo
                          Column(
                            children: [
                              // Se for aluno: seleção de turma e aluno (widgets podem ser extraídos)
                              if (isSelectedTipo == 'Aluno') ...[
                                BotaoSelecionarTurma(
                                  turmaSelecionada:
                                      _mapValueNotifier['turmaSelecionada']!,
                                  onTurmaSelecionada: (id, nomeCompleto) {
                                    setState(() {
                                      turmaId = id;
                                    });
                                    debugPrint(
                                      'Turma ID selecionada: $turmaId',
                                    );
                                  },
                                ),
                                const SizedBox(height: 12),
                                if (turmaId != null)
                                  BotaoSelecionarAluno(
                                    alunoSelecionado:
                                        _mapValueNotifier['alunoSelecionado']!,
                                    turmaId: turmaId,
                                    onAlunoSelecionado: (id, nomeCompleto, cpf) {
                                      alunoId = id;
                                      cpfSelecionado = cpf;
                                      nomeAluno = nomeCompleto;
                                      debugPrint(
                                        'Nome do Aluno selecionado: $nomeAluno',
                                      );
                                      debugPrint(
                                        'Aluno ID selecionado: $alunoId',
                                      );
                                      debugPrint(
                                        'Aluno CPF selecionado: $cpfSelecionado',
                                      );
                                    },
                                  ),
                                const SizedBox(height: 12),
                              ],

                              // Se for professor, exibe campos específicos (função já isolada)
                              if (isSelectedTipo == 'Professor') ...[
                                _professorcadastro(
                                  enabled: isSelectedTipo == 'Professor',
                                ),
                              ],

                              // Se for administrador, exibe campos específicos (função já isolada)
                              if (isSelectedTipo == 'Administrador') ...[
                                _administradorcadastro(
                                  enabled: isSelectedTipo == 'Administrador',
                                ),
                              ],
                            ],
                          ),

                          // Campos para senha e confirmação de senha
                          TextFormFieldPersonalizado(
                            controller: _mapController['senha']!,
                            obscureText: !isPasswordVisible,

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
                            label: 'Senha',

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

                          TextFormFieldPersonalizado(
                            controller: _mapController['confirmarSenha']!,
                            obscureText: !isPasswordVisible,

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
                            label: 'Confirmar Senha',

                            validator: (value) {
                              if (value != _mapController['senha']!.text) {
                                return 'Senhas não coincidem';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),

                          // Card com dicas para criar senha segura
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

                    // Linha com botões para adicionar usuário ou limpar dados
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
