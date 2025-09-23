// Página de Matrículas
import 'package:flutter/material.dart';

class MatriculasPage extends StatefulWidget {
  const MatriculasPage({super.key});

  @override
  State<MatriculasPage> createState() => _MatriculasPageState();
}

class _MatriculasPageState extends State<MatriculasPage> {
  final List<Map<String, dynamic>> matriculas = [
    {
      'aluno': 'João Silva',
      'matricula': '2024001',
      'turma': '9º Ano A',
      'status': 'Ativo',
      'data': '01/02/2024',
    },
    {
      'aluno': 'Maria Santos',
      'matricula': '2024002',
      'turma': '9º Ano B',
      'status': 'Ativo',
      'data': '01/02/2024',
    },
    {
      'aluno': 'Pedro Costa',
      'matricula': '2024003',
      'turma': '8º Ano A',
      'status': 'Pendente',
      'data': '15/02/2024',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matrículas'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('TODO: Nova matrícula')),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    color: Colors.green,
                    child: const Text(
                      'Ativos',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    color: Colors.orange,
                    child: const Text(
                      'Pedentes',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: matriculas.length,
                itemBuilder: (context, index) {
                  final matricula = matriculas[index];
                  final isAtivo = matricula['status'] == 'Ativo';
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isAtivo ? Colors.green : Colors.orange,
                        child: Text(matricula['matricula'].substring(4)),
                      ),
                      title: Text(matricula['aluno']),
                      subtitle: Text(
                        '${matricula['matricula']} • ${matricula['turma']} • ${matricula['data']}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              switch (value) {
                                case 'Editar':
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'TODO: Editar matrícula ${matricula['matricula']}',
                                      ),
                                    ),
                                  );
                                  break;
                                case 'Transferir':
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'TODO: Transferir ${matricula['aluno']}',
                                      ),
                                    ),
                                  );
                                  break;
                                case 'Cancelar':
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'TODO: Cancelar matrícula ${matricula['matricula']}',
                                      ),
                                    ),
                                  );
                                  break;
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                value: 'Editar',
                                child: Text('Editar'),
                              ),
                              PopupMenuItem(
                                value: 'Transferir',
                                child: Text('Transferir'),
                              ),
                              PopupMenuItem(
                                value: 'Cancelar',
                                child: Text('Cancelar'),
                              ),
                            ],
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
