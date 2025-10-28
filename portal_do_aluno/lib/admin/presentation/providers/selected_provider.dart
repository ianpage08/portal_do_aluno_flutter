import 'package:flutter/material.dart';

class SelectedProvider extends ChangeNotifier {
  String? itemId;
  String? itemNome;

  void selectItem(String id, String nome) {
    itemId = id;
    itemNome = nome;
    notifyListeners();
  }

  void limpar() {
    itemId = null;
    itemNome = null;
    notifyListeners();
  }
}
