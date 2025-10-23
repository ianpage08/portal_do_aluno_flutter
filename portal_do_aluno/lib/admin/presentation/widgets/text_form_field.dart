import 'package:flutter/material.dart';

class TextFormFieldPersonalizado extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final int? maxlength;
  final int? minLines;
  final int? maxLines;
  final String? Function(String? value)? validator;
  final TextInputType? keyboardType;
  

  const TextFormFieldPersonalizado({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.maxlength,
    this.minLines,
    this.maxLines,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxlength,
      minLines: minLines,
      maxLines: maxLines,
      controller: controller,
      decoration: InputDecoration(
        label: Text(label, style: const TextStyle(fontSize: 18)),
        hintText: hintText,
        prefixIcon: prefixIcon, //icone inicio
        suffixIcon: suffixIcon, // icono final

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true, //ativa a cor de fundo
        fillColor: const Color.fromARGB(15, 72, 1, 204),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            width: 2,
            color: Color.fromARGB(255, 2, 104, 187),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color.fromARGB(255, 161, 2, 68)),
        ),
      ),
      validator: validator,
      keyboardType: keyboardType,
    );
  }
}
