import 'package:flutter/services.dart';

class CpfInputFormatter extends TextInputFormatter {
  // Formata os 11 dígitos para 000.000.000-00
  String _formatCpf(String digits) {
    final buffer = StringBuffer();
    final d = digits;
    for (int i = 0; i < d.length && i < 11; i++) {
      buffer.write(d[i]);
      if (i == 2 || i == 5) buffer.write('.');
      if (i == 8) buffer.write('-');
    }
    return buffer.toString();
  }

  // Conta dígitos (0-9) até a posição informada
  int _countDigitsUpTo(String text, int pos) {
    pos = pos.clamp(0, text.length);
    int count = 0;
    for (int i = 0; i < pos; i++) {
      if (RegExp(r'\d').hasMatch(text[i])) count++;
    }
    return count;
  }

  // Mapeia o índice de dígitos (1..n) para a posição no texto formatado
  int _digitIndexToFormattedPos(String formatted, int digitIndex) {
    if (digitIndex <= 0) return 0;
    int seen = 0;
    for (int i = 0; i < formatted.length; i++) {
      if (RegExp(r'\d').hasMatch(formatted[i])) seen++;
      if (seen == digitIndex) return i + 1; // posição após esse dígito
    }
    return formatted.length;
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // 1) Remove tudo que não for dígito
    final onlyDigits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // 2) Limita a 11 dígitos
    final limited = onlyDigits.length > 11 ? onlyDigits.substring(0, 11) : onlyDigits;

    // 3) Formata
    final formatted = _formatCpf(limited);

    // 4) Calcula a nova posição do cursor:
    //    - conta quantos dígitos existiam antes da seleção no newValue.raw
    final digitIndexBefore = _countDigitsUpTo(newValue.text, newValue.selection.baseOffset);
    //    - mapeia esse índice para a posição equivalente no texto formatado
    final newOffset = _digitIndexToFormattedPos(formatted, digitIndexBefore);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: newOffset),
      composing: TextRange.empty,
    );
  }
}
