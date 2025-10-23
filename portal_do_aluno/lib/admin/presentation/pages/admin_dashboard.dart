import 'package:flutter/material.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/menu_navigation_card.dart';
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
                  // MenuNavigationCard: widget personalizado dos botões do menu.
                  // - NavigationService e RouteNames: controle de rotas e nomes das páginas personalizados.
                  MenuNavigationCard(
                    context: context,
                    icon: Icons.event_available,
                    title: 'Gestão de ano Letivo',
                    onTap: () {
                      NavigatorService.navigateTo(RouteNames.adminCalendar);
                    },
                  ),
                  MenuNavigationCard(
                    context: context,
                    icon: Icons.person_add_alt_1_rounded,
                    title: 'Gestão de Usuários',
                    onTap: () {
                      NavigatorService.navigateTo(RouteNames.adminGestao);
                    },
                  ),
                  MenuNavigationCard(
                    context: context,
                    icon: Icons.co_present,
                    title: 'Frequencia',
                    onTap: () {
                      NavigatorService.navigateTo(RouteNames.adminFrequencia);
                    },
                  ),
                  MenuNavigationCard(
                    context: context,
                    icon: Icons.menu_book,
                    title: 'Conteúdo da Aula',
                    onTap: () {
                      NavigatorService.navigateTo(RouteNames.addOqueFoiDado);
                    },
                  ),
                  MenuNavigationCard(
                    context: context,
                    icon: Icons.home,
                    title: 'Gestão Escolar',
                    onTap: () {
                      NavigatorService.navigateTo(
                        RouteNames.adminGestaoEscolar,
                      );
                    },
                  ),
                  MenuNavigationCard(
                    context: context,
                    icon: Icons.numbers,
                    title: 'Boletins',
                    onTap: () {
                      NavigatorService.navigateTo(RouteNames.boletim);
                    },
                  ),
                  MenuNavigationCard(
                    context: context,
                    icon: Icons.add_reaction_rounded,
                    title: 'Matriculas',
                    onTap: () {
                      NavigatorService.navigateTo(
                        RouteNames.adminMatriculaCadastro,
                      );
                    },
                  ),
                  MenuNavigationCard(
                    context: context,
                    icon: Icons.graphic_eq_rounded,
                    title: 'Relatorio gerencias',
                    onTap: () {
                      NavigatorService.navigateTo(
                        RouteNames.adminRelatoriosGerenciais,
                      );
                    },
                  ),
                  MenuNavigationCard(
                    context: context,
                    icon: Icons.security_outlined,
                    title: 'Segurança e Permissões',
                    onTap: () {
                      NavigatorService.navigateTo(
                        RouteNames.adminSegurancaEPermissoes,
                      );
                    },
                  ),
                  MenuNavigationCard(
                    context: context,
                    icon: Icons.message,
                    title: 'Comunicação Institicional',
                    onTap: () {
                      NavigatorService.navigateTo(
                        RouteNames.adminComunicacaoInstiticional,
                      );
                    },
                  ),
                  MenuNavigationCard(
                    context: context,
                    icon: Icons.dock_outlined,
                    title: 'Gerar Documentos',
                    onTap: () {
                      NavigatorService.navigateTo(
                        RouteNames.adminGeracaoDocumentos,
                      );
                    },
                  ),
                  MenuNavigationCard(
                    context: context,
                    icon: Icons.group,
                    title: 'Lista de Usuarios',
                    onTap: () {
                      NavigatorService.navigateTo(
                        RouteNames.adminListaDeUsuarios,
                      );
                    },
                  ),
                  MenuNavigationCard(
                    context: context,
                    icon: Icons.manage_accounts_rounded,
                    title: 'Manuteção',
                    onTap: () {},
                  ),
                  MenuNavigationCard(
                    context: context,
                    icon: Icons.support_agent_rounded,
                    title: 'Suporte',
                    onTap: () {},
                  ),
                  MenuNavigationCard(
                    context: context,
                    icon: Icons.settings,
                    title: 'Configurações do Sistema',
                    onTap: () {},
                  ),
                  MenuNavigationCard(
                    context: context,
                    icon: Icons.help,
                    title: 'Ajuda',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
