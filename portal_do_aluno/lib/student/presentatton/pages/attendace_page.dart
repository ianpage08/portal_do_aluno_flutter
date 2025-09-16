import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  final List<Map<String, dynamic>> frequencias = const [
    {'materia': 'Matematica', 'aulasDadas': 40, 'aulasAssistidas': 35},
    {'materia': 'Portugues', 'aulasDadas': 60, 'aulasAssistidas': 50},
    {'materia': 'Geografia', 'aulasDadas': 17, 'aulasAssistidas': 10},
    {'materia': 'Historia', 'aulasDadas': 35, 'aulasAssistidas': 30},
  ];

  double frequenciaGeral(List<Map<String, dynamic>> frequencias) {
    int aulasDadas = 0;
    int aulasAssistidas = 0;
    for (var frequencia in frequencias) {
      aulasDadas += frequencia['aulasDadas'] as int;
      aulasAssistidas += frequencia['aulasAssistidas'] as int;
    }
    if (aulasDadas == 0) {
      return 0;
    } else {
      return (aulasAssistidas / aulasDadas) * 100;
    }
  }

  double frequenciasDeAulas(int aulasDadas, int aulasAssistidas) {
    if (aulasDadas == 0) {
      return 0;
    } else {
      return (aulasAssistidas / aulasDadas) * 100;
    }
  }

  @override
  Widget build(BuildContext context) {
    double freqGeral = frequenciaGeral(frequencias);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Frequência',
        backGround: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const ListTile(
                      title: Text(
                        'Frequência Anual',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(height: 5, thickness: 1),
                    Text(
                      '${freqGeral.toStringAsFixed(2)}%',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: freqGeral >= 75 ? Colors.green : Colors.red,
                      ),
                    ),
                    Text(
                      freqGeral >= 75
                          ? 'Frequência dentro do esperado'
                          : 'Frequência abaixo do esperado',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: freqGeral >= 75 ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: frequencias.length,
                itemBuilder: (context, index) {
                  final freq = frequencias[index];
                  final percentual = frequenciasDeAulas(
                    freq['aulasDadas'] as int,
                    freq['aulasAssistidas'] as int,
                  );
                  final estaBaixo = percentual < 75;
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              freq['materia'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Aulas dadas: ${freq['aulasDadas']}'),
                            Text(
                              'Aulas assistidas: ${freq['aulasAssistidas']}',
                            ),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${percentual.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: estaBaixo ? Colors.red : Colors.green,
                                fontSize: 16,
                              ),
                            ),
                            if (estaBaixo)
                              const Text(
                                'Atenção',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
