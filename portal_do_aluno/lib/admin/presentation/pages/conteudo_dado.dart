import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/admin/data/firestore_services/conteudo_service.dart';
import 'package:portal_do_aluno/admin/data/models/conteudo_presenca.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/data_picker_calendario.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/scaffold_messeger.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/stream_drop.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class OqueFoiDado extends StatefulWidget {
  const OqueFoiDado({super.key});

  @override
  State<OqueFoiDado> createState() => _OqueFoiDadoState();
}

class _OqueFoiDadoState extends State<OqueFoiDado> {
  final TextEditingController _conteudoMinistradoController =
      TextEditingController();
  final TextEditingController _observacoesController = TextEditingController();
  String? turmaSelecionada;
  String? turmaId;
  DateTime? dataSelecionada;
  String? disciplinaSelecionada;
  String? disciplinaId;
  bool isLoading = false;

  final ConteudoPresencaService _conteudoPresencaService =
      ConteudoPresencaService();
  Stream<QuerySnapshot<Map<String, dynamic>>> getTurma() {
    return FirebaseFirestore.instance.collection('turmas').snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getDisciplinas() {
    return FirebaseFirestore.instance.collection('disciplinas').snapshots();
  }

  Future<void> salvarconteudo() async {
    if (turmaId == null ||
        disciplinaId == null ||
        dataSelecionada == null ||
        _conteudoMinistradoController.text.isEmpty) {
      snackBarPersonalizado(
        context: context,
        mensagem: 'Preencha todos os campos',
        cor: Colors.redAccent,
      );
      return;
    }

    final novoVinculo = ConteudoPresenca(
      id: '',
      classId: turmaId!,
      conteudo: _conteudoMinistradoController.text,
      data: dataSelecionada!,
      observacoes: _observacoesController.text,
    );

    try {
      await _conteudoPresencaService.cadastrarPresencaConteudoProfessor(
        conteudoPresenca: novoVinculo,
        turmaId: turmaId!,
      );
      if (mounted) {
        snackBarPersonalizado(
          context: context,
          mensagem: 'Conteúdo ministrado salvo com sucesso!',
          cor: Colors.green,
        );
      }

      // Limpar campos
      _conteudoMinistradoController.clear();
      _observacoesController.clear();
    } catch (e) {
      if (mounted) {
        snackBarPersonalizado(
          context: context,
          mensagem: 'Erro ao salvar o conteúdo: $e',
          cor: Colors.redAccent,
        );
      }
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Conteúdo dado'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      StreamDrop(
                        minhaStream: getTurma(),
                        mensagemError: 'Nenhuma Turma Encontrada',
                        textLabel: 'Selecione uma turma',
                        nomeItem: 'serie',
                        icon: const Icon(Icons.school),
                        onChange: () {},
                        onSelected: (id, nome) {
                          setState(() {
                            turmaSelecionada = nome;
                            turmaId = id;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      StreamDrop(
                        minhaStream: getDisciplinas(),
                        mensagemError: 'Nenhuma Disciplina Encontrada',
                        textLabel: 'Selecione uma Disciplina',
                        nomeItem: 'nome',
                        icon: const Icon(Icons.note),
                        onSelected: (id, nome) {
                          setState(() {
                            disciplinaSelecionada = nome;
                            disciplinaId = id;

                            if (disciplinaSelecionada == null) {
                              nome = 'Selecione uma disciplina';
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      DataPickerCalendario(
                        onDate: (data) {
                          setState(() {
                            dataSelecionada = data;
                          });
                        },
                      ),

                      const SizedBox(height: 20),
                      Form(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _conteudoMinistradoController,
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              maxLines: 20,
                              decoration: InputDecoration(
                                label: const Text(
                                  'Conteúdo Ministrado em Aula',
                                ),
                                hintText:
                                    'Ex: “Revisão de equações do 1º grau e introdução a inequações”',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: const Color.fromARGB(15, 72, 1, 204),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _observacoesController,
                              minLines: 1,
                              maxLines: 20,
                              decoration: InputDecoration(
                                label: const Text('Observações'),
                                hintText:
                                    'Ex: 1- O que ficou pendente pra próxima aula. 2- Materiais que precisam ser preparados',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: const Color.fromARGB(15, 72, 1, 204),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                icon: isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(Icons.save),
                                label: isLoading
                                    ? const Text('Salvando...')
                                    : const Text('Salvar'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF5921F3),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: isLoading
                                    ? null
                                    : () async {
                                        setState(() => isLoading = true);
                                        await salvarconteudo();
                                        setState(() => isLoading = false);
                                      },
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Lista de conteúdos já cadastrados
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
      ),
    );
  }
}
