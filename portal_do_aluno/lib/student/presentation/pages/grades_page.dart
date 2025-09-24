import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class BoletimPage extends StatefulWidget {
  const BoletimPage({super.key});

  @override
  State<BoletimPage> createState() => _BoletimPageState();
}

class _BoletimPageState extends State<BoletimPage> {
  final List<Map<String, dynamic>> materias = [
    {'nome': 'Matemática', 'notaTeste': 7.5, 'notaProva': 8.0},
    {'nome': 'Português', 'notaTeste': 6.0, 'notaProva': 5.5},
    {'nome': 'Ciências', 'notaTeste': 8.0, 'notaProva': 7.0},
    {'nome': 'História', 'notaTeste': 9.0, 'notaProva': 8.5},
    {'nome': 'Geografia', 'notaTeste': 7.0, 'notaProva': 7.5},
    {'nome': 'Inglês', 'notaTeste': 6.5, 'notaProva': 6.0},
  ];
  final List<Map<String, dynamic>> materias2 = [
    {'nome': 'Matemática', 'notaTeste': 7.5, 'notaProva': 8.0},
    {'nome': 'Português', 'notaTeste': 6.0, 'notaProva': 5.5},
    {'nome': 'Ciências', 'notaTeste': 8.0, 'notaProva': 7.0},
    {'nome': 'História', 'notaTeste': 9.0, 'notaProva': 8.5},
    {'nome': 'Geografia', 'notaTeste': 7.0, 'notaProva': 7.5},
    {'nome': 'Inglês', 'notaTeste': 6.5, 'notaProva': 6.0},
  ];
  final List<Map<String, dynamic>> materias3 = [
    {'nome': 'Matemática', 'notaTeste': 7.5, 'notaProva': 8.0},
    {'nome': 'Português', 'notaTeste': 6.0, 'notaProva': 5.5},
    {'nome': 'Ciências', 'notaTeste': 8.0, 'notaProva': 7.0},
    {'nome': 'História', 'notaTeste': 9.0, 'notaProva': 8.5},
    {'nome': 'Geografia', 'notaTeste': 7.0, 'notaProva': 7.5},
    {'nome': 'Inglês', 'notaTeste': 6.5, 'notaProva': 6.0},
  ];
  final List<Map<String, dynamic>> materias4 = [
    {'nome': 'Matemática', 'notaTeste': 7.5, 'notaProva': 8.0},
    {'nome': 'Português', 'notaTeste': 6.0, 'notaProva': 5.5},
    {'nome': 'Ciências', 'notaTeste': 8.0, 'notaProva': 7.0},
    {'nome': 'História', 'notaTeste': 9.0, 'notaProva': 8.5},
    {'nome': 'Geografia', 'notaTeste': 7.0, 'notaProva': 7.5},
    {'nome': 'Inglês', 'notaTeste': 6.5, 'notaProva': 6.0},
  ];
  double calcularMedia() {
    final todasAsMaterias = [
      ...materias,
      ...materias2,
      ...materias3,
      ...materias4,
    ];
    double soma = 0;
    for (var materia in todasAsMaterias) {
      double mediaMateria = (materia['notaTeste'] + materia['notaProva']) / 2;
      soma += mediaMateria;
    }
    return soma / materias.length;
  }

  String statusFinal() {
    double media = calcularMedia();
    return media >= 20 ? 'Aprovado' : 'Reprovado';
  }

  @override
  Widget build(BuildContext context) {
    double mediaGeral = calcularMedia();
    String status = statusFinal();

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Boletim Escolar',
        backGround: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ExpansionPanelList.radio(
                children: [
                  ExpansionPanelRadio(
                    value: 'unidade1',
                    headerBuilder: (context, isExpanded) {
                      return const ListTile(
                        title: Text(
                          'Unidade 1',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text('Turma 10'),
                      );
                    },
                    body: Column(
                      children: materias.map((materia) {
                        double media =
                            ((materia['notaTeste'] + materia['notaProva']) / 2);

                        return ListTile(
                          title: Text(materia['nome']),
                          subtitle: Text(
                            'Teste: ${materia['notaTeste']} / Prova: ${materia['notaProva']}',
                          ),
                          shape: Border(
                            bottom: BorderSide(
                              color: Colors.grey[300]!,
                              width: 1,
                            ),
                          ),
                          trailing: Text(
                            'Média ${media.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  ExpansionPanelRadio(
                    value: 'unidade2',
                    headerBuilder: (context, isExpanded) {
                      return const ListTile(
                        title: Text(
                          'Unidade 2',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text('Turma 10'),
                      );
                    },
                    body: Column(
                      children: materias2.map((materia) {
                        double media =
                            ((materia['notaTeste'] + materia['notaProva']) / 2);

                        return ListTile(
                          title: Text(materia['nome']),
                          subtitle: Text(
                            'Teste: ${materia['notaTeste']} / Prova: ${materia['notaProva']}',
                          ),
                          shape: Border(
                            bottom: BorderSide(
                              color: Colors.grey[300]!,
                              width: 1,
                            ),
                          ),
                          trailing: Text(
                            'Média ${media.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  ExpansionPanelRadio(
                    value: 'unidade3',
                    headerBuilder: (context, isExpanded) {
                      return const ListTile(
                        title: Text(
                          'Unidade 3',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text('Turma 10'),
                      );
                    },
                    body: Column(
                      children: materias3.map((materia) {
                        double media =
                            ((materia['notaTeste'] + materia['notaProva']) / 2);

                        return ListTile(
                          title: Text(materia['nome']),
                          subtitle: Text(
                            'Teste: ${materia['notaTeste']} / Prova: ${materia['notaProva']}',
                          ),
                          shape: Border(
                            bottom: BorderSide(
                              color: Colors.grey[300]!,
                              width: 1,
                            ),
                          ),
                          trailing: Text(
                            'Média ${media.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  ExpansionPanelRadio(
                    value: 'unidade4',
                    headerBuilder: (context, isExpanded) {
                      return const ListTile(
                        title: Text(
                          'Unidade 4',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text('Turma 10'),
                      );
                    },
                    body: Column(
                      children: materias4.map((materia) {
                        double media =
                            ((materia['notaTeste'] + materia['notaProva']) / 2);

                        return ListTile(
                          title: Text(materia['nome']),
                          subtitle: Text(
                            'Teste: ${materia['notaTeste']} / Prova: ${materia['notaProva']}',
                          ),
                          shape: Border(
                            bottom: BorderSide(
                              color: Colors.grey[300]!,
                              width: 1,
                            ),
                          ),
                          trailing: Text(
                            'Média ${media.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 75,
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Média Geral: ${mediaGeral.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Status: $status',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: status == 'Aprovado'
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
