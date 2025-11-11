import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldPersonalizado extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final Icon? prefixIcon;
  final Widget? suffixIcon;
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
  final bool obscureText;

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
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 14,
    ),
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      controller: controller,
      maxLength: maxLength,
      minLines: minLines,
      maxLines: obscureText ? 1 : (maxLines ?? 1),
      enabled: enable,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator:
          validator ??
          (obrigatorio
              ? (value) => (value == null || value.isEmpty)
                    ? 'Campo obrigatório'
                    : null
              : null),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(
          prefixIcon?.icon,
          color: Theme.of(context).iconTheme.color,
        ),
        suffixIcon: suffixIcon,
        iconColor: Theme.of(context).iconTheme.color,
        filled: true,
        fillColor: fillColor,
        contentPadding: contentPadding,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(
              context,
            ).inputDecorationTheme.enabledBorder!.borderSide.color,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(
              context,
            ).inputDecorationTheme.focusedBorder!.borderSide.color,
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
