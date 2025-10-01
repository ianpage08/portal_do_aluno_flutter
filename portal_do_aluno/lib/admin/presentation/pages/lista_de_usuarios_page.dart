import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class ListaDeUsuariosPage extends StatefulWidget {
  const ListaDeUsuariosPage({super.key});

  @override
  State<ListaDeUsuariosPage> createState() => _ListaDeUsuariosPageState();
}

class _ListaDeUsuariosPageState extends State<ListaDeUsuariosPage> {
  final minhaStream = FirebaseFirestore.instance
      .collection('usuarios')
      .snapshots();
  final docUsertype = FirebaseFirestore.instance
      .collection('usuarios')
      .orderBy('type')
      .snapshots();
  bool _isActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Lista de Usuários'),
      body: StreamBuilder<QuerySnapshot>(
        stream: minhaStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar os dados'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Nenhum usuário encontrado'));
          }

          final docUsuarios = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docUsuarios.length,
            itemBuilder: (context, index) {
              final data = docUsuarios[index].data() as Map<String, dynamic>;

              final cpfFormatado = data['cpf'] != null
                  ? data['cpf'].toString().replaceAllMapped(
                      RegExp(r'(\d{3})(\d{3})(\d{3})(\d{2})'),
                      (match) =>
                          '${match[1]}.${match[2]}.${match[3]}-${match[4]}',
                    )
                  : '---';

              return Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(data['name'] ?? 'Sem nome'),
                  subtitle: Text(
                    'CPF: $cpfFormatado - Tipo: ${data['type'] ?? '---'}',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
