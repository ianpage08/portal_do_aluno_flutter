import 'package:flutter/material.dart';

class FixedDrop extends StatefulWidget {
  final List<String> itens;
  final String? selecionado;
  final String titulo;
  final IconData icon;
  final void Function(String valor) onSelected;
  final bool habilitado;
  const FixedDrop({super.key,
    required this.itens,
    required this.selecionado,
    required this.titulo,
    required this.icon,
    required this.onSelected,
    this.habilitado = true,
  });

  @override
  State<FixedDrop> createState() => _FixedDropState();
}

class _FixedDropState extends State<FixedDrop> {
  @override
  Widget build(BuildContext context) {
    
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        icon: Icon(widget.icon, color: widget.habilitado ? Colors.white : Colors.grey[600]),
        label: Text(
          widget.selecionado ?? widget.titulo,
          style: TextStyle(
            fontSize: 16,
            color: widget.habilitado ? Colors.white : Colors.grey[600],
          ),
        ),
        style: TextButton.styleFrom(
          backgroundColor: widget.habilitado ? Colors.blue : Colors.grey[300],
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: widget.habilitado
            ? () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => ListView(
                    children: widget.itens.map((e) {
                      return ListTile(
                        title: Text(e),
                        onTap: () {
                          widget.onSelected(e);
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ),
                );
              }
            : null,
      ),
    );
  }
  }
