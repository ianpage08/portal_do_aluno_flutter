import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portal_do_aluno/admin/data/models/frequencia.dart';

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

  Future<int> calcularQuantidadeDeFrequenciaPorpresenca({
    
    required String tipoPresenca,
  }) async {
    final qtdFrequencia = await frequenciasCollection
        .where('presenca', isEqualTo: tipoPresenca)
        .get();
        
    return qtdFrequencia.docs.length;
  }
}
