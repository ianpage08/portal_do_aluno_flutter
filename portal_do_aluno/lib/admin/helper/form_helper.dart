import 'package:flutter/cupertino.dart';

class FormHelper {
  static bool isFormValid({required GlobalKey<FormState> formKey,required List<TextEditingController> listControllers}) {  
    if(!formKey.currentState!.validate()) {
      return false;
    }
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return false;
    }
    
    for (var controller in listControllers){
      if(controller.text.trim().isEmpty){
        return false;
      }
    }

    

    return true;
  }
  static void limparControllers({required List<TextEditingController> controllers}){
    for(var controller in controllers){
      controller.clear();
    }
  }
  
}