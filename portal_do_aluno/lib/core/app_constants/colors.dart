import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF0E0B1F); // Fundo principal
  static const Color darkCard = Color(0xFF1F1536); // Containers / Cards
  static const Color darkPrimary = Color(0xFF7C3AED); // Roxo principal
  static const Color darkSecondary = Color(0xFF8B5CF6); // Roxo secundário
  static const Color darkTextPrimary = Color(0xFFEDE9FE); // Texto principal
  static const Color darkTextSecondary = Color(0xFFA78BFA); // Texto secundário
  static const Color darkIcon = Color(0xFFC4B5FD); // Ícones
  static const Color darkError = Color(0xFFF43F5E); // Erro
  static const Color darkSuccess = Color(0xFF10B981); // Sucesso
  static const Color darkAppBar = Color(0xFF2E003E);
  static const Color primary = Color.fromARGB(255, 36, 1, 87); // roxo
  static const Color student = Color(0xFF2196F3); // azul
  static const Color teacher = Color(0xFF4CAF50); // verde
  static const Color parent = Color(0xFFFF9800); // laranja
  static const Color admin = Color(0xFFF44336); // vermelho
  //cada tipo de usuario vai ter uma com de indentificação visual rapida

  static const Color background = Color(0xFFF5F5F5); // cinza claro

  static const Color error = Color(0xFFB00020); // vermelho escuro

  static Color getUserTypeColor(String userType) {
    switch (userType.toLowerCase()) {
      case 'student':
        return student;
      case 'teacher':
        return teacher;
      case 'parent':
        return parent;
      case 'admin':
        return admin;
      default:
        return const Color(0xFF0E0B1F);
    }
  }
}
