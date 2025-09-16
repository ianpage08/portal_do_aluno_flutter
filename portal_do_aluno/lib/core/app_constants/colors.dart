import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  static const Color primary = Color(0xFF6200EE); // roxo
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
        return primary;
    }
  }
}
