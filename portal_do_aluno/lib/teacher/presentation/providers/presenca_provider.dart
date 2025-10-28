import 'package:flutter/material.dart';
import 'package:portal_do_aluno/admin/data/models/frequencia.dart';

class PresencaProvider extends ChangeNotifier {
  final Map<String, Presenca> _presencas = {};

  Map<String, Presenca> get presencas => _presencas;

  void marcarPresenca(String alunoId, Presenca presenca) {
    _presencas[alunoId]= presenca;
    notifyListeners();
  }

  void limpar(){
    _presencas.clear();
    notifyListeners();
  }
}
