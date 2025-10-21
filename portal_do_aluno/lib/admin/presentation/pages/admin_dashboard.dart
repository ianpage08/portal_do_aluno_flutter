import 'package:flutter/material.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/stream_referencia_id.dart';
import 'package:portal_do_aluno/core/app_constants/colors.dart';
import 'package:portal_do_aluno/core/user/user.dart';
import 'package:portal_do_aluno/navigation/navigation_sevice.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final argumentos =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (argumentos == null || argumentos['user'] == null) {
      return const Scaffold(
        body: Center(child: Text('Dados do ussuário não encontrados')),
      );
    }

    final Map<String, dynamic> usuarioMap = argumentos['user'];
    final usuario = Usuario.fromJson(usuarioMap);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Administrador',
        backGround: AppColors.admin,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Row(
                  children: [
                    Expanded(
                      child: MeuStreamBuilder(
                        collectionPath: 'usuarios',
                        documentId: usuario.id,
                        builder: (context, snapshot) {
                          final data = snapshot.data!.data()!;

                          final dadosUsuario = Usuario.fromJson(data);
                          return Row(
                            children: [
                              const CircleAvatar(
                                radius: 30,
                                backgroundColor: AppColors.admin,
                                child: Icon(
                                  Icons.person,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Admin: ${dadosUsuario.name}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text('Escola: AEEC'),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildMenuCard(
                    context,
                    Icons.event_available,
                    'Gestão de ano Letivo',
                    () {
                      NavigatorService.navigateTo(RouteNames.adminCalendar);
                    },
                  ),
                  _buildMenuCard(
                    context,
                    Icons.person_add_alt_1_rounded,
                    'Gestão de Usuários',
                    () {
                      NavigatorService.navigateTo(RouteNames.adminGestao);
                    },
                  ),
                  _buildMenuCard(context, Icons.co_present, 'Frequencia', () {
                    NavigatorService.navigateTo(RouteNames.adminFrequencia);
                  }),
                  _buildMenuCard(
                    context,
                    Icons.menu_book,
                    'Conteúdo da Aula',
                    () {
                      NavigatorService.navigateTo(RouteNames.addOqueFoiDado);
                    },
                  ),
                  _buildMenuCard(context, Icons.home, 'Gestão Escolar', () {
                    NavigatorService.navigateTo(RouteNames.adminGestaoEscolar);
                  }),
                  _buildMenuCard(context, Icons.numbers, 'Boletins', () {
                    NavigatorService.navigateTo(RouteNames.boletim);
                  }),
                  _buildMenuCard(
                    context,
                    Icons.add_reaction_rounded,
                    'Matriculas',
                    () {
                      NavigatorService.navigateTo(
                        RouteNames.adminMatriculaCadastro,
                      );
                    },
                  ),
                  _buildMenuCard(
                    context,
                    Icons.graphic_eq_rounded,
                    'Relatorio gerencias',
                    () {
                      NavigatorService.navigateTo(
                        RouteNames.adminRelatoriosGerenciais,
                      );
                    },
                  ),
                  _buildMenuCard(
                    context,
                    Icons.security_outlined,
                    'Segurança e Permissões',
                    () {
                      NavigatorService.navigateTo(
                        RouteNames.adminSegurancaEPermissoes,
                      );
                    },
                  ),
                  _buildMenuCard(
                    context,
                    Icons.message,
                    'Comunicação Institicional',
                    () {
                      NavigatorService.navigateTo(
                        RouteNames.adminComunicacaoInstiticional,
                      );
                    },
                  ),
                  _buildMenuCard(
                    context,
                    Icons.dock_outlined,
                    'Gerar Documentos',
                    () {
                      NavigatorService.navigateTo(
                        RouteNames.adminGeracaoDocumentos,
                      );
                    },
                  ),
                  _buildMenuCard(context, Icons.group, 'Lista de Usuarios', () {
                    NavigatorService.navigateTo(
                      RouteNames.adminListaDeUsuarios,
                    );
                  }),
                  _buildMenuCard(
                    context,
                    Icons.manage_accounts_rounded,
                    'Manuteção',
                    () {},
                  ),
                  _buildMenuCard(
                    context,
                    Icons.support_agent_rounded,
                    'Suporte',
                    () {},
                  ),
                  _buildMenuCard(
                    context,
                    Icons.settings,
                    'Configurações do Sistema',
                    () {},
                  ),
                  _buildMenuCard(context, Icons.help, 'Ajuda', () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 38, color: AppColors.primary),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ), // inkwell = Efeito de toque no card
    );
  }
}
