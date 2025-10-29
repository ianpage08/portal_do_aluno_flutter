import 'package:flutter/material.dart';

class SelectedProvider extends ChangeNotifier {
  final Map<String, Map<String, String>> _selectedItems = {};

  /// Define o item selecionado de um dropdown específico
  void selectItem(String dropId, String id, String nome) {
    _selectedItems[dropId] = {'id': id, 'nome': nome};
    debugPrint('✅ SelectedProvider: Item selecionado para $dropId - ID: $id, Nome: $nome');
    notifyListeners(); // ✅ Garante que os listeners sejam notificados
  }

  /// Retorna o nome do item selecionado de um dropdown
  String? getNome(String dropId) {
    final nome = _selectedItems[dropId]?['nome'];
    debugPrint('🔍 SelectedProvider: getNome($dropId) = $nome');
    return nome;
  }

  /// Retorna o id do item selecionado de um dropdown
  String? getId(String dropId) {
    final id = _selectedItems[dropId]?['id'];
    debugPrint('🔍 SelectedProvider: getId($dropId) = $id');
    return id;
  }


  

  /// Limpa a seleção de um dropdown específico
  void limparDrop(String dropId) {
    _selectedItems.remove(dropId);
    debugPrint('🧹 SelectedProvider: Seleção limpa para $dropId');
    notifyListeners();
  }
}