import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MeuStreamBuilder extends StatefulWidget {
  final String collectionPath;
  final String documentId;
  final Widget Function(
    BuildContext context,
    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,
  )
  builder;

  const MeuStreamBuilder({
    super.key,
    required this.collectionPath,
    required this.documentId,
    required this.builder,
  });

  @override
  State<MeuStreamBuilder> createState() => _MeuStreamBuilderState();
}

class _MeuStreamBuilderState extends State<MeuStreamBuilder> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection(widget.collectionPath)
          .doc(widget.documentId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar os dados'));
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text('Documento não encontrado'));
        }
        return widget.builder(context, snapshot);
      },
    );
  }
}
