import 'package:flutter/material.dart';

class DiciplinasPage extends StatefulWidget {
  const DiciplinasPage({super.key});

  @override
  State<DiciplinasPage> createState() => _DiciplinasPageState();
}

class _DiciplinasPageState extends State<DiciplinasPage> {
  final List<Map<String, dynamic>> materias = [
    {'materia': 'Português', 'professor': 'Paulo José', 'total': 240},
    {'materia': 'Ingles', 'professor': 'Messi', 'total': 70},
    {'materia': 'Matemática', 'professor': 'Lanvadovisk', 'total': 189},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diciplinas Cadastradas'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Adicionar Materias')));
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: materias.length,
          itemBuilder: (context, index) {
            final materia = materias[index];
            return Card(
              child: ListTile(
                leading:const CircleAvatar(child:  Icon(Icons.book)),
                title: Text('Materia: ${materia['materia']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Professor: ${materia['professor']}'),
                    Text('Aulas Previstas: ${materia['total']}'),
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
