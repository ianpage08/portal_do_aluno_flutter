import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Busca o alunoId (ID da matrícula) do usuário logado usando o CPF como chave única
/// O CPF é obtido do documento do usuário em 'usuarios/{uid}'
/// Em seguida, busca a matrícula em 'matriculas' onde 'dadosAluno.cpf' == cpf
Future<String?> getAlunoIdFromFirestore() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    debugPrint('❌ Usuário não logado');
    return null;
  }

  try {
    // 1. Buscar o CPF do usuário logado no documento 'usuarios'
    final userDoc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user.uid)
        .get();

    if (!userDoc.exists) {
      debugPrint('❌ Documento do usuário não encontrado em "usuarios"');
      return null;
    }

    final data = userDoc.data()!;
    final cpf = data['cpf'] as String?;
    if (cpf == null || cpf.isEmpty) {
      debugPrint('❌ Campo "cpf" não encontrado ou vazio no documento do usuário');
      return null;
    }

    debugPrint('🔍 Buscando matrícula para CPF: $cpf');

    // 2. Buscar a matrícula usando o CPF (único)
    final matriculaQuery = await FirebaseFirestore.instance
        .collection('matriculas')
        .where('dadosAluno.cpf', isEqualTo: cpf)
        .limit(1)
        .get();

    if (matriculaQuery.docs.isEmpty) {
      debugPrint('❌ Nenhuma matrícula encontrada para o CPF: $cpf');
      return null;
    }

    // 3. Retornar o ID da matrícula (que é o alunoId)
    final matriculaId = matriculaQuery.docs.first.id;
    debugPrint('✅ AlunoId (ID da matrícula) encontrado: $matriculaId');
    return matriculaId;

  } catch (e) {
    debugPrint('❌ Erro ao buscar alunoId por CPF: $e');
    return null;
  }
}

/// Função opcional para adicionar CPF ao usuário (se não existir)
Future<void> adicionarCpfAoUsuario(String cpf) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .update({'cpf': cpf});
      debugPrint('✅ CPF adicionado ao usuário');
    } catch (e) {
      debugPrint('❌ Erro ao adicionar CPF: $e');
    }
  }
}