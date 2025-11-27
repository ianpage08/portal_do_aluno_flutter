import 'package:flutter/cupertino.dart';

class FormHelper {
  // Valida o formulário e verifica se todos os controllers foram preenchidos.
  static bool isFormValid({
    required GlobalKey<FormState> formKey,
    required List<TextEditingController> listControllers,
  }) {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return false;
    }
    // Verifica controllers vazios
    for (var controller in listControllers) {
      if (controller.text.trim().isEmpty) {
        return false;
      }
    }

    return true;
  }

  // Limpa todos os TextEditingController
  static void limparControllers({
    required List<TextEditingController> controllers,
  }) {
    for (var controller in controllers) {
      controller.clear();
    }
  }
}
