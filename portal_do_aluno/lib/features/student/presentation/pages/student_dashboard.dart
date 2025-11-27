import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/data/datasources/tokens_firestore.dart';
import 'package:portal_do_aluno/features/admin/presentation/providers/user_provider.dart';
import 'package:portal_do_aluno/shared/widgets/menu_navigation_card.dart';
import 'package:portal_do_aluno/shared/widgets/firestore/stream_referencia_id.dart';

import 'package:portal_do_aluno/core/user/user.dart';
import 'package:portal_do_aluno/navigation/navigation_sevice.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';
import 'package:provider/provider.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  bool _updateToken = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final argumentos =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (argumentos != null && argumentos['user'] != null) {
        final userId = argumentos['user']['id'];
        Provider.of<UserProvider>(context, listen: false).setUserId(userId);
      }
    });
  }

  // remover depois  did ou init
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_updateToken) {
      final argumentos =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (argumentos != null && argumentos['user'] != null) {
        final userId = argumentos['user']['id'];
        TokensService().gerarToken(userId);
        _updateToken = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuarioId = Provider.of<UserProvider>(context).userId;
    if (usuarioId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'DashboardAluno',
        nameRoute: RouteNames.studentComunicados,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: MeuStreamBuilder(
                        collectionPath: 'usuarios',
                        documentId: usuarioId,
                        builder: (context, snapshot) {
                          final data = snapshot.data!.data()!;

                          final dadosUsuario = Usuario.fromJson(data);
                          return Row(
                            children: [
                              const CircleAvatar(
                                radius: 30,
                                backgroundColor: Color.fromARGB(
                                  255,
                                  88,
                                  70,
                                  20,
                                ),
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
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                    Text(
                                      'Escola: AEEC',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleSmall,
                                    ),
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
            const SizedBox(height: 10),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                childAspectRatio: 1.2,
                mainAxisSpacing: 16,
                children: [
                  // MenuNavigationCard: widget personalizado dos botões do menu.
                  // - NavigationService e RouteNames: controle de rotas e nomes das páginas personalizados.
                  MenuNavigationCard(
                    context: context,
                    icon: Icons.school,
                    title: 'Notas e Frequência',
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RouteNames.studentBoletim,
                        arguments: {'user': usuarioId},
                      );
                    },
                  ),
                  MenuNavigationCard(
                    context: context,
                    icon: Icons.assignment,
                    title: 'Tarefas',
                    onTap: () {
                      NavigatorService.navigateTo(RouteNames.studentExercicios);
                    },
                  ),
                  MenuNavigationCard(
                    context: context,
                    icon: Icons.event,
                    title: 'Calendário Escolar',
                    onTap: () {
                      NavigatorService.navigateTo(RouteNames.studentCalendar);
                    },
                  ),
                  MenuNavigationCard(
                    context: context,
                    icon: Icons.message,
                    title: 'Comunicado',
                    onTap: () {
                      NavigatorService.navigateTo(
                        RouteNames.studentComunicados,
                      );
                    },
                  ),
                  MenuNavigationCard(
                    context: context,
                    icon: Icons.settings,
                    title: 'Configurações',
                    onTap: () {
                      NavigatorService.navigateTo(RouteNames.studentSettings);
                    },
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
