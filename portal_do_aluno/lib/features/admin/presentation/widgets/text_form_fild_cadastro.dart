import 'package:flutter/material.dart';

class CadastroTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final Icon ico;
  final String labelText;
  final String hintText;
  final TextInputType? keyboardType;
  const CadastroTextFormField({
    super.key,
    required this.controller,
    required this.ico,
    required this.labelText,
    required this.hintText,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            width: 2,
            color: Color.fromARGB(255, 74, 1, 92),
          ),
        ),
        hintText: hintText,
        labelText: labelText,
        prefixIcon: ico,
        filled: true,
        fillColor: const Color.fromARGB(15, 72, 1, 204),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (value == null) {
          return 'Campo obrigatório';
        }
        return null;
      },
    );
  }
}
