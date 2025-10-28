import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/admin/data/firestore_services/boletim_service.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/scaffold_messeger.dart';

import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class BoletimAddNotaPage extends StatefulWidget {
  const BoletimAddNotaPage({super.key});

  @override
  State<BoletimAddNotaPage> createState() => _BoletimAddNotaPageState();
}

class _BoletimAddNotaPageState extends State<BoletimAddNotaPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _notaController = TextEditingController();

  // IDs e nomes selecionados
  String? turmaId;
  String? turmaNome;

  String? alunoId;
  String? alunoNome;

  String? disciplinaId;
  String? disciplinaNome;

  String? unidadeSelecionada;
  String? tipoDeNota;

  final List<String> unidades = [
    'Unidade 1',
    'Unidade 2',
    'Unidade 3',
    'Unidade 4',
  ];

  final List<String> tiposDeAvaliacao = [
    'Teste',
    'Prova',
    'Trabalho',
    'Nota Extra',
  ];

  // -------- Streams Firestore --------
  Stream<QuerySnapshot<Map<String, dynamic>>> getTurmas() =>
      _firestore.collection('turmas').orderBy('serie').snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> getAlunos(String classId) =>
      _firestore
          .collection('matriculas')
          .where('dadosAcademicos.classId', isEqualTo: classId)
          .snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> getDisciplinas() =>
      _firestore.collection('disciplinas').snapshots();

  // -------- Salvar Nota --------
  Future<void> salvarBoletim() async {
    if (!_formKey.currentState!.validate()) return;

    if (turmaId == null ||
        alunoId == null ||
        disciplinaId == null ||
        unidadeSelecionada == null ||
        tipoDeNota == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos!')),
      );
      return;
    }

    final double nota = double.tryParse(_notaController.text) ?? 0.0;
    final int unidade = int.parse(
      unidadeSelecionada!.split(' ')[1],
    ); // "Unidade 1" → 1
    final String tipo = tipoDeNota!.toLowerCase().replaceAll(
      ' ',
      '',
    ); // "Nota Extra" → "notaextra"

    final boletimService = BoletimService();

    try {
      await boletimService.salvarOuAtualizarNota(
        alunoId: alunoId!,
        matriculaId: turmaId!,
        disciplinaId: disciplinaId!,
        nomeDisciplina: disciplinaNome!,
        unidade: unidade,
        tipo: tipo,
        nota: nota,
      );
      if (mounted) {
        snackBarPersonalizado(
          context: context,
          mensagem: 'Nota salva com sucesso!',
          cor: Colors.green,
        );
      }

      _notaController.clear();
      setState(() {
        unidadeSelecionada = null;
        tipoDeNota = null;
      });
    } catch (e) {
      if (mounted) {
        snackBarPersonalizado(
          context: context,
          mensagem: 'Erro ao salvar nota.',
          cor: Colors.red,
        );
      }
    }
  }

  // -------- Dropdown genérico --------
  Widget streamDropdown({
    required String tipo,
    required String titulo,
    required Stream<QuerySnapshot<Map<String, dynamic>>> stream,
    required String? selecionado,
    required void Function(String id, String nome) onSelected,
    IconData? icon,
    Map<String, String>? camposNome,
    bool habilitado = true,
  }) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;
        if (docs.isEmpty) return Text('Nenhum $tipo encontrado');

        return SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            icon: Icon(
              icon ?? Icons.arrow_drop_down,
              color: habilitado ? Colors.white : Colors.grey[600],
            ),
            label: Text(
              selecionado ?? titulo,
              style: TextStyle(
                fontSize: 16,
                color: habilitado ? Colors.white : Colors.grey[600],
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: habilitado ? Colors.blue : Colors.grey[300],
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: habilitado
                ? () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => ListView(
                        children: docs.map((doc) {
                          final data = doc.data();
                          String nome;
                          String id = doc.id;

                          switch (tipo) {
                            case 'turma':
                              nome =
                                  '${data['serie'] ?? 'Turma sem série'} - ${data['turno'] ?? ''}';
                              if (data.containsKey('classId')) {
                                id = data['classId'];
                              }
                              break;
                            case 'aluno':
                              if (camposNome != null && camposNome.isNotEmpty) {
                                final nivel1 = camposNome.keys.first;
                                final nivel2 = camposNome.values.first;
                                nome =
                                    data[nivel1]?[nivel2] ?? 'Aluno sem nome';
                              } else {
                                nome = 'Aluno sem nome';
                              }
                              break;
                            case 'disciplina':
                              nome =
                                  data['nome'] ??
                                  data['titulo'] ??
                                  'Disciplina sem nome';
                              break;
                            default:
                              nome = 'Sem nome';
                          }

                          return ListTile(
                            title: Text(nome),
                            onTap: () {
                              onSelected(id, nome);
                              Navigator.pop(context);
                            },
                          );
                        }).toList(),
                      ),
                    );
                  }
                : null,
          ),
        );
      },
    );
  }

  // -------- Campo de Nota --------
  Widget campoNota({bool habilitado = true}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _notaController,
        validator: (v) => v == null || v.isEmpty ? 'Digite a nota' : null,
        decoration: InputDecoration(
          labelText: 'Nota',
          hintText: 'Ex: 8.5',
          prefixIcon: const Icon(Icons.grade),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: habilitado ? Colors.white : Colors.grey[200],
        ),
        keyboardType: TextInputType.number,
        enabled: habilitado,
      ),
    );
  }

  // -------- Dropdown para listas fixas --------
  Widget fixedDropdown({
    required List<String> itens,
    required String? selecionado,
    required String titulo,
    required IconData icon,
    required void Function(String valor) onSelected,
    bool habilitado = true,
  }) {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        icon: Icon(icon, color: habilitado ? Colors.white : Colors.grey[600]),
        label: Text(
          selecionado ?? titulo,
          style: TextStyle(
            fontSize: 16,
            color: habilitado ? Colors.white : Colors.grey[600],
          ),
        ),
        style: TextButton.styleFrom(
          backgroundColor: habilitado ? Colors.blue : Colors.grey[300],
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: habilitado
            ? () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => ListView(
                    children: itens.map((e) {
                      return ListTile(
                        title: Text(e),
                        onTap: () {
                          onSelected(e);
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ),
                );
              }
            : null,
      ),
    );
  }

  // -------- Build --------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Boletim'),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        // 🔹 Turma
                        streamDropdown(
                          tipo: 'turma',
                          titulo: 'Selecione uma Turma',
                          stream: getTurmas(),
                          selecionado: turmaNome,
                          icon: Icons.school,
                          onSelected: (id, nome) {
                            setState(() {
                              turmaId = id;
                              turmaNome = nome;
                              alunoId = null;
                              alunoNome = null;
                              disciplinaId = null;
                              disciplinaNome = null;
                              unidadeSelecionada = null;
                              tipoDeNota = null;
                            });
                          },
                          habilitado: true,
                        ),
                        const SizedBox(height: 16),

                        // 🔹 Aluno
                        turmaId != null
                            ? streamDropdown(
                                tipo: 'aluno',
                                titulo: 'Selecione um Aluno',
                                stream: getAlunos(turmaId!),
                                selecionado: alunoNome,
                                icon: Icons.person,
                                camposNome: {'dadosAluno': 'nome'},
                                onSelected: (id, nome) {
                                  setState(() {
                                    alunoId = id;
                                    alunoNome = nome;
                                  });
                                },
                              )
                            : SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        Colors.grey[300], // fundo desabilitado
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Selecione um Aluno',
                                        style: TextStyle(
                                          color: Colors
                                              .grey[600], // texto desabilitado
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                        const SizedBox(height: 16),

                        // 🔹 Disciplina
                        streamDropdown(
                          tipo: 'disciplina',
                          titulo: 'Selecione uma Disciplina',
                          stream: getDisciplinas(),
                          selecionado: disciplinaNome,
                          icon: Icons.book,
                          onSelected: (id, nome) {
                            setState(() {
                              disciplinaId = id;
                              disciplinaNome = nome;
                            });
                          },
                          habilitado: alunoId != null,
                        ),
                        const SizedBox(height: 16),

                        // 🔹 Unidade
                        fixedDropdown(
                          itens: unidades,
                          selecionado: unidadeSelecionada,
                          titulo: 'Selecione uma Unidade',
                          icon: Icons.note_alt,
                          onSelected: (valor) {
                            setState(() {
                              unidadeSelecionada = valor;
                            });
                          },
                          habilitado: disciplinaId != null,
                        ),
                        const SizedBox(height: 16),

                        // 🔹 Tipo de Avaliação
                        fixedDropdown(
                          itens: tiposDeAvaliacao,
                          selecionado: tipoDeNota,
                          titulo: 'Selecione um Tipo de Avaliação',
                          icon: Icons.assignment,
                          onSelected: (valor) {
                            setState(() {
                              tipoDeNota = valor;
                            });
                          },
                          habilitado: unidadeSelecionada != null,
                        ),
                        const SizedBox(height: 16),

                        // 🔹 Nota
                        campoNota(habilitado: tipoDeNota != null),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 🔹 Botão Salvar
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 149, 33, 243),
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.save),
                    label: const Text('Salvar'),
                    onPressed: salvarBoletim,
                  ),
                ),
                const SizedBox(height: 8),

                // 🔹 Botão Limpar
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.clear),
                    label: const Text('Limpar'),
                    onPressed: () {
                      setState(() {
                        turmaId = null;
                        turmaNome = null;
                        alunoId = null;
                        alunoNome = null;
                        disciplinaId = null;
                        disciplinaNome = null;
                        unidadeSelecionada = null;
                        tipoDeNota = null;
                        _notaController.clear();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
