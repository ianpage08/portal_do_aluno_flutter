import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MenuPontinhoGenerico extends StatefulWidget {
  final String? id;
  final List<MenuItemConfig> items;

  const MenuPontinhoGenerico({super.key, this.id, required this.items});

  @override
  State<MenuPontinhoGenerico> createState() => _MenuPontinhoGenericoState();
}

class _MenuPontinhoGenericoState extends State<MenuPontinhoGenerico> {
  final CollectionReference matriculasCollection = FirebaseFirestore.instance
      .collection('matriculas');

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) async {
        final itemSelecionado = widget.items.firstWhere(
          (i) => i.value == value,
        );
        itemSelecionado.onSelected(widget.id, context, itemSelecionado.extra);
      },
      itemBuilder: (context) {
        return widget.items.map((item) {
          return PopupMenuItem<String>(
            value: item.value,
            child: Text(item.label),
          );
        }).toList();
      },
    );
  }
}

typedef MenuAction =
    void Function(String? id, BuildContext context, dynamic extra);

class MenuItemConfig {
  final String value;
  final String label;
  final MenuAction onSelected;
  final dynamic extra;
  const MenuItemConfig({
    required this.value,
    required this.label,
    required this.onSelected,
    this.extra,
  });
}
