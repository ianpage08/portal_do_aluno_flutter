import 'package:flutter/cupertino.dart';
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
                    icon: CupertinoIcons.home,
                    title: 'Gestão Escolar',
                    onTap: () {
                      NavigatorService.navigateTo(
                        RouteNames.adminGestaoEscolar,
                      );
                    },
                  ),

                  MenuNavigationCard(
                    context: context,
                    icon: CupertinoIcons.person_add,
                    title: 'Gestão de Usuários',
                    onTap: () {
                      NavigatorService.navigateTo(RouteNames.adminGestao);
                    },
                  ),

                  MenuNavigationCard(
                    context: context,
                    icon: CupertinoIcons.person_2_square_stack,
                    title: 'Nova Matricula',
                    onTap: () {
                      NavigatorService.navigateTo(
                        RouteNames.adminMatriculaCadastro,
                      );
                    },
                  ),
                  MenuNavigationCard(
                    context: context,
                    icon: CupertinoIcons.doc_on_doc,
                    title: 'Relatorios e Documentos',
                    onTap: () {
                      NavigatorService.navigateTo(
                        RouteNames.adminGeracaoDocumentos,
                      );
                    },
                  ),

                  MenuNavigationCard(
                    context: context,
                    icon: CupertinoIcons.lock_shield,
                    title: 'Segurança e Permissões',
                    onTap: () {
                      NavigatorService.navigateTo(
                        RouteNames.adminSegurancaEPermissoes,
                      );
                    },
                  ),
                  MenuNavigationCard(
                    context: context,
                    icon: CupertinoIcons.chat_bubble_2_fill,
                    title: 'Comunicação Institicional',
                    onTap: () {
                      NavigatorService.navigateTo(
                        RouteNames.adminComunicacaoInstiticional,
                      );
                    },
                  ),

                  MenuNavigationCard(
                    context: context,
                    icon: CupertinoIcons.person_crop_circle_badge_exclam,
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
                    icon: CupertinoIcons.question_circle,
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
