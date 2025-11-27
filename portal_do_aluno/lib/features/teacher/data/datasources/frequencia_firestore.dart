import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portal_do_aluno/features/teacher/data/models/frequencia.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class FrequenciaService {
  final CollectionReference frequenciasCollection = _firestore.collection(
    'frequencias',
  );
  Stream<List<Frequencia>> getFrequencia(String turmaId) {
    return frequenciasCollection
        .where('classId', isEqualTo: turmaId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (item) =>
                    Frequencia.fromJson(item.data() as Map<String, dynamic>),
              )
              .toList(),
        );
  }

  Future<void> salvarFrequenciaPorTurma({
    required String alunoId,
    required String turmaId,
    required Frequencia frequencia,
  }) async {
    // Normaliza a data para comparar apenas o dia (ignorando hora/minuto/segundo)
    final dataDoDia = DateTime(
      frequencia.data.year,
      frequencia.data.month,
      frequencia.data.day,
    );

    // Verifica se já existe frequência do mesmo aluno no mesmo dia e turma
    final query = await frequenciasCollection
        .where('alunoId', isEqualTo: alunoId)
        .where('classId', isEqualTo: turmaId)
        .where(
          'data',
          isGreaterThanOrEqualTo: Timestamp.fromDate(dataDoDia),
          isLessThan: Timestamp.fromDate(
            dataDoDia.add(const Duration(days: 1)),
          ),
        )
        .get();

    if (query.docs.isNotEmpty) {
      // Já existe uma frequência desse aluno nesse dia
      throw Exception('Frequência já registrada para este aluno neste dia.');
    }

    // Caso não exista, salva normalmente
    final docRef = frequenciasCollection.doc();
    final dadoTurma = frequencia.copyWith(
      id: docRef.id,
      classId: turmaId,
      alunoId: alunoId,
    );

    await docRef.set(dadoTurma.toJson());
  }

  Future<void> excluirFrequencia(String frequenciaId) {
    return frequenciasCollection.doc(frequenciaId).delete();
  }

  //Calcula a Presença Geral de todos os alunos
  Future<int> calcularQuantidadeDeFrequenciaPorpresenca({
    required String tipoPresenca,
  }) async {
    final qtdFrequencia = await frequenciasCollection
        .where('presenca', isEqualTo: tipoPresenca)
        .get();

    return qtdFrequencia.docs.length;
  }

  Future<double> calcularQuantidadeDePresencaPorAluno(String alunoId) async {
    final quantidadePresenca = await frequenciasCollection
        .where('alunoId', isEqualTo: alunoId)
        .get();
    //Evita calculo por zero
    if (quantidadePresenca.docs.isEmpty) {
      return 0;
    }

    int presenca = 0;
    int falta = 0;
    int justificativa = 0;

    for (var item in quantidadePresenca.docs) {
      final status = item['presenca'];
      if (status == 'presente') {
        presenca++;
      } else if (status == 'falta') {
        falta++;
      } else if (status == 'justificativa') {
        justificativa++;
      }
    }

    
    int totalDeAula = presenca + falta + justificativa;
    if(totalDeAula ==0){
      return 0.0;
    }
    int totalPresenca = presenca + justificativa;
    
    double calculopercentual = (totalPresenca / totalDeAula) * 100;

    return double.parse(calculopercentual.toStringAsFixed(2));
  }
}
