import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/stream_vizualizacao_de_comunicados.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class NoticesPage extends StatefulWidget {
  const NoticesPage({super.key});

  @override
  State<NoticesPage> createState() => _NoticesPageState();
}

class _NoticesPageState extends State<NoticesPage> {
  
  final Stream<QuerySnapshot<Map<String, dynamic>>> comunicadosStream =
      FirebaseFirestore.instance
          .collection('comunicados')
          .where('destinatario', whereIn: ['alunos', 'todos'])
          .snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Comunicados'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamVizualizacaoDeComunicados(
          comunicadosStream: comunicadosStream,
        ),
      ),
    );
  }
}
