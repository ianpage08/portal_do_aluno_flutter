import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldPersonalizado extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final int? maxLength;
  final int? minLines;
  final int? maxLines;
  final bool obrigatorio;
  final String? Function(String? value)? validator;
  final TextInputType? keyboardType;
  final bool enable;
  final Color? fillColor;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsetsGeometry? contentPadding;

  const TextFormFieldPersonalizado({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLength,
    this.minLines,
    this.maxLines,
    this.obrigatorio = true,
    this.validator,
    this.keyboardType,
    this.enable = true,
    this.fillColor = const Color.fromARGB(48, 218, 194, 250),
    this.inputFormatters,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLength: maxLength,
      minLines: minLines,
      maxLines: maxLines,
      enabled: enable,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator ??
          (obrigatorio
              ? (value) => (value == null || value.isEmpty)
                  ? 'Campo obrigatório'
                  : null
              : null),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: fillColor,
        contentPadding: contentPadding,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 28, 1, 104),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}
