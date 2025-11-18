import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:portal_do_aluno/admin/data/firestore_services/entrega_exercicio_service.dart';
import 'package:portal_do_aluno/admin/data/models/entrega_de_atividade.dart';
import 'package:portal_do_aluno/admin/helper/anexo_helper.dart';
import 'package:portal_do_aluno/admin/helper/snack_bar_personalizado.dart';
import 'package:portal_do_aluno/admin/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ExerciciosDetalhesPage extends StatefulWidget {
  final QueryDocumentSnapshot exercicios;
  const ExerciciosDetalhesPage({super.key, required this.exercicios});

  @override
  State<ExerciciosDetalhesPage> createState() => _ExerciciosDetalhesPageState();
}

class _ExerciciosDetalhesPageState extends State<ExerciciosDetalhesPage> {
  bool _isUploading = false;
  final List<XFile> imgSelected = [];
  final EntregaExercicioService _entregaExercicioService =
      EntregaExercicioService();
  Future<String> getAlunoId(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(userId)
        .get();
    return snapshot.data()!['alunoId'];
  }

  Future<void> atualizarStatus(String userId, String exerciciosId) async {
    final statusFeito = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(userId)
        .collection('exercicios_status')
        .doc(exerciciosId);

    await statusFeito.update({
      'status': true,
      'dataDeEntrega': FieldValue.serverTimestamp(),
    });
  }

  Future<void> enviarAtividade(
    String alunoId,
    String exerciciosId,
    List<String> urls,
  ) async {
    final entrega = EntregaDeAtividade(
      alunoId: alunoId,
      exercicioId: exerciciosId,
      dataEntrega: Timestamp.now(),
      anexos: urls,
    );
    try {
      if (urls.isEmpty && mounted) {
        snackBarPersonalizado(
          context: context,
          mensagem: 'Selecione a imagem do exercicios para enviar',
          cor: Colors.orange,
        );
        return;
      }
      await _entregaExercicioService.entregarExercicio(
        exerciciosId: exerciciosId,
        alunoId: alunoId,
        entrega: entrega,
      );
      imgSelected.clear();
    } catch (e) {
      if (mounted) {
        snackBarPersonalizado(
          context: context,
          mensagem: 'Erro ao Enviar',
          cor: Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;
    return Stack(
      children: [
        Scaffold(
          body: Center(
            child: Hero(
              tag: widget.exercicios.id,
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 50,
                    horizontal: 30,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: MediaQuery.of(context).size.height * 0.7,

                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Detalhes do Exercício',
                                style: TextStyle(fontSize: 24),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.close, size: 30),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.exercicios['titulo'],
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Text(
                                widget.exercicios['conteudoDoExercicio'],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2F5DFF),
                                  ),
                                  onPressed: () async {
                                    final imagens = await getImage();
                                    if (imagens.isEmpty) {
                                      return;
                                    }
                                    imgSelected.clear();
                                    imgSelected.addAll(imagens);

                                    if (mounted) {
                                      snackBarPersonalizado(
                                        context: context,
                                        mensagem:
                                            '${imagens.length} imagem(ns) selecionada(s)',
                                        cor: Colors.green,
                                      );
                                    }
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(CupertinoIcons.link),
                                        SizedBox(width: 10),
                                        Text('Anexo'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (imgSelected.isEmpty) {
                                      snackBarPersonalizado(
                                        context: context,
                                        mensagem: 'Nenhuma imagem selecionada',
                                        cor: Colors.orange,
                                      );
                                      return;
                                    }
                                    setState(() {
                                      _isUploading = true;
                                    });
                                    try {
                                      final alunoId = await getAlunoId(userId!);
                                      final exerciciosId = widget.exercicios.id;

                                      final urls = await uploadImagensExercicio(
                                        imgSelected,
                                        exerciciosId,
                                        alunoId,
                                      );
                                      await enviarAtividade(
                                        alunoId,
                                        exerciciosId,
                                        urls,
                                      );
                                      await atualizarStatus(
                                        userId,
                                        exerciciosId,
                                      );

                                      Navigator.pop(context);
                                    } finally {
                                      setState(() {
                                        _isUploading = false;
                                      });
                                    }
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(CupertinoIcons.paperplane),
                                      SizedBox(width: 10),
                                      Text('Enviar'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (_isUploading) buildLoadingOverlay(),
      ],
    );
  }

  Widget buildLoadingOverlay() {
    return Positioned.fill(
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: const Color.fromARGB(120, 0, 0, 0)),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Lottie.asset(
                    'assets/lottie/loading_40 _ paperplane.json',
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
