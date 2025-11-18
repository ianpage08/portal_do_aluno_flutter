import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/admin/data/firestore_services/entrega_exercicio_service.dart';
import 'package:portal_do_aluno/admin/data/models/entrega_de_atividade.dart';
import 'package:portal_do_aluno/admin/helper/anexo_helper.dart';
import 'package:portal_do_aluno/admin/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ExerciciosDetalhesPage extends StatefulWidget {
  final QueryDocumentSnapshot exercicios;
  const ExerciciosDetalhesPage({super.key, required this.exercicios});

  @override
  State<ExerciciosDetalhesPage> createState() => _ExerciciosDetalhesPageState();
}

class _ExerciciosDetalhesPageState extends State<ExerciciosDetalhesPage> {
  final EntregaExercicioService _entregaExercicioService =
      EntregaExercicioService();
  Future<void> getAlunoId() async {
    final userId = Provider.of<UserProvider>(context).userId;
    final snapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(userId)
        .get();
    return snapshot.data()!['alunoId'];
  }

  Future<void> enviarAtividade(String alunoId, String exerciciosId) async {
    final entrega = EntregaDeAtividade(
      alunoId: alunoId,
      exercicioId: exerciciosId,
      dataEntrega: Timestamp.now(),
      anexos: []
      );
    await _entregaExercicioService.entregarExercicio(
      exerciciosId:  exerciciosId,
      alunoId:  alunoId,
      entrega: entrega,
    

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: widget.exercicios.id,
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
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
                          child: Text(widget.exercicios['conteudoDoExercicio']),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                await getImage();
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                              onPressed: () {},
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
    );
  }
}
