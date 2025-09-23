import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class StudentsListPage extends StatefulWidget {
  const StudentsListPage({super.key});

  @override
  State<StudentsListPage> createState() => _StudentsListPageState();
}

class _StudentsListPageState extends State<StudentsListPage> {
  List<Map<String, dynamic>> alunos = [
    {
      'nome': 'Ian',
      'boletim': [
        {
          'matematica': 10,
          'portugues': 5,
          'historia': 7,
          'geografia': 8,
          'ingles': 10,
        },
      ],
      'faltas': 50,
      'presenca': 150,
      'justificativa': 5,
    },
    {
      'nome': 'Maria',
      'boletim': [
        {
          'matematica': 8,
          'portugues': 9,
          'historia': 6,
          'geografia': 7,
          'ingles': 9,
        },
      ],
      'faltas': 20,
      'presenca': 180,
      'justificativa': 2,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Lista de alunos'),
      body: alunos.isEmpty
          ? const Center(child: Text('Nenhum boletim encontrado'))
          : ListView.builder(
              itemCount: alunos.length,
              itemBuilder: (context, index) {
                final aluno = alunos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    title: Text('Aluno: ${aluno['nome']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Faltas: ${aluno['faltas']}'),
                        Text('Presença: ${aluno['presenca']}'),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StudentDetailPage(aluno: aluno),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

class StudentDetailPage extends StatelessWidget {
  final Map<String, dynamic> aluno;
  const StudentDetailPage({super.key, required this.aluno});

  @override
  Widget build(BuildContext context) {
    final boletim = aluno['boletim'] as List<dynamic>?;

    return Scaffold(
      appBar: CustomAppBar(title: 'Detalhes aluno: ${aluno['nome']}'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: (boletim == null || boletim.isEmpty)
            ? const Center(child: Text('Nada Encontrado'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Notas:',
                    style: TextStyle(color: Colors.deepPurpleAccent),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: boletim[0].entries.map<Widget>((entry) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _capitalize(entry.key),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(entry.value.toString()),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Faltas: ${aluno['faltas']}'),
                  Text('Presença: ${aluno['presenca']}'),
                  Text('Justificativas: ${aluno['justificativa']}'),
                ],
              ),
      ),
    );
  }

  String _capitalize(String s) =>
      s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : s;
}
