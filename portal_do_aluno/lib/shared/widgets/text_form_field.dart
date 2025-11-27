import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldPersonalizado extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? hintText;
  final IconData? prefixIcon;
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
    this.label,
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
    this.fillColor,
    this.inputFormatters,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 14,
    ),
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {

    final Color borderColor =
        Theme.of(context).dividerColor.withOpacity(0.4);

    final Color focusColor =
        Theme.of(context).colorScheme.primary.withOpacity(0.9);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(20, 0, 0, 0),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        obscureText: obscureText,
        controller: controller,
        maxLength: maxLength,
        minLines: minLines ?? 1,
        maxLines: obscureText ? 1 : (maxLines ?? 1),
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
          counterText: "",
          labelText: label,
          hintText: hintText,

          // ---------- ÍCONES ----------
          prefixIcon: prefixIcon != null
              ? Icon(
                  prefixIcon,
                  color: Theme.of(context).iconTheme.color,
                )
              : null,
          suffixIcon: suffixIcon,

          // ---------- FILL ----------
          filled: true,
          fillColor: fillColor ?? Theme.of(context).cardColor,

          // ---------- PADDING ----------
          contentPadding: contentPadding,

          // ---------- BORDAS ----------
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: borderColor,
              width: 1.3,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: focusColor,
              width: 2,
            ),
          ),

          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2,
            ),
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
