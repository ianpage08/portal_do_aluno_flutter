import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/app_constants/colors.dart';
import 'package:portal_do_aluno/navigation/navigation_sevice.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
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
              // Aqui você pode implementar notificações ou mensagens
              // Por enquanto, só um exemplo de snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Nenhuma nova notificação')),
              );
            },
          ),
          IconButton(
            onPressed: () {
              // Usar NavigatorService para logout e navegação consistente
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
            const Card(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.primary,
                      child: Icon(Icons.person, size: 30, color: Colors.white),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bem vindo, Ian page Maciel!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('Turma: 10º Ano - A'),
                          Text('Escola: Associação Educacional'),
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
                mainAxisSpacing: 16,
                children: [
                  _buildMenuCard(
                    context,
                    Icons.school,
                    'Notas e Frequência',
                    () {
                      NavigatorService.navigateTo(RouteNames.studentGrades);
                    },
                  ),
                  _buildMenuCard(context, Icons.assignment, 'Tarefas', () {
                    NavigatorService.navigateTo(RouteNames.studentTasks);
                  }),
                  _buildMenuCard(
                    context,
                    Icons.event,
                    'Calendário Escolar',
                    () {
                      NavigatorService.navigateTo(RouteNames.studentCalendar);
                    },
                  ),
                  _buildMenuCard(context, Icons.message, 'Comunicado', () {
                    // Se tiver uma página de mensagens, navegue para ela
                    // Por enquanto, só um exemplo de snackbar
                    NavigatorService.navigateTo(RouteNames.studentComunicados);
                  }),
                  _buildMenuCard(context, Icons.settings, 'Configurações', () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Funcionalidade em desenvolvimento'),
                      ),
                    );
                  }),
                  _buildMenuCard(context, Icons.help, 'Ajuda', () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Funcionalidade em desenvolvimento'),
                      ),
                    );
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
          padding: const EdgeInsets.all(16),
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
      ),
    );
  }
}
