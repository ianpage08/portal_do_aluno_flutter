// Página de Relatórios
import 'package:flutter/material.dart';

class RelatoriosPage extends StatelessWidget {
  const RelatoriosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final relatorios = [
      {
        'titulo': 'Relatório de Alunos por Turma',
        'icone': Icons.people,
        'descricao': 'Lista de alunos organizados por turma',
      },
      {
        'titulo': 'Relatório de Frequência',
        'icone': Icons.event_available,
        'descricao': 'Controle de presença dos alunos',
      },
      {
        'titulo': 'Relatório de Notas',
        'icone': Icons.grade,
        'descricao': 'Boletim e desempenho acadêmico',
      },
      {
        'titulo': 'Relatório Financeiro',
        'icone': Icons.attach_money,
        'descricao': 'Mensalidades e pagamentos',
      },
      {
        'titulo': 'Relatório de Professores',
        'icone': Icons.school,
        'descricao': 'Dados dos professores e disciplinas',
      },
      {
        'titulo': 'Contrato de Matricula',
        'icone': Icons.note,
        'descricao': 'Gerar contrato de matricula de aluno',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatórios'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.9,
          ),
          itemCount: relatorios.length,
          itemBuilder: (context, index) {
            final relatorio = relatorios[index];
            return Card(
              elevation: 2,
              child: InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('TODO: Gerar ${relatorio['titulo']}'),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        relatorio['icone'] as IconData,
                        size: 35,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        relatorio['titulo'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
