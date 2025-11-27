import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/data/datasources/matricula_firestore.dart';

import 'package:portal_do_aluno/shared/widgets/popup_menu_botton.dart';
import 'package:portal_do_aluno/navigation/navigation_sevice.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';

class MatriculasPage extends StatefulWidget {
  const MatriculasPage({super.key});

  @override
  State<MatriculasPage> createState() => _MatriculasPageState();
}

class _MatriculasPageState extends State<MatriculasPage> {
  final minhaStream = FirebaseFirestore.instance
      .collection('matriculas')
      .snapshots();
  final MatriculaService _matriculaService = MatriculaService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Alunos Matrículados'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              NavigatorService.navigateTo(RouteNames.adminMatriculaCadastro);
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
                    quantidade: 5,
                    cor: Colors.green,
                    icone: Icons.check_circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildResumoCard(
                    titulo: 'Pendentes',
                    quantidade: 6,
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
            final dadosAluno = data['dadosAluno'] ?? {};
            final alunoId = dadosAluno['id'];
            final dadosAcademicos = data['dadosAcademicos'] ?? {};

            return Card(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text('Aluno: ${dadosAluno['nome'] ?? '---'}'),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Matricula: ${dadosAcademicos['numeroMatricula'] ?? '---'}',
                        ),
                        Text('Turma: ${dadosAcademicos['turma'] ?? '---'}'),
                      ],
                    ),
                    const SizedBox(width: 12),
                    MenuPontinhoGenerico(
                      id: alunoId,
                      items: [
                        MenuItemConfig(
                          value: 'detalhes',
                          label: 'Detalhes',
                          onSelected: (id, context, extra) {
                            NavigatorService.navigateTo(
                              RouteNames.adminDetalhesAlunos,
                              arguments: id,
                            );
                          },
                        ),
                        MenuItemConfig(
                          value: 'excluir',
                          label: 'Excluir',
                          onSelected: (id, context, extra) {
                            if (id != null) {
                              try {
                                _matriculaService.excluirMatricula(id);
                              } catch (e) {
                                if (e is Exception) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())),
                                  );
                                }
                              }
                            }
                          },
                        ),
                      ],
                    ),
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
