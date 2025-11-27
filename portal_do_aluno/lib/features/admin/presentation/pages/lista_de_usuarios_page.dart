import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/auth/data/datasouces/cadastro_service.dart';
import 'package:portal_do_aluno/navigation/navigation_sevice.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';

class ListaDeUsuariosPage extends StatefulWidget {
  const ListaDeUsuariosPage({super.key});

  @override
  State<ListaDeUsuariosPage> createState() => _ListaDeUsuariosPageState();
}

class _ListaDeUsuariosPageState extends State<ListaDeUsuariosPage> {
  final CadastroService _cadastroService = CadastroService();
  String? tipoSelecionado;

  Stream<QuerySnapshot> get minhaListaFiltrada {
    final base = FirebaseFirestore.instance.collection('usuarios');

    if (tipoSelecionado == null) return base.snapshots();

    return base.where('type', isEqualTo: tipoSelecionado).snapshots();
  }

  // cores para o tipo de usuário
  Color _tipoCor(String tipo) {
    switch (tipo) {
      case 'student':
        return Colors.blueAccent;
      case 'teacher':
        return Colors.green;
      case 'admin':
        return Colors.deepPurple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Lista de Usuários'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // ----------- FILTROS MODERNOS ------------- //
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Filtrar por Tipo",
                style: Theme.of(
                  context,
                ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),

            Wrap(
              spacing: 5,
              children: [
                _chipFiltro("Todos", null),
                _chipFiltro("Alunos", "student"),
                _chipFiltro("Professores", "teacher"),
                _chipFiltro("Admin", "admin"),
              ],
            ),

            const SizedBox(height: 12),
            Divider(color: Colors.grey.shade300),
            const SizedBox(height: 6),

            // ----------- LISTA ---------------- //
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: minhaListaFiltrada,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("Nenhum usuário encontrado"),
                    );
                  }

                  final usuarios = snapshot.data!.docs;

                  return ListView.separated(
                    itemCount: usuarios.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final data =
                          usuarios[index].data() as Map<String, dynamic>;

                      final cpf = data['cpf'] != null
                          ? _formatarCpf(data['cpf'].toString())
                          : '---';

                      final tipo = data['type'] ?? "---";
                      final userId = data['id'] ?? "";

                      return Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 16,
                          ),
                          leading: CircleAvatar(
                            radius: 26,
                            backgroundColor: Colors.grey.shade200,
                            child: const Icon(Icons.person, color: Colors.grey),
                          ),
                          title: Text(
                            data['name'] ?? 'Sem nome',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("CPF: $cpf"),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _tipoCor(tipo).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  tipo.toUpperCase(),
                                  style: TextStyle(
                                    color: _tipoCor(tipo),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          trailing: _menuPontinho(userId),
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

  Widget _chipFiltro(String texto, String? valor) {
    final bool ativo = tipoSelecionado == valor;

    return ChoiceChip(
      label: Text(texto),
      selected: ativo,
      labelStyle: TextStyle(
        color: ativo ? Colors.white : Colors.black87,
        fontWeight: FontWeight.w600,
      ),
      selectedColor: Colors.blueAccent,
      backgroundColor: Colors.grey.shade200,
      onSelected: (_) {
        setState(() {
          tipoSelecionado = valor;
        });
      },
    );
  }

  // CPF formatado
  String _formatarCpf(String cpf) {
    return cpf.replaceAllMapped(
      RegExp(r'(\d{3})(\d{3})(\d{3})(\d{2})'),
      (m) => "${m[1]}.${m[2]}.${m[3]}-${m[4]}",
    );
  }

  // ----------------------------------
  // MENU PONTINHO
  // ----------------------------------
  Widget _menuPontinho(String usuarioId) {
    return PopupMenuButton(
      offset: const Offset(0, 30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (String value) {
        switch (value) {
          case 'resetar':
            NavigatorService.navigateTo(
              RouteNames.changePassword,
              arguments: {'usuarioId': usuarioId},
            );
            break;

          case 'excluir':
            _cadastroService.deletarUsuario(usuarioId);
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'resetar', child: Text('Mudar Senha')),
        const PopupMenuItem(value: 'excluir', child: Text('Excluir')),
      ],
    );
  }
}
