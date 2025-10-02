import 'package:flutter/material.dart';
import 'package:portal_do_aluno/navigation/navigation_sevice.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';

class TurmaPage extends StatefulWidget {
  const TurmaPage({super.key});

  @override
  State<TurmaPage> createState() => _TurmaPageState();
}

class _TurmaPageState extends State<TurmaPage> {
  final List<Map<String, dynamic>> turmas = [
    {
      'nome': '9º Ano A',
      'serie': '9º Ano',
      'turno': 'Matutino',
      'alunos': 25,
      'professor': 'Maria Silva',
    },
    {
      'nome': '9º Ano B',
      'serie': '9º Ano',
      'turno': 'Vespertino',
      'alunos': 28,
      'professor': 'João Santos',
    },
    {
      'nome': '8º Ano A',
      'serie': '8º Ano',
      'turno': 'Matutino',
      'alunos': 30,
      'professor': 'Ana Costa',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Turmas'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              NavigatorService.navigateTo(RouteNames.adminCadastroTurmas);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: turmas.length,
          itemBuilder: (context, index) {
            final turma = turmas[index];

            return Card(
              elevation: 2,
              child: ListTile(
                leading: CircleAvatar(child: Text(turma['nome'][0])),
                title: Text(turma['nome']),
                subtitle: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Turno: ${turma['turno']}'),
                        Text('Alunos: ${turma['alunos']}'),
                      ],
                    ),
                    Row(
                      children: [Text('Professor(es): ${turma['professor']}')],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
