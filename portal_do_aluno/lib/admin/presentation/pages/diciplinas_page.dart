import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/navigation/navigation_sevice.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';

class DiciplinasPage extends StatefulWidget {
  const DiciplinasPage({super.key});

  @override
  State<DiciplinasPage> createState() => _DiciplinasPageState();
}

class _DiciplinasPageState extends State<DiciplinasPage> {
  final minhaStream = FirebaseFirestore.instance
      .collection('disciplinas')
      .orderBy('nome')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diciplinas Cadastradas'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              NavigatorService.navigateTo(RouteNames.adminCadastrarDisciplina);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(padding: const EdgeInsets.all(8), child: __buildStream()),
    );
  }

  Widget __buildStream() {
    return StreamBuilder(
      stream: minhaStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar os dados'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Nenhum dado encontrado'));
        }
        final docMaterias = snapshot.data!.docs;
        return ListView.builder(
          itemCount: docMaterias.length,
          itemBuilder: (context, index) {
            final data = docMaterias[index].data();

            return Card(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.book)),
                title: Text('Materia: ${data['nome']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Professor: ${data['professor'] ?? '---'}'),
                    Text('Aulas Previstas: ${data['aulaPrevistas'] ?? '---'}'),
                    Text('Carga Horaria: ${data['cargaHoraria'] ?? '---'}'),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
