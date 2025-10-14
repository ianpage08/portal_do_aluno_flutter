import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portal_do_aluno/admin/data/models/aluno.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class MatriculaService {
  Stream<QuerySnapshot> getMatriculas() {
    return _firestore.collection('matriculas').snapshots();
  }

  final CollectionReference matriculasColletion = _firestore.collection(
    'matriculas',
  );

 Future<void> cadastrarAlunoCompleto({
  required DadosAluno dadosAluno,
  required EnderecoAluno enderecoAluno,
  required ResponsaveisAluno responsaveisAluno,
  required DadosAcademicos dadosAcademicos,
  required InformacoesMedicasAluno informacoesMedicasAluno,
  required String turmaId, // 👈 Novo parâmetro
}) async {
  // Usamos o ID da turma passada
  final dadoAcademico = dadosAcademicos.copyWith(classId: turmaId);

  // Gerar ID do aluno
  final alunoId = matriculasColletion.doc().id;
  final novoAluno = dadosAluno.copyWith(id: alunoId);

  final alunoJson = {
    'dadosAluno': novoAluno.toJson(),
    'enderecoAluno': enderecoAluno.toJson(),
    'responsaveisAluno': responsaveisAluno.toJson(),
    'dadosAcademicos': dadoAcademico.toJson(),
    'informacoesMedicasAluno': informacoesMedicasAluno.toJson(),
  };

  await matriculasColletion.doc(alunoId).set(alunoJson);
}


  Future<void> excluirMatricula(String matriculaId) async {
    await matriculasColletion.doc(matriculaId).delete();
  }
}
