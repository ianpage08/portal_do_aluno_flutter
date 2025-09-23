import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class Turma {
  String nome;
  final List<String> materias;
  final String horario;
  final String professor;

  Turma({
    required this.nome,
    required this.materias,
    required this.horario,
    required this.professor,
  });
}

class ClassPage extends StatelessWidget {
  final List<Turma> turmas = [
    Turma(
      nome: 'Turma 1',
      materias: ['Matemática', 'Português', 'História'],
      horario: '10:00 - 12:00',
      professor: 'João Silva',
    ),
    Turma(
      nome: 'Turma 2',
      materias: ['ingles', 'geografia', 'historia'],
      horario: '7:00 - 9:00',
      professor: 'Maria Santos',
    ),
  ];

  ClassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Turmas'),
      body: ListView.builder(
        itemCount: turmas.length,
        itemBuilder: (context, index) {
          final turma = turmas[index];
          return Card(
            child: ListTile(
              title: Text(turma.nome),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Materias: ${turma.materias.join(',')}'),
                  Text('Horário: ${turma.horario}'),
                  Text('Professor: ${turma.professor}'),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {},
              ),
            ),
          );
        },
      ),
    );
  }
}
