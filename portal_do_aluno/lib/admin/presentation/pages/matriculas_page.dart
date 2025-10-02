import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MatriculasPage extends StatefulWidget {
  const MatriculasPage({super.key});

  @override
  State<MatriculasPage> createState() => _MatriculasPageState();
}

class _MatriculasPageState extends State<MatriculasPage> {
  final minhaStream = FirebaseFirestore.instance
      .collection('matriculas')
      .orderBy('name')
      .snapshots();
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
            Expanded(child: _buildStreamMatriculas()),
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
      color: cor.withValues(alpha: 0.1),
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

  Widget _buildStreamMatriculas() {
    return StreamBuilder(
      stream: minhaStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar os dados'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Nenhum dado encontrado'));
        }
        final docMatriculas = snapshot.data!.docs;
        return ListView.builder(
          itemCount: docMatriculas.length,
          itemBuilder: (context, index) {
            final data = docMatriculas[index].data();

            return Card(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text('Aluno: ${data['name']}'),
                subtitle: Column(
                  children: [
                    Text('Matricula: ${data['matricula']}'),
                    Text('Turma: ${data['turma']}'),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
