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
  }) async {
    final alunoJson = {
      'dadosAluno': dadosAluno.toJson(),
      'enderecoAluno': enderecoAluno.toJson(),
      'responsaveisAluno': responsaveisAluno.toJson(),
      'dadosAcademicos': dadosAcademicos.toJson(),
      'informacoesMedicasAluno': informacoesMedicasAluno.toJson(),
    };
    await matriculasColletion.add(alunoJson);
  }

  Future<DocumentSnapshot> buscarAlunoPorCpf(String cpf) async {
    final query = await matriculasColletion.where('dadosAluno.cpf', isEqualTo: cpf).get();
    if(query.docs.isEmpty){
      throw Exception('Aluno não encontrado');
    }else{
      return query.docs.first;
    }
  }
}
