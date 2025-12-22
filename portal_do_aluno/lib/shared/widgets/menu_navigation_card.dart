import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/theme/glass_card.dart';

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
    return GlassCard(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 38, color: Theme.of(context).iconTheme.color),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
