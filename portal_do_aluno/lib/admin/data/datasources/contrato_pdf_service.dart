import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:portal_do_aluno/admin/data/models/aluno.dart';
import 'package:pdf/widgets.dart' as pw;

class ContratoPdfService {
  Future<Uint8List> gerarContratoPdf({
    required DadosAluno dadosPdfAluno,
    required DadosAcademicos dadosPdfAcademicos,
    required ResponsaveisAluno dadosPdfResponsavel,
    required EnderecoAluno dadosPdfEndereco,
  }) async {
    final pdf = pw.Document();
    const pw.TextStyle estiloTextoPdf = pw.TextStyle(fontSize: 12, height: 1.5);

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Padding(
            padding: const pw.EdgeInsets.all(16),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'CONTRATO DE MATRÍCULA',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 16),

                _clausula(
                  'Pelo presente instrumento particular, de um lado Associação Educacional Espaço da Criança, inscrita no CNPJ sob nº 015.461.610/0001-941, com sede em rua professor rosalvo ferreria dos santos, doravante denominada Associação Educacional Espaço da Criaça, e de outro lado ${dadosPdfResponsavel.nomeMae}, portador(a) do CPF nº ${dadosPdfResponsavel.cpfMae}, residente à ${dadosPdfEndereco.cidade}/${dadosPdfEndereco.estado}, na qualidade de responsável pelo(a) aluno(a) ${dadosPdfAluno.nome}, matrícula nº ${dadosPdfAcademicos.numeroMatricula}, doravante denominado “ALUNO”, têm entre si justo e contratado o seguinte:',
                  estilo: estiloTextoPdf,
                ),

                _tituloClausula('CLÁUSULA 1: OBJETO'),
                _clausula(
                  'O presente contrato tem por objeto a matrícula do(a) aluno(a) na ${dadosPdfAcademicos.turma} para o ano letivo de ${dadosPdfAcademicos.anoLetivo}, no turno ${dadosPdfAcademicos.turno}, garantindo o acesso às atividades escolares, material didático e serviços oferecidos pela Instituição.',
                  estilo: estiloTextoPdf,
                ),

                _tituloClausula('CLÁUSULA 2: OBRIGAÇÕES DO RESPONSÁVEL'),
                _clausula(
                  'Efetuar o pagamento das mensalidades e demais encargos nos prazos estipulados.\nZelar pela frequência e pontualidade do(a) aluno(a).\nInformar à Instituição quaisquer alterações cadastrais, médicas ou de contato.',
                  estilo: estiloTextoPdf,
                ),

                _tituloClausula('CLÁUSULA 3: OBRIGAÇÕES DA INSTITUIÇÃO'),
                _clausula(
                  'Proporcionar ensino de qualidade conforme o currículo aprovado.\nGarantir ambiente seguro, adequado e respeitoso.\nFornecer comprovantes, boletins e relatórios escolares conforme necessidade.',
                  estilo: estiloTextoPdf,
                ),

                _tituloClausula('CLÁUSULA 4: RESCISÃO'),
                _clausula(
                  'O contrato poderá ser rescindido:\nPor iniciativa do responsável, mediante aviso prévio de 10 dias e quitação de débitos.\nPor descumprimento das normas escolares pelo aluno ou responsável.',
                  estilo: estiloTextoPdf,
                ),

                _tituloClausula('CLÁUSULA 5: DADOS MÉDICOS E AUTORIZAÇÕES'),
                _clausula(
                  'O responsável declara que as informações médicas fornecidas à Instituição são verdadeiras e autoriza a administração de medicamentos ou cuidados de emergência, quando necessário.',
                  estilo: estiloTextoPdf,
                ),

                _tituloClausula('CLÁUSULA 6: DISPOSIÇÕES FINAIS'),
                _clausula(
                  'Fica eleito o foro da comarca de Central - Bahia para dirimir quaisquer questões oriundas deste contrato.\nEste contrato entra em vigor na data de sua assinatura.\nCidade, ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
                  estilo: estiloTextoPdf,
                ),

                pw.SizedBox(height: 40),
                pw.Text(
                  '__________________________________\nAssinatura do Responsável',
                  style: estiloTextoPdf,
                ),
                pw.SizedBox(height: 24),
                pw.Text(
                  '__________________________________\nAssinatura da Instituição',
                  style: estiloTextoPdf,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _tituloClausula(String titulo) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 12, bottom: 4),
      child: pw.Text(
        titulo,
        style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  pw.Widget _clausula(String texto, {required pw.TextStyle estilo}) {
    return pw.Text(texto, style: estilo, textAlign: pw.TextAlign.justify);
  }
}
