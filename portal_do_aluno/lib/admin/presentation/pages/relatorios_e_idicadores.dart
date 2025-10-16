/*Visualizar estatísticas:

Frequência geral.

Médias por disciplina/turma.

Ranking de notas.
Frequência geral por turma

Média de notas por matéria

Ranking de alunos

Exportar PDF/Excel*/


import 'package:flutter/material.dart';
import 'package:portal_do_aluno/admin/data/datasources/frequencia_service.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/stream_tamanho_where.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class RelatoriosGerenciais extends StatefulWidget {
  const RelatoriosGerenciais({super.key});

  @override
  State<RelatoriosGerenciais> createState() => _RelatoriosGerenciaisState();
}

class _RelatoriosGerenciaisState extends State<RelatoriosGerenciais> {
  String _periodoSelecionado = 'Mensal';
  final FrequenciaService _frequenciaService = FrequenciaService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Relatórios Gerenciais'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filtro de Período
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.filter_list),
                    const SizedBox(width: 12),
                    const Text('Período:'),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButton<String>(
                        value: _periodoSelecionado,
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(
                            value: 'Semanal',
                            child: Text('Semanal'),
                          ),
                          DropdownMenuItem(
                            value: 'Mensal',
                            child: Text('Mensal'),
                          ),
                          DropdownMenuItem(
                            value: 'Bimestral',
                            child: Text('Bimestral'),
                          ),
                          DropdownMenuItem(
                            value: 'Anual',
                            child: Text('Anual'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _periodoSelecionado = value!;
                          });
                          _toast('Período alterado para: $value');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Cards de Métricas
            const Text(
              '📊 Visão Geral',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                StreamContagem(
                  collectionPath: 'usuarios',
                  fieldName: 'type',
                  fieldValue: 'student',
                  builder: (context, snapshot, total) {
                    return _buildCardMetrica('👥 Alunos', total, Colors.blue);
                  },
                ),
                StreamContagem(
                  collectionPath: 'usuarios',
                  fieldName: 'type',
                  fieldValue: 'teacher',
                  builder: (context, snapshot, total) {
                    return _buildCardMetrica(
                      '👨‍🏫 Professores',
                      total,
                      Colors.green,
                    );
                  },
                ),
                StreamContagem(
                  collectionPath: 'turmas',
                  builder: (context, snapshot, total) {
                    return _buildCardMetrica('🏫 Turmas', total, Colors.orange);
                  },
                ),
                FutureBuilder<int>(
                  future: _frequenciaService
                      .calcularQuantidadeDeFrequenciaPorpresenca(
                        tipoPresenca: 'presente',
                      ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final quantidadePresenca = snapshot.data ?? 0;
                    return _buildCardMetrica(
                      '📈 Presenças',
                      quantidadePresenca,
                      Colors.purple,
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Gráficos
            const Text(
              '📈 Análises',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.bar_chart, color: Colors.blue),
                title: const Text('Desempenho por Turma'),
                subtitle: const Text('Comparativo de notas médias'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _toast('TODO: Abrir gráfico de desempenho'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.pie_chart, color: Colors.green),
                title: const Text('Distribuição de Alunos'),
                subtitle: const Text('Por série e turma'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _toast('TODO: Abrir gráfico de distribuição'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.show_chart, color: Colors.orange),
                title: const Text('Evolução da Frequência'),
                subtitle: const Text('Últimos 6 meses'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _toast('TODO: Abrir gráfico de frequência'),
              ),
            ),
            const SizedBox(height: 20),

            // Relatórios Específicos
            const Text(
              '📋 Relatórios Específicos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.people, color: Colors.indigo),
                title: const Text('Frequência por Turma'),
                subtitle: const Text('Controle de faltas e presenças'),
                trailing: IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () =>
                      _toast('TODO: Baixar relatório de frequência'),
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.grade, color: Colors.red),
                title: const Text('Ranking de Notas'),
                subtitle: const Text('Melhores e piores desempenhos'),
                trailing: IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () => _toast('TODO: Baixar ranking de notas'),
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.warning, color: Colors.amber),
                title: const Text('Disciplinas Críticas'),
                subtitle: const Text('Matérias com média abaixo de 6.0'),
                trailing: IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () => _toast('TODO: Baixar relatório crítico'),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Ações Rápidas
            const Text(
              '⚡ Ações Rápidas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        _toast('TODO: Exportar todos os relatórios'),
                    icon: const Icon(Icons.file_download),
                    label: const Text('Exportar Tudo'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _toast('TODO: Imprimir resumo executivo'),
                    icon: const Icon(Icons.print),
                    label: const Text('Imprimir'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardMetrica(String titulo, int valor, Color cor) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              valor.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: cor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
