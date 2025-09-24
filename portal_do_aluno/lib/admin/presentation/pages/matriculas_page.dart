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
    final ativos = matriculas.where((m) => m['status'] == 'Ativo').length;
    final pendentes = matriculas.where((m) => m['status'] == 'Pendente').length;

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
            // Cards resumo
            Row(
              children: [
                Expanded(
                  child: _buildResumoCard(
                    titulo: 'Ativos',
                    quantidade: ativos,
                    cor: Colors.green,
                    icone: Icons.check_circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildResumoCard(
                    titulo: 'Pendentes',
                    quantidade: pendentes,
                    cor: Colors.orange,
                    icone: Icons.pending_actions,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Lista de matrículas
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
                        child: Icon(
                          isAtivo ? Icons.check : Icons.hourglass_bottom,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(matricula['aluno']),
                      subtitle: Text(
                        '${matricula['matricula']} • ${matricula['turma']} • ${matricula['data']}',
                      ),
                      trailing: PopupMenuButton<String>(
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
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 18),
                                SizedBox(width: 8),
                                Text('Editar'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'Transferir',
                            child: Row(
                              children: [
                                Icon(Icons.swap_horiz, size: 18),
                                SizedBox(width: 8),
                                Text('Transferir'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'Cancelar',
                            child: Row(
                              children: [
                                Icon(Icons.cancel, size: 18),
                                SizedBox(width: 8),
                                Text('Cancelar'),
                              ],
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

  Widget _buildResumoCard({
    required String titulo,
    required int quantidade,
    required Color cor,
    required IconData icone,
  }) {
    return Card(
      color: cor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Icon(icone, color: cor, size: 36),
            Text(
              quantidade.toString(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: cor,
              ),
            ),
            Text(
              titulo,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
