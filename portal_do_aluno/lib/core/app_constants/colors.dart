import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF0E0B1F); // Fundo principal
  static const Color darkCard = Color(0xFF1E1B2E); // Containers / Cards
  static const Color darkPrimary = Color(0xFF7C3AED); // Roxo principal
  static const Color darkSecondary = Color(0xFF8B5CF6); // Roxo secundário
  static const Color darkTextPrimary = Color(0xFFEDE9FE); // Texto principal
  static const Color darkTextSecondary = Color(0xFFA78BFA); // Texto secundário
  static const Color darkButton = Color(0xFF1E88E5);
  static const Color darkIcon = Color(0xFFC4B5FD); // Ícones
  static const Color darkError = Color(0xFFF43F5E); // Erro
  static const Color darkSuccess = Color(0xFF10B981); // Sucesso
  static const Color darkAppBar = Color(0xFF2E003E);

  // Light Theme Colors
  static const Color appBar = Color(0xFFD6DEE7); // Cinza azulado claro — estilo
  // Fundo AppBar
  static const Color lightPrimary = Color(
    0xFF3A6EA5,
  ); // Azul elegante (botões e destaques)
  static const Color lightSecondary = Color(
    0xFF5C86C5,
  ); // Azul mais suave para realces
  static const Color lightBackground = Color(
    0xFFF7F8FA,
  ); // Fundo quase branco com leve toque azulado
  static const Color lightCard = Color(
    0xFFFFFFFF,
  ); // Cartões e painéis brancos limpos
  static const Color lightTextPrimary = Color(
    0xFF1C1C1E,
  ); // Preto-acinzentado típico do iOS
  static const Color lightTextSecondary = Color(
    0xFF5E5E68,
  ); // Cinza médio para textos secundários
  static const Color lightIcon = Color(0xFF3A6EA5); // Ícones em azul frio
  static const Color lightBorder = Color.fromARGB(
    255,
    198,
    198,
    238,
  ); // Bordas e divisores sutis
  static const Color lightInputFill = Color(
    0xFFF2F3F6,
  ); // Campos de texto em cinza bem claro
  static const Color lightButton = Color(0xFF007BFF); // Botões no tom principal
  static const Color lightSuccess = Color(0xFF34C759); // Verde iOS
  static const Color lighTerror = Color(0xFFFF3B30); // Vermelho iOS
  static const Color lighThint = Color(0xFF8E8E93); // Placeholders e dicas

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
