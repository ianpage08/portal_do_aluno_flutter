import 'package:flutter/cupertino.dart';

class FormHelper {
  static bool isFormValid(GlobalKey<FormState> formKey, List<TextEditingController> controllers) {  
    if(!formKey.currentState!.validate()) {
      return false;
    }
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return false;
    }
    
    for (var controller in controllers){
      if(controller.text.trim().isEmpty){
        return false;
      }
    }

    

    return true;
  }
  static void limparControllers(List<TextEditingController> controllers){
    for(var controller in controllers){
      controller.clear();
    }
  }
  
}