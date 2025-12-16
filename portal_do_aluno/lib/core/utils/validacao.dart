

String? validarCpf(String? value) {
  if (value == null || value.isEmpty) {
    return 'CPF obrigatório';
  }

  final cpfLimpo = value.replaceAll(RegExp(r'[^0-9]'), '');

  if (cpfLimpo.length != 11) {
    return 'CPF deve conter 11 dígitos';
  }

  return null;
}

String? validarSenha(String? value) {
  if (value == null || value.isEmpty) {
    return 'Senha obrigatória';
  }

  if (value.length < 6) {
    return 'Mínimo de 6 caracteres';
  }

  final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(value);
  final hasNumber = RegExp(r'\d').hasMatch(value);
  final hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);

  if (!hasLetter || !hasNumber || !hasSpecial) {
    return 'Use letras, números e símbolo';
  }

  return null;
}

String? validarInput(String? value) {
  if (value == null || value.isEmpty) {
    return 'Campo obrigatório';
  }
  return null;
}


