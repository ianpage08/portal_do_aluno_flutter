import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  final List<Map<String, dynamic>> frequencias = const [
    {'materia': 'Matemática', 'aulasDadas': 40, 'aulasAssistidas': 35},
    {'materia': 'Português', 'aulasDadas': 60, 'aulasAssistidas': 50},
    {'materia': 'Geografia', 'aulasDadas': 17, 'aulasAssistidas': 10},
    {'materia': 'História', 'aulasDadas': 35, 'aulasAssistidas': 30},
  ];

  double frequenciaGeral(List<Map<String, dynamic>> frequencias) {
    int aulasDadas = 0;
    int aulasAssistidas = 0;
    for (var frequencia in frequencias) {
      aulasDadas += frequencia['aulasDadas'] as int;
      aulasAssistidas += frequencia['aulasAssistidas'] as int;
    }
    if (aulasDadas == 0) return 0;
    return (aulasAssistidas / aulasDadas) * 100;
  }

  double frequenciasDeAulas(int aulasDadas, int aulasAssistidas) {
    if (aulasDadas == 0) return 0;
    return (aulasAssistidas / aulasDadas) * 100;
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
            // Cartão da frequência geral
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.deepPurple[50],
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
                child: Column(
                  children: [
                    const Text(
                      'Frequência Anual',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${freqGeral.toStringAsFixed(2)}%',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: freqGeral >= 75 ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      freqGeral >= 75
                          ? 'Frequência dentro do esperado'
                          : 'Frequência abaixo do esperado',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: freqGeral >= 75
                            ? Colors.green[700]
                            : Colors.red[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Lista de matérias
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
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                      title: Text(
                        freq['materia'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          Text('Aulas dadas: ${freq['aulasDadas']}'),
                          Text('Aulas assistidas: ${freq['aulasAssistidas']}'),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              color: estaBaixo
                                  ? Colors.red[100]
                                  : Colors.green[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${percentual.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: estaBaixo
                                    ? Colors.red
                                    : Colors.green[800],
                                fontSize: 16,
                              ),
                            ),
                          ),
                          if (estaBaixo) const SizedBox(height: 4),
                          if (estaBaixo)
                            const Text(
                              'Atenção',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                        ],
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
