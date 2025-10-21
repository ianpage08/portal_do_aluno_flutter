import 'package:flutter/material.dart';
import 'package:portal_do_aluno/admin/data/firestore_services/calendario_service.dart';
import 'package:portal_do_aluno/admin/data/models/calendario.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';
import 'package:table_calendar/table_calendar.dart';

class ControleDeCalendario extends StatefulWidget {
  const ControleDeCalendario({super.key});

  @override
  State<ControleDeCalendario> createState() => _ControleDeCalendarioState();
}

class _ControleDeCalendarioState extends State<ControleDeCalendario> {
  final CalendarioService _calendarioService = CalendarioService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  DateTime? dataSelecionada;
  DateTime _focusDay = DateTime.now();

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    dataSelecionada = DateTime.now();
  }

  Future<void> _salvarEvento() async {
    if (_formKey.currentState!.validate() && dataSelecionada != null) {
      final novoEvento = Calendario(
        id: '',
        titulo: _tituloController.text,
        descricao: _descricaoController.text,
        data: dataSelecionada!,
      );
      await _calendarioService.cadastrarCalendario(novoEvento);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Evento salvo com sucesso! 🎉'),
          backgroundColor: Color.fromARGB(255, 58, 183, 96),
        ),
      );

      _tituloController.clear();
      _descricaoController.clear();
      setState(() => dataSelecionada = null);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos e selecione uma data! ⚠️'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Gestão de Calendário'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _tituloController,
                        decoration: const InputDecoration(
                          labelText: 'Título',
                          hintText: 'Ex: Feriado de Natal',
                          prefixIcon: Icon(
                            Icons.event,
                            color: Colors.deepPurple,
                          ),
                          fillColor: Color(0xFFF2F2F2),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Informe um título' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _descricaoController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Descrição',
                          hintText:
                              'Ex: Evento escolar de comemoração do Natal',
                          prefixIcon: Icon(
                            Icons.description,
                            color: Colors.deepPurple,
                          ),
                          fillColor: Color(0xFFF2F2F2),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: TableCalendar(
                locale: 'pt_BR',
                focusedDay: _focusDay,
                firstDay: DateTime.utc(2025, 01, 01),
                lastDay: DateTime.utc(2030, 12, 31),
                selectedDayPredicate: (day) => isSameDay(dataSelecionada, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    dataSelecionada = selectedDay;
                    _focusDay = focusedDay;
                  });
                },
                calendarStyle: const CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: Colors.deepPurple,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple,
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Colors.deepPurple,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _salvarEvento,
                icon: const Icon(Icons.save),
                label: const Text('Salvar Evento'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
