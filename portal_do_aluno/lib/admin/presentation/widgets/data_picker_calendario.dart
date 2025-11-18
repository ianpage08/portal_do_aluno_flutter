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
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(36, 172, 160, 228),
          shadowColor: Colors.transparent,
          foregroundColor: AppColors.lightTextPrimary,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.calendar_today,
                color: Theme.of(context).iconTheme.color,
              ),
              const SizedBox(width: 10),
              Text(
                dataSelecionada != null
                    ? '${dataSelecionada!.day} / ${dataSelecionada!.month} / ${dataSelecionada!.year}'
                    : 'Selecionar Data',
                style: Theme.of(context).textTheme.titleMedium!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
