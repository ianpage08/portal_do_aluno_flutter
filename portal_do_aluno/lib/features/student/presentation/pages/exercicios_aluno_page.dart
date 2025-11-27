// --- PAGINA TESTE --- //

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/presentation/providers/user_provider.dart';

import 'package:portal_do_aluno/navigation/route_names.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';
import 'package:portal_do_aluno/features/student/presentation/pages/exercicios_detalhes_page.dart';
import 'package:provider/provider.dart';

class ExerciciosAlunoPage extends StatefulWidget {
  const ExerciciosAlunoPage({super.key});

  @override
  State<ExerciciosAlunoPage> createState() => _ExerciciosAlunoPageState();
}

class _ExerciciosAlunoPageState extends State<ExerciciosAlunoPage> {
  String? turmaId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (turmaId == null) {
      buscarAlunoPorTurma();
    }
  }

  Stream<QuerySnapshot> getExerciciosPorTurma(String turmaId) {
    return FirebaseFirestore.instance
        .collection('exercicios')
        .where('turmaId', isEqualTo: turmaId)
        .snapshots();
  }

  Future<bool> getStatusEntregue(String userId, String exerciciosId) async {
    final doc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(userId)
        .collection('exercicios_status')
        .doc(exerciciosId)
        .get();
    if (!doc.exists) {
      return false;
    }

    return doc.data()?['status'] == true;
  }

  void buscarAlunoPorTurma() async {
    final userId = Provider.of<UserProvider>(context).userId;

    final snapshort = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(userId)
        .get();
    debugPrint(userId);
    debugPrint(snapshort.data().toString());
    setState(() {
      turmaId = snapshort.data()?['turmaId'];
    });
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
    if (turmaId == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Exercícios',
        nameRoute: RouteNames.studentComunicados,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: StreamBuilder<QuerySnapshot>(
          stream: getExerciciosPorTurma(turmaId!),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              itemCount: data?.length,
              itemBuilder: (context, index) {
                final exercicio = data?[index];
                final titulo = exercicio?['titulo'];
                final conteudoDoExercicio = exercicio?['conteudoDoExercicio'];
                final nomeProfessor = exercicio?['nomeDoProfessor'];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 500),
                        pageBuilder: (context, animation, secundaryAnimation) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1, 0),
                              end: Offset.zero,
                            ).animate(animation),

                            child: ExerciciosDetalhesPage(
                              exercicios: exercicio,
                            ),
                          );
                        },
                      ),
                    ).then((_) {
                      setState(() {});
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Hero(
                            tag: exercicio!.id,

                            child: Material(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(
                                    255,
                                    109,
                                    87,
                                    116,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: cardExecicio(
                                  titulo,
                                  conteudoDoExercicio,
                                  nomeProfessor,
                                  userId!,
                                  exercicio.id,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget cardExecicio(
    String titulo,
    String conteudo,
    String nomeProfessor,
    String userId,
    String exerciciosId,
  ) {
    return FutureBuilder<bool>(
      future: getStatusEntregue(userId, exerciciosId),
      builder: (context, snapshot) {
        final status = snapshot.data ?? false;
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(55, 88, 87, 87)),
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).cardTheme.color,
          ),
          height: 82,

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        limitarTexto('Exercicio de: $titulo', 30),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(limitarTexto(conteudo, 30)),
                      Text('Professor: $nomeProfessor'),
                    ],
                  ),
                ),
              ),
              Container(
                height: 100,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  color: status == true
                      ? Colors.green
                      : const Color.fromARGB(255, 26, 110, 236),
                ),

                child: Icon(
                  status == true
                      ? CupertinoIcons.check_mark
                      : CupertinoIcons.arrow_right,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
