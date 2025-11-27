import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/data/models/aluno.dart';


class AlunoCompleto {
  final String turmaId;
  final DadosAluno dadosAluno;
  final EnderecoAluno enderecoAluno;
  final ResponsaveisAluno responsaveisAluno;
  final DadosAcademicos dadosAcademicos;
  final InformacoesMedicasAluno informacoesMedicas;

  AlunoCompleto({
    required this.turmaId,
    required this.dadosAluno,
    required this.enderecoAluno,
    required this.responsaveisAluno,
    required this.dadosAcademicos,
    required this.informacoesMedicas,
  });
}

class AlunoBuilder {
  /// Cria todos os modelos do aluno completo a partir dos controladores e valores selecionados
  static AlunoCompleto criarAlunoCompleto({
    // Identificadores
    required String turmaId,

    // Dados Pessoais
    required TextEditingController nomeController,
    required TextEditingController cpfController,
    required String? sexoSelecionado,
    required TextEditingController naturalidadeController,
    required DateTime dataSelecionada,

    // Endereço
    required TextEditingController cepController,
    required TextEditingController ruaController,
    required TextEditingController numeroController,
    required TextEditingController bairroController,
    required TextEditingController cidadeController,
    required TextEditingController estadoController,

    // Responsáveis
    required TextEditingController nomeMaeController,
    required TextEditingController cpfMaeController,
    required TextEditingController telefoneMaeController,
    required TextEditingController nomePaiController,
    required TextEditingController cpfPaiController,
    required TextEditingController telefonePaiController,

    // Dados Acadêmicos
    required TextEditingController numeroMatriculaController,
    required TextEditingController turmaController,
    required TextEditingController anoLetivoController,
    required String? turnoSelecionado,
    required TextEditingController situacaoController,

    // Informações Médicas
    required TextEditingController alergiasController,
    required TextEditingController medicamentosController,
    required TextEditingController observacoesController,
  }) {
    final dadosAluno = DadosAluno(
      nome: nomeController.text,
      cpf: cpfController.text,
      sexo: sexoSelecionado ?? '',
      naturalidade: naturalidadeController.text,
      dataNascimento: dataSelecionada,
    );

    final enderecoAluno = EnderecoAluno(
      cep: cepController.text,
      rua: ruaController.text,
      numero: numeroController.text,
      bairro: bairroController.text,
      cidade: cidadeController.text,
      estado: estadoController.text,
    );

    final responsaveisAluno = ResponsaveisAluno(
      nomeMae: nomeMaeController.text,
      cpfMae: cpfMaeController.text,
      telefoneMae: telefoneMaeController.text,
      nomePai: nomePaiController.text,
      cpfPai: cpfPaiController.text,
      telefonePai: telefonePaiController.text,
    );

    final dadosAcademicos = DadosAcademicos(
      numeroMatricula: numeroMatriculaController.text,
      turma: turmaController.text,
      anoLetivo: anoLetivoController.text,
      turno: turnoSelecionado ?? '',
      situacao: situacaoController.text,
      dataMatricula: DateTime.now(),
      classId: turmaId,
    );

    final informacoesMedicas = InformacoesMedicasAluno(
      alergia: alergiasController.text,
      medicacao: medicamentosController.text,
      observacoes: observacoesController.text,
    );

    return AlunoCompleto(
      turmaId: turmaId,
      dadosAluno: dadosAluno,
      enderecoAluno: enderecoAluno,
      responsaveisAluno: responsaveisAluno,
      dadosAcademicos: dadosAcademicos,
      informacoesMedicas: informacoesMedicas,
    );
  }
}
