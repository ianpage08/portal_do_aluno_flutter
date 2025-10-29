import 'package:flutter/material.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/menu_navigation_card.dart';
import 'package:portal_do_aluno/core/app_constants/colors.dart';
import 'package:portal_do_aluno/core/user/user.dart';
import 'package:portal_do_aluno/navigation/navigation_sevice.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  @override
  Widget build(BuildContext context) {
    final argumentos =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (argumentos == null || argumentos['user'] == null) {
      return const Scaffold(
        body: Center(child: Text('Erro ao carregar dados do usuário')),
      );
    }

    final Map<String, dynamic> userMap = argumentos['user'];
    final Usuario usuario = Usuario.fromJson(userMap);

    //

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Dashboard do Aluno'),
        backgroundColor: AppColors.student,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Por enquanto, só um exemplo de snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Nenhuma nova notificação')),
              );
            },
          ),
          IconButton(
            onPressed: () {
              NavigatorService.logout();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.primary,
                      child: Icon(Icons.person, size: 30, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bem vindo, ${usuario.name}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text('Turma: 10º Ano - A'),
                          const Text('Escola: Associação Educacional'),
                        ],
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
                        arguments: {'user': usuario.toJsonSafe()},
                      );
                    },
                  ),
                  MenuNavigationCard(
                    context: context,
                    icon: Icons.assignment,
                    title: 'Tarefas',
                    onTap: () {
                      NavigatorService.navigateTo(RouteNames.studentTasks);
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
