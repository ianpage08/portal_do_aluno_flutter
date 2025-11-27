import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/app_constants/colors.dart';

class DataPickerCalendario extends StatefulWidget {
  final DateTime? isSelecionada;
  final Function(DateTime? data) onDate;

  const DataPickerCalendario({
    super.key,
    this.isSelecionada,
    required this.onDate,
  });

  @override
  State<DataPickerCalendario> createState() => _DataPickerCalendarioState();
}

class _DataPickerCalendarioState extends State<DataPickerCalendario> {
  late DateTime? dataSelecionada;
  final ValueNotifier<bool> _aberto = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    dataSelecionada = widget.isSelecionada;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _aberto,
      builder: (context, aberto, _) {
        return GestureDetector(
          onTap: () async {
            _aberto.value = true;

            final DateTime? data = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2025),
              lastDate: DateTime(2030),
            );

            if (data != null) {
              setState(() => dataSelecionada = data);
              widget.onDate(dataSelecionada);
            }

            _aberto.value = false;
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
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
                    const Icon(CupertinoIcons.calendar, size: 22),
                    const SizedBox(width: 12),
                    Text(
                      dataSelecionada != null
                          ? '${dataSelecionada!.day}/${dataSelecionada!.month}/${dataSelecionada!.year}'
                          : 'Selecionar Data',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                // Ícone com animação igual do BotaoSelecionarTurma
                AnimatedRotation(
                  turns: aberto ? 0.5 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: const Icon(CupertinoIcons.chevron_down, size: 20),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
