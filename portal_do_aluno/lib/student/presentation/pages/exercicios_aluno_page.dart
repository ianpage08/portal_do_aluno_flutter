// --- PAGINA TESTE --- //

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/admin/presentation/providers/user_provider.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/scaffold_messeger.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';
import 'package:provider/provider.dart';

class ExerciciosAlunoPage extends StatefulWidget {
  const ExerciciosAlunoPage({super.key});

  @override
  State<ExerciciosAlunoPage> createState() => _ExerciciosAlunoPageState();
}

class _ExerciciosAlunoPageState extends State<ExerciciosAlunoPage> {
  String? turmaId;
  bool showModal = false;

  Stream<QuerySnapshot> getExerciciosPorTurma(turmaId) {
    return FirebaseFirestore.instance
        .collection('exercicios')
        .where('turmaId', isEqualTo: turmaId)
        .snapshots();
  }

  String limitarTexto(String texto, int limite) {
    if (texto.length > limite) {
      return '${texto.substring(0, limite)}...';
    } else {
      return texto;
    }
  }

  final ValueNotifier<bool> showModalNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserProvider>(context).userId;
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Exercícios',
        nameRoute: RouteNames.studentComunicados,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: StreamBuilder<QuerySnapshot>(
          stream: getExerciciosPorTurma(turmaId),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return AnimatedContainer(
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              child: ListView.builder(
                itemCount: data?.length,
                itemBuilder: (context, index) {
                  final exercicio = data?[index];
                  final titulo = exercicio?['titulo'];
                  final conteudoDoExercicio = exercicio?['conteudoDoExercicio'];

                  return Card(
                    child: ListTile(
                      title: Text(titulo),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(limitarTexto(conteudoDoExercicio, 10)),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(seconds: 1),
                                curve: Curves.easeInOut,
                                child: IconButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Column(
                                          children: [
                                            ListTile(
                                              title: const Text('Instruções'),
                                              subtitle: Text(
                                                conteudoDoExercicio,
                                              ),
                                            ),
                                            const Divider(),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 8,
                                                  ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  ElevatedButton.icon(
                                                    onPressed: () {
                                                      snackBarPersonalizado(
                                                        context: context,
                                                        mensagem:
                                                            'Arquivo anexado com sucesso',
                                                        cor: Colors.green,
                                                      );
                                                    },
                                                    label: const Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 16,
                                                          ),
                                                      child: Text(
                                                        'Anexar arquivo',
                                                      ),
                                                    ),
                                                  ),
                                                  ElevatedButton.icon(
                                                    onPressed: () {
                                                      snackBarPersonalizado(
                                                        context: context,
                                                        mensagem:
                                                            'Exercício concluído com sucesso!',
                                                        cor: Colors.green,
                                                      );
                                                    },
                                                    label: const Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 16,
                                                          ),
                                                      child: Text(
                                                        'Enviar Exercicio',
                                                      ),
                                                    ),
                                                    icon: const Icon(
                                                      Icons.send,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: showModal == true
                                      ? Icon(Icons.arrow_circle_right_outlined)
                                      : Icon(Icons.arrow_circle_down),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
