import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/admin/presentation/providers/selected_provider.dart';
import 'package:provider/provider.dart';

class StreamDrop extends StatefulWidget {
  final String dropId; 
  final String textLabel;
  final Icon icon;
  final Stream<QuerySnapshot<Map<String, dynamic>>> minhaStream;
  final String nomeCampo; 
  final String mensagemError; 
  final void Function(String id, String nome)? onSelected;

  const StreamDrop({
    super.key,
    required this.dropId,
    required this.minhaStream,
    required this.textLabel,
    required this.icon,
    required this.nomeCampo,
    required this.mensagemError,
    this.onSelected,
  });

  @override
  State<StreamDrop> createState() => _StreamDropState();
}

class _StreamDropState extends State<StreamDrop> {
  @override
  Widget build(BuildContext context) {
    final selectedProvider = context.watch<SelectedProvider>();
    final displayText =
        selectedProvider.getNome(widget.dropId) ?? widget.textLabel;

    debugPrint(' StreamDrop(${widget.dropId}): displayText = $displayText');

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: widget.minhaStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text(widget.mensagemError));
        }

        final docs = snapshot.data!.docs;

        return SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            icon: widget.icon,
            label: Text(displayText, style: const TextStyle(fontSize: 20)),
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF5921F3),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return ListView(
                    children: docs.map((item) {
                      final nomeItem = item[widget.nomeCampo] ?? '';
                      return ListTile(
                        title: Text(nomeItem),
                        onTap: () {
                          debugPrint(
                            ' StreamDrop(${widget.dropId}): Selecionando $nomeItem (ID: ${item.id})',
                          );

                          
                          context.read<SelectedProvider>().selectItem(
                            widget.dropId, 
                            item.id,
                            nomeItem,
                          );

                          if (widget.onSelected != null) {
                            widget.onSelected!(item.id, nomeItem);
                          }

                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
