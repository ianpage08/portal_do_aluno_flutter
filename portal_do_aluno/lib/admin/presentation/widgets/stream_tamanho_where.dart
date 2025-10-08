import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StreamContagem extends StatelessWidget {
  final String collectionPath;
  final String? fieldName; // opcional
  final dynamic fieldValue; // opcional
  final Widget Function(BuildContext context,AsyncSnapshot snapshot, int total) builder;

  const StreamContagem({
    super.key,
    required this.collectionPath,
    this.fieldName,
    this.fieldValue,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    Query query = FirebaseFirestore.instance.collection(collectionPath);

    if (fieldName != null && fieldValue != null) {
      query = query.where(fieldName!, isEqualTo: fieldValue);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar os dados'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final total = snapshot.data?.docs.length ?? 0;
        return builder(context,snapshot, total);
      },
    );
  }
}
