import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  final ValueNotifier<bool> _aberto = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.habilitado
          ? () async {
              _aberto.value = true;

              await showModalBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                ),
                builder: (_) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Selecionar ${widget.titulo}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Expanded(
                          child: ListView(
                            children: widget.itens.map((item) {
                              return Card(
                                elevation: 0,
                                color: Colors.grey.shade100,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  leading: Icon(
                                    widget.icon,
                                    color: Colors.deepPurple,
                                  ),
                                  title: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  onTap: () {
                                    widget.onSelected(item);
                                    Navigator.pop(context);
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );

              _aberto.value = false;
            }
          : null,
      child: ValueListenableBuilder(
        valueListenable: _aberto,
        builder: (context, aberto, _) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: widget.habilitado
                  ? Theme.of(context).cardColor
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color.fromARGB(31, 158, 158, 158),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(26, 0, 0, 0),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(widget.icon, size: 22),
                    const SizedBox(width: 12),
                    Text(
                      widget.selecionado ?? widget.titulo,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                AnimatedRotation(
                  turns: aberto ? 0.5 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: const Icon(CupertinoIcons.chevron_down, size: 20),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
