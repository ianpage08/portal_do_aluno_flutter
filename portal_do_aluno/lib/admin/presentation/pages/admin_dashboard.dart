import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/app_constants/colors.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.admin,
        title: const Text('Dashboard do Administrador'),
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.logout)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Card(
              child: Padding(
                padding: EdgeInsets.all(6),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.admin,
                      child: Icon(Icons.person, size: 30, color: Colors.white),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Professor: Ian page  Maciel',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('Escola: Associação Educacional'),
                          Text('Disciplina: Matemática'),
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
                  _buildMenuCard(
                    context,
                    Icons.person_add_alt_1_rounded,
                    'Gestão de Usuários',
                    () {},
                  ),
                  _buildMenuCard(context, Icons.home, 'Gestão Escolar', () {}),
                  _buildMenuCard(
                    context,
                    Icons.graphic_eq_rounded,
                    'Relatorio gerencias',
                    () {},
                  ),
                  _buildMenuCard(
                    context,
                    Icons.security_outlined,
                    'Segurança e Permissões',
                    () {},
                  ),
                  _buildMenuCard(
                    context,
                    Icons.message,
                    'Comunicação Institicional',
                    () {},
                  ),
                  _buildMenuCard(
                    context,
                    Icons.dock_outlined,
                    'Gerar Documentos',
                    () {},
                  ),
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
        onTap: null,
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
