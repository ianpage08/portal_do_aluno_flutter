import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

bool _pickerAtivo = false;
Future<List<XFile>> getImage() async {
  if (_pickerAtivo) return [];

  _pickerAtivo = true;

  try {
    final ImagePicker picker = ImagePicker();
    final List<XFile> imagens = await picker.pickMultiImage(
      limit: 10,
      imageQuality: 60,
    );
    if (imagens.isEmpty) {
      debugPrint('Nenhuma imagem selecionada');
      return [];
    }
    if (imagens.isNotEmpty) {
      debugPrint('imagens Selecionadas : ${imagens.length}');
      debugPrint(imagens.first.path);
    }
    return imagens;
  } catch (e) {
    debugPrint('erro ao selecionar imagem: ${e.toString()}');
  } finally {
    _pickerAtivo = false;
  }
  return [];
}
