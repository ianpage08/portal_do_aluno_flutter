import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StreamTamanho extends StatefulWidget {
  final String collectionPath;
  final String documentId;

  final Widget Function(BuildContext context, AsyncSnapshot snapshot, int total)
  builder;
  const StreamTamanho({
    super.key,
    required this.collectionPath,
    required this.builder,
    required this.documentId,
  });

  @override
  State<StreamTamanho> createState() => _StreamTamanhoState();
}

class _StreamTamanhoState extends State<StreamTamanho> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(widget.collectionPath)
          .doc(widget.documentId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar os dados'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final total = snapshot.data?.exists ?? false ? 1 : 0;
        return widget.builder(context, snapshot, total);
      },
    );
  }
}
