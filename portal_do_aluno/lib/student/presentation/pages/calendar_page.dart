import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/admin/data/firestore_services/calendario_service.dart';
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
  final CalendarioService _calendarioService = CalendarioService();

  /// Mapa com os eventos agrupados por data
  Map<DateTime, List<Map<String, dynamic>>> _eventosPorDia = {};

  /// Função auxiliar para pegar os eventos de um dia específico
  List<Map<String, dynamic>> _getEventosDoDia(DateTime day) {
    return _eventosPorDia[DateTime(day.year, day.month, day.day)] ?? [];
  }

  /// Quando o usuário seleciona um dia no calendário
  void _onDaySelected(DateTime selectedDay, DateTime focusDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusDay = focusDay;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Calendário Escolar'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<QuerySnapshot>(
          stream: _calendarioService.getCalendario(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            }

            // 🔥 Monta o mapa de eventos dinamicamente
            final eventosMap = <DateTime, List<Map<String, dynamic>>>{};
            for (var doc in snapshot.data!.docs) {
              final data = (doc['data'] as Timestamp).toDate();
              final dataNormalizada = DateTime(data.year, data.month, data.day);
              final evento = doc.data() as Map<String, dynamic>;

              if (eventosMap[dataNormalizada] == null) {
                eventosMap[dataNormalizada] = [evento];
              } else {
                eventosMap[dataNormalizada]!.add(evento);
              }
            }
            _eventosPorDia = eventosMap;

            final eventosDoDia = _getEventosDoDia(_selectedDay!);

            return Column(
              children: [
                // 📅 Card do calendário
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
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDay, day),
                      onDaySelected: _onDaySelected,

                      eventLoader: (day) {
                        if (isSameDay(day, _selectedDay)) {
                          return [];
                        }
                        return _getEventosDoDia(day);
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
                        markerDecoration: BoxDecoration(
                          color: Colors.deepPurpleAccent,
                          shape: BoxShape.circle,
                        ),
                        markersAlignment: Alignment.bottomCenter,
                        markersMaxCount: 3,
                        markerSizeScale: 0.25,
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

                //  Lista de eventos do dia selecionado
                Expanded(
                  child: eventosDoDia.isEmpty
                      ? const Center(
                          child: Text(
                            'Nenhum evento neste dia 😴',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: eventosDoDia.length,
                          itemBuilder: (context, index) {
                            final evento = eventosDoDia[index];
                            final titulo = evento['titulo'] ?? 'Sem título';
                            final descricao =
                                evento['descricao'] ?? 'Sem descrição';
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              shadowColor: Colors.deepPurpleAccent[200],
                              child: ListTile(
                                leading: Icon(
                                  Icons.event,
                                  color: Colors.deepPurpleAccent[200],
                                ),
                                title: Text(titulo),
                                subtitle: Text(descricao),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
