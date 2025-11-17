import 'package:portal_do_aluno/admin/data/firestore_services/boletim_service.dart';

class BoletimHelper {
  final BoletimService _boletimService = BoletimService();

  // Salva ou atualiza a nota de um aluno.
  // 
  // Lança ArgumentError se algum campo obrigatório estiver vazio ou unidade for inválida.
  // Lança Exception se houver erro no serviço.
  Future<void> salvarNota({
    required String alunoId,
    required String turmaId,
    required String disciplinaNome,
    required String disciplinaId,
    required String unidade,       // Ex: "Unidade 1"
    required String tipoDeNota,   // Ex: "Nota Extra"
    required double nota,
  }) async {
    // Validação básica dos campos
    if (alunoId.isEmpty ||
        turmaId.isEmpty ||
        disciplinaId.isEmpty ||
        disciplinaNome.isEmpty ||
        unidade.isEmpty ||
        tipoDeNota.isEmpty) {
      throw ArgumentError('Todos os campos são obrigatórios.');
    }

    // Parse da unidade
    int unidades;
    try {
      unidades = int.parse(unidade.split(' ')[1]); 
    } catch (_) {
      throw ArgumentError('Unidade inválida: $unidade');
    }

    // Nota válida entre 0.0 e 10.0
    final double notaValida = nota.clamp(0.0, 10.0);

    // Normalizar tipo de nota
    final String tipo = tipoDeNota.toLowerCase().replaceAll(' ', '');

    // Chama o serviço
    try {
      await _boletimService.salvarOuAtualizarNota(
        alunoId: alunoId,
        matriculaId: turmaId,
        disciplinaId: disciplinaId,
        nomeDisciplina: disciplinaNome,
        unidade: unidades,
        tipo: tipo,
        nota: notaValida,
      );
    } catch (e) {
      throw Exception('Erro ao salvar a nota: $e');
    }
  }
}
