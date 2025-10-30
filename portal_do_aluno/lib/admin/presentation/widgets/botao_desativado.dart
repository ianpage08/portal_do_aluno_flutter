import 'package:flutter/material.dart';

class BotaoDesativado extends StatelessWidget {
  final String label;
  final IconData? icon;
  const BotaoDesativado({super.key, required this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[300], // fundo desabilitado
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[600], // texto desabilitado
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
