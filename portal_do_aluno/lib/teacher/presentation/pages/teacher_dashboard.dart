import 'package:flutter/material.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/menu_navigation_card.dart';
import 'package:portal_do_aluno/core/app_constants/colors.dart';
import 'package:portal_do_aluno/core/user/user.dart';
import 'package:portal_do_aluno/navigation/navigation_sevice.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});

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
        title: 'Area do Professor',
        backGround: AppColors.teacher,
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
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.teacher,
                      child: Icon(Icons.person, size: 30, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Professor: ${usuario.name} ',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text('Escola: Associação Educacional'),
                        ],
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
                    icon: Icons.school,
                    title: 'Frequência',
                    onTap: () {
                      NavigatorService.navigateTo(RouteNames.adminFrequencia);
                    },
                  ),
                  MenuNavigationCard(
                    context: context,
                    icon: Icons.assignment,
                    title: 'Lançar Notas',
                    onTap: () {
                      NavigatorService.navigateTo(RouteNames.boletim);
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
                    icon: Icons.class_,
                    title: 'Minhas Turmas',
                    onTap: () {
                      NavigatorService.navigateTo(RouteNames.teacherClasses);
                    },
                  ),
                  MenuNavigationCard(
                    context: context,
                    icon: Icons.event,
                    title: 'calendario Escolar',
                    onTap: () {
                      NavigatorService.navigateTo(RouteNames.teacherCalendar);
                    },
                  ),
                  MenuNavigationCard(
                    context: context,
                    icon: Icons.message,
                    title: 'Comunicados',
                    onTap: () {
                      NavigatorService.navigateTo(
                        RouteNames.comunicadosProfessor,
                      );
                    },
                  ),
                  MenuNavigationCard(
                    context: context,
                    icon: Icons.settings,
                    title: 'Configurações',
                    onTap: () {},
                  ),
                  MenuNavigationCard(
                    context: context,
                    icon: Icons.help,
                    title: 'Ajuda',
                    onTap: () {
                      NavigatorService.navigateTo(RouteNames.taskDetails);
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
