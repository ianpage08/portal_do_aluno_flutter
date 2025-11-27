import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/data/datasources/cadastro_turma_firestore.dart';
import 'package:portal_do_aluno/shared/widgets/popup_menu_botton.dart';
import 'package:portal_do_aluno/navigation/navigation_sevice.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';

class TurmaPage extends StatefulWidget {
  const TurmaPage({super.key});

  @override
  State<TurmaPage> createState() => _TurmaPageState();
}

class _TurmaPageState extends State<TurmaPage> {
  final CadastroTurmaService _cadastroTurmaService = CadastroTurmaService();

  final minhaStream = FirebaseFirestore.instance
      .collection('turmas')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Turmas'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              NavigatorService.navigateTo(RouteNames.adminCadastroTurmas);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(padding: const EdgeInsets.all(8), child: _buildStream()),
    );
  }

  Widget _buildStream() {
    return StreamBuilder<QuerySnapshot>(
      stream: minhaStream,
      builder: (context, snapshot) {
        // Enquanto carrega
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Se houver erro
        if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar os dados'));
        }

        // Se não houver documentos
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Nenhum dado encontrado'));
        }

        // Pegando os documentos
        final docTurmas = snapshot.data!.docs;

        return ListView.builder(
          itemCount: docTurmas.length,
          itemBuilder: (context, index) {
            // Converte cada doc para Map<String, dynamic>
            final data = docTurmas[index].data() as Map<String, dynamic>;

            // Pega os valores com fallback caso algum campo esteja ausente
            final serie = data['serie'] ?? '---';
            final turno = data['turno'] ?? '---';
            final qtdAlunos = data['qtdAlunos'] ?? 0;
            final professor = data['professorTitular'] ?? '---';

            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(child: Text(serie[0])),
                title: Text(serie),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Turno: $turno'),
                            Text('Alunos: $qtdAlunos'),
                          ],
                        ),
                        MenuPontinhoGenerico(
                          id: data['id'],
                          items: [
                            MenuItemConfig(
                              value: 'Excluir',
                              label: 'Excluir',
                              onSelected: (id, context, extra) {
                                if (id != null) {
                                  _cadastroTurmaService.excluirTurma(id);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text('Professor(es): $professor'),
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
