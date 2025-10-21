import 'package:flutter/material.dart';
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
                  _buildMenuCard(context, Icons.school, 'Frequência', () {
                    NavigatorService.navigateTo(RouteNames.adminFrequencia);
                  }),
                  _buildMenuCard(context, Icons.assignment, 'Lançar Notas', () {
                    NavigatorService.navigateTo(RouteNames.boletim);
                  }),
                  _buildMenuCard(
                    context,
                    Icons.menu_book,
                    'Conteúdo da Aula',
                    () {
                      NavigatorService.navigateTo(RouteNames.addOqueFoiDado);
                    },
                  ),
                  _buildMenuCard(context, Icons.class_, 'Minhas Turmas', () {
                    NavigatorService.navigateTo(RouteNames.teacherClasses);
                  }),
                  _buildMenuCard(
                    context,
                    Icons.event,
                    'calendario Escolar',
                    () {
                      NavigatorService.navigateTo(RouteNames.teacherCalendar);
                    },
                  ),
                  _buildMenuCard(context, Icons.message, 'Mensagens', () {
                    NavigatorService.navigateTo(RouteNames.teacherCalendar);
                  }),
                  _buildMenuCard(
                    context,
                    Icons.settings,
                    'Configurações',
                    () {},
                  ),
                  _buildMenuCard(context, Icons.help, 'Ajuda', () {
                    NavigatorService.navigateTo(RouteNames.taskDetails);
                  }),
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
