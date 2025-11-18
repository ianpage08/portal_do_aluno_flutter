import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

Future<List<String>> uploadImagensExercicio(
  List<XFile> imagens,
  String exerciciosId,
  String alunoId,
) async {
  List<String> urls = [];

  if (imagens.isEmpty) return [];
  for (var imagem in imagens) {
    final file = File(imagem.path);
    // caminho para o Firebase Store
    final ref = FirebaseStorage.instance.ref().child(
      'exercicios/$exerciciosId/$alunoId/${imagem.name}',
    );
    // upload de imagem 
    final uploadTask = await ref.putFile(file);
    final url = await uploadTask.ref.getDownloadURL();
    urls.add(url);

  }
  return urls;
}
