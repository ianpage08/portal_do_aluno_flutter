import 'package:flutter/material.dart';

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
  @override
  void initState() {
    super.initState();
    dataSelecionada = widget.isSelecionada;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: Theme.of(context).elevatedButtonTheme.style!,
        onPressed: () async {
          final DateTime? data = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2025),
            lastDate: DateTime(2030),
          );
          if (data != null) {
            setState(() {
              dataSelecionada = data;
            });
            widget.onDate(dataSelecionada); //avisa o pai tipo um callback
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calendar_today, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              dataSelecionada != null
                  ? '${dataSelecionada!.day}/${dataSelecionada!.month}/${dataSelecionada!.year}'
                  : 'Selecionar Data',
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
