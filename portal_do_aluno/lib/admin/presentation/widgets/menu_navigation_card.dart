import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/app_constants/colors.dart';

class MenuNavigationCard extends StatelessWidget {
  final BuildContext context;
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const MenuNavigationCard({
    super.key,
    required this.context,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
