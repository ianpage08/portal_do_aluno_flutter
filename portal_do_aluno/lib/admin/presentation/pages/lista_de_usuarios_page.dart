import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/auth/data/datasouces/cadastro_service.dart';
import 'package:portal_do_aluno/navigation/navigation_sevice.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class ListaDeUsuariosPage extends StatefulWidget {
  const ListaDeUsuariosPage({super.key});

  @override
  State<ListaDeUsuariosPage> createState() => _ListaDeUsuariosPageState();
}

class _ListaDeUsuariosPageState extends State<ListaDeUsuariosPage> {
  final CadastroService _cadastroService = CadastroService();
  String? tipoSelecionado;

  Stream<QuerySnapshot> get minhaListaFiltrada {
    final minhaStream = FirebaseFirestore.instance
        .collection('usuarios')
        .snapshots();
    final colecaoPortype = FirebaseFirestore.instance.collection('usuarios');

    if (tipoSelecionado != null) {
      return colecaoPortype
          .where('type', isEqualTo: tipoSelecionado)
          .snapshots();
    } else {
      return minhaStream;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Usuários'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text(
              'Ordernar por Tipo de Usuario',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      tipoSelecionado = null;
                    });
                  },
                  child: const Text('Todos'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      tipoSelecionado = 'student';
                    });
                  },
                  child: const Text('Alunos'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      tipoSelecionado = 'teacher';
                    });
                  },
                  child: const Text('Professores'),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: minhaListaFiltrada,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Erro ao carregar os dados'),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('Nenhum usuário encontrado'),
                    );
                  }

                  final docUsuarios = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: docUsuarios.length,
                    itemBuilder: (context, index) {
                      final data =
                          docUsuarios[index].data() as Map<String, dynamic>;

                      final cpfFormatado = data['cpf'] != null
                          ? data['cpf'].toString().replaceAllMapped(
                              RegExp(r'(\d{3})(\d{3})(\d{3})(\d{2})'),
                              (match) =>
                                  '${match[1]}.${match[2]}.${match[3]}-${match[4]}',
                            )
                          : '---';

                      return Card(
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text(data['name'] ?? 'Sem nome'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('CPF: $cpfFormatado'),
                              Text('Tipo: ${data['type'] ?? '---'}'),
                            ],
                          ),
                          trailing: _menuPontinho(
                            data['id'] != null ? data['id'].toString() : '',
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuPontinho(String usuarioId) {
    return PopupMenuButton(
      onSelected: (String valorSelecionado) {
        if (valorSelecionado == 'detalhes') {
          NavigatorService.navigateTo(RouteNames.adminDetalhesAlunos);
        } else if (valorSelecionado == 'excluir') {
          _cadastroService.deletarUsuario(usuarioId);
        }
      },
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<String>>[
          const PopupMenuItem(value: 'detalhes', child: Text('Detalhes')),
          const PopupMenuItem(value: 'excluir', child: Text('Excluir')),
        ];
      },
    );
  }
}
