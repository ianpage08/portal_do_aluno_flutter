import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final String evento = _selectedDay == null
        ? 'Nenhum dia selecionado'
        : 'Dia de prova';

    return Scaffold(
      appBar: const CustomAppBar(title: 'Calendário Escolar'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Card do calendário
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              shadowColor: Colors.deepPurpleAccent[100],
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: TableCalendar(
                  locale: 'pt_BR',
                  focusedDay: _focusDay,
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusDay = focusedDay;
                    });
                  },
                  calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.deepPurple,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    todayTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurpleAccent,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    selectedTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    defaultTextStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    weekendTextStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.deepPurple,
                    ),
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
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
            ),
            const SizedBox(height: 24),
            // Card do evento
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.deepPurple[50],
              shadowColor: Colors.deepPurpleAccent[100],
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: Center(
                  child: Text(
                    evento,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
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
