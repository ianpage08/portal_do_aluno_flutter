import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class ComunicadosProfessor extends StatefulWidget {
  const ComunicadosProfessor({super.key});

  @override
  State<ComunicadosProfessor> createState() => _ComunicadosProfessorState();
}

class _ComunicadosProfessorState extends State<ComunicadosProfessor> {
  Stream<QuerySnapshot<Map<String, dynamic>>> comunicadosStream =
      FirebaseFirestore.instance
          .collection('comunicados')
          .where('destinatario', whereIn: ['professores', 'todos'])
          .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Comunicados'),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: comunicadosStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            }
            final comunicado = snapshot.data!.docs;

            return ListView.builder(
              itemCount: comunicado.length,
              itemBuilder: (context, index) {
                final comunicadoDoc = comunicado[index];
                final titulo = comunicadoDoc['titulo'] ?? 'Sem título';
                final dataPublicacao =
                    (comunicadoDoc['dataPublicacao'] as Timestamp).toDate();
                final dataFormatada =
                    '${dataPublicacao.day}/${dataPublicacao.month}/${dataPublicacao.year}';
                final descricao = comunicadoDoc['mensagem'] ?? 'Sem descrição';

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.message,
                      color: Colors.deepPurpleAccent[200],
                    ),
                    title: Text(titulo, style: const TextStyle(fontSize: 20)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(descricao),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [Text(dataFormatada)],
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
}
