import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/stream_vizualizacao_de_comunicados.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class ComunicadosProfessor extends StatefulWidget {
  const ComunicadosProfessor({super.key});

  @override
  State<ComunicadosProfessor> createState() => _ComunicadosProfessorState();
}

class _ComunicadosProfessorState extends State<ComunicadosProfessor> {
  /* Stream que busca a  coleção de comunicados do Firestore
  
   Filtra os documentos da coleção 'comunicados' onde o campo 'destinatario'
   é igual a 'professor' ou 'todos', garantindo que apenas comunicados relevantes
   sejam exibidos para os professor.*/
  final Stream<QuerySnapshot<Map<String, dynamic>>> comunicadosStream =
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
        child: StreamVizualizacaoDeComunicados(
          // Passa o stream de comunicados para o widget de visualização
          comunicadosStream: comunicadosStream,
        ),
      ),
    );
  }
}
