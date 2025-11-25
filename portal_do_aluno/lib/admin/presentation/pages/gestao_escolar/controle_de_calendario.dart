import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/admin/data/firestore_services/calendario_service.dart';
import 'package:portal_do_aluno/admin/data/models/calendario.dart';
import 'package:portal_do_aluno/admin/helper/form_helper.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/botao_salvar.dart';
import 'package:portal_do_aluno/admin/helper/snack_bar_personalizado.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/text_form_field.dart';

import 'package:table_calendar/table_calendar.dart';

class ControleDeCalendario extends StatefulWidget {
  const ControleDeCalendario({super.key});

  @override
  State<ControleDeCalendario> createState() => _ControleDeCalendarioState();
}

class _ControleDeCalendarioState extends State<ControleDeCalendario> {
  final CalendarioService _calendarioService = CalendarioService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _mapController = {
    'titulo': TextEditingController(),
    'descricao': TextEditingController(),
  };
  List<TextEditingController> get _allControllers =>
      _mapController.values.toList();
  DateTime? dataSelecionada;
  DateTime _focusDay = DateTime.now();

  @override
  void dispose() {
    for (var controller in _allControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    dataSelecionada = DateTime.now();
  }

  Future<void> _salvarEvento() async {
    if (FormHelper.isFormValid(formKey: _formKey, listControllers: _allControllers) && dataSelecionada != null) {
      final novoEvento = Calendario(
        id: '',
        titulo: _mapController['titulo']!.text,
        descricao: _mapController['descricao']!.text,
        data: dataSelecionada!,
      );
      await _calendarioService.cadastrarCalendario(novoEvento);
      if (mounted) {
        snackBarPersonalizado(
          context: context,
          mensagem: 'Evento salvo com sucesso! 🎉',
          cor: Colors.green,
        );
      }
      FormHelper.limparControllers(controllers: _allControllers);

      setState(() => dataSelecionada = null);
    } else {
      snackBarPersonalizado(context: context, mensagem: 'Por favor, preencha todos os campos corretamente.', cor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle de Calendário'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
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
                      TextFormFieldPersonalizado(
                        controller: _mapController['titulo']!,
                        keyboardType: TextInputType.text,
                        label: 'Título',
                        hintText: 'Ex: Feriado de Natal',
                        prefixIcon: 
                          Icons.event,
                          
                        validator: (value) =>
                            value!.isEmpty ? 'Informe um título' : null,
                      ),

                      const SizedBox(height: 12),
                      TextFormFieldPersonalizado(
                        maxLines: 5,
                        controller: _mapController['descricao']!,
                        keyboardType: TextInputType.text, 
                        label: 'Descrição',
                        hintText: 'Ex: Evento escolar de comemoração do Natal',
                        prefixIcon: 
                          Icons.description,
                         
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
            BotaoSalvar(
              salvarconteudo: () async {
                await _salvarEvento();
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Eventos Cadastrados',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('calendario')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Nenhum evento encontrado'));
                }
                final eventosDocs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: eventosDocs.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final evento = eventosDocs[index];
                    final dataEvento = (eventosDocs[index]['data'] as Timestamp)
                        .toDate();
                    final dataFormatada =
                        '${dataEvento.day}/${dataEvento.month}/${dataEvento.year}';
                    final tituloEvento = evento['titulo'];
                    final descricaoEvento = evento['descricao'];
                    return ListTile(
                      title: Text(tituloEvento),
                      leading: const Icon(Icons.event),
                      subtitle: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(descricaoEvento),
                              Text(dataFormatada),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Divider(),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
