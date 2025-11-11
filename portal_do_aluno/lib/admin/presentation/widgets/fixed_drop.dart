import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/app_constants/colors.dart';

class FixedDrop extends StatefulWidget {
  final List<String> itens;
  final String? selecionado;
  final String titulo;
  final IconData icon;
  final void Function(String valor) onSelected;
  final bool habilitado;
  const FixedDrop({
    super.key,
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
      height: 50,
      child: TextButton.icon(
        icon: Icon(
          widget.icon,
          color: widget.habilitado ? Colors.white : Colors.grey[600],
        ),
        label: Text(
          widget.selecionado ?? widget.titulo,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: widget.habilitado ? Colors.white : Colors.grey[600],
          ),
        ),
        style: Theme.of(context).textButtonTheme.style!.copyWith(
          backgroundColor: WidgetStatePropertyAll(
            widget.habilitado
                ? Theme.of(context).primaryColor
                : Colors.grey[300],
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
