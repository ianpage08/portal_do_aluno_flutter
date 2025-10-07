import 'package:flutter/material.dart';
import 'package:portal_do_aluno/navigation/navigation_sevice.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MenuPontinho extends StatefulWidget {
  final String alunoId;

  const MenuPontinho({super.key, required this.alunoId});

  @override
  State<MenuPontinho> createState() => _MenuPontinhoState();
}

class _MenuPontinhoState extends State<MenuPontinho> {
  final CollectionReference matriculasCollection =
      FirebaseFirestore.instance.collection('matriculas');

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) async {
        if (value == 'detalhes') {
          NavigatorService.navigateTo(RouteNames.adminDetalhesAlunos,
              arguments: widget.alunoId);
        } else if (value == 'excluir') {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Confirmar exclusão'),
              content: const Text('Deseja realmente excluir este aluno?'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancelar')),
                TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Excluir')),
              ],
            ),
          );

          if (confirm == true) {
            try {
              await matriculasCollection.doc(widget.alunoId).delete();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Aluno excluído com sucesso'),
                    backgroundColor: Colors.red),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Erro ao excluir: $e'),
                    backgroundColor: Colors.red),
              );
            }
          }
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'detalhes', child: Text('Detalhes')),
        const PopupMenuItem(value: 'excluir', child: Text('Excluir')),
      ],
    );
  }
}
