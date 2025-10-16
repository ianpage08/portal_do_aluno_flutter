import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StreamDrop extends StatefulWidget {
  final void Function(String id, String nome) onSelected;
  final VoidCallback? onChange;
  final String nomeItem;
  final String mensagemError;
  final String textLabel;
  final Icon icon;
  final Stream<QuerySnapshot<Map<String, dynamic>>> minhaStream;
  const StreamDrop({
    super.key,
    required this.minhaStream,
    required this.onSelected,
    required this.mensagemError,
    required this.textLabel,
    required this.nomeItem,
    required this.icon,
    this.onChange,
  });

  @override
  State<StreamDrop> createState() => _StreamDropState();
}

class _StreamDropState extends State<StreamDrop> {
  String? isSelected;
  String? isId;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: widget.minhaStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Nenhuma turma encontrada'));
        }

        final docs = snapshot.data!.docs;
        if (isId != null && !docs.any((doc) => doc.id == isId)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              isSelected = null;
              isId = null;
            });
          });

          if (widget.onChange == null) {
            widget.onChange!();
          }
        }

        return SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            icon: widget.icon,
            label: Text(
              isSelected ?? widget.textLabel,
              style: const TextStyle(fontSize: 20),
            ),
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
                      return ListTile(
                        title: Text(
                          isSelected != null
                              ? item[widget.nomeItem]
                              : widget.textLabel,
                        ),

                        onTap: () {
                          setState(() {
                            isSelected = item[widget.nomeItem];
                            isId = item.id;
                          });
                          widget.onSelected(isId!, isSelected!);

                          if (widget.onChange == null) {
                            widget.onChange!();
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
