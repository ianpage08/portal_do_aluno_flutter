import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:portal_do_aluno/features/admin/data/models/aluno.dart';
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
                  'CONTRATO DE PRESTAÇÃO DE SERVIÇOS EDUCACIONAIS',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 16),

                titulo('IDENTIFICAÇÃO DAS PARTES'),

                paragrafo(
                  'CONTRATADA: Associação Educacional Espaço da Criança, inscrita no CNPJ sob nº 15.461.610/0001-94, com sede na Rua Francisco Ferreira dos Santos, nº 282, Centro, Central - BA, CEP 44940-000, doravante denominada ESCOLA.',
                  estilo: estiloTextoPdf,
                ),
                paragrafo(
                  'CONTRATANTE: ${dadosPdfResponsavel.nomeMae}, CPF nº ${dadosPdfResponsavel.cpfMae}, residente em ${dadosPdfEndereco.cidade}/${dadosPdfEndereco.estado}, na qualidade de responsável pelo(a) aluno(a) ${dadosPdfAluno.nome}, CPF nº ${dadosPdfAluno.cpf}, matrícula nº ${dadosPdfAcademicos.numeroMatricula}, doravante denominado(a) ALUNO(A).',
                  estilo: estiloTextoPdf,
                ),

                titulo('CLÁUSULA 1 – OBJETO'),
                paragrafo(
                  'O presente contrato tem por objeto a prestação de serviços educacionais pela ESCOLA ao ALUNO(A), referente ao ano letivo de ${dadosPdfAcademicos.anoLetivo}, na turma ${dadosPdfAcademicos.turma}, turno ${dadosPdfAcademicos.turno}, conforme proposta pedagógica e regimento interno da instituição.',
                  estilo: estiloTextoPdf,
                ),

                titulo('CLÁUSULA 2 – VALIDADE E DOCUMENTAÇÃO'),
                paragrafo(
                  'A validade deste contrato depende da entrega completa da documentação exigida e da inexistência de pendências financeiras junto à ESCOLA. Caso o(a) aluno(a) seja novato(a), deverá apresentar o histórico escolar no prazo máximo de 90 (noventa) dias a partir da data de matrícula, sob pena de cancelamento da mesma.',
                  estilo: estiloTextoPdf,
                ),

                titulo('CLÁUSULA 3 – OBRIGAÇÕES DA ESCOLA'),
                paragrafo(
                  'A ESCOLA compromete-se a ministrar aulas e atividades educacionais de acordo com o calendário escolar, observando as normas do MEC e do sistema de ensino vigente, bem como a disponibilizar corpo docente qualificado e infraestrutura adequada ao processo de ensino-aprendizagem.',
                  estilo: estiloTextoPdf,
                ),

                titulo('CLÁUSULA 4 – CALENDÁRIO E ATIVIDADES'),
                paragrafo(
                  'As aulas e atividades complementares seguirão o calendário escolar anual, podendo sofrer alterações mediante comunicação prévia ao responsável. As atividades extracurriculares poderão ocorrer em horários diferentes dos regulares, mediante autorização do responsável.',
                  estilo: estiloTextoPdf,
                ),

                titulo('CLÁUSULA 5 – RESPONSABILIDADES DA ESCOLA'),
                paragrafo(
                  'Compete exclusivamente à ESCOLA definir o planejamento pedagógico, selecionar materiais didáticos, designar professores, estabelecer critérios de avaliação, bem como fixar o calendário e horários escolares. A ESCOLA poderá alterar professores ou metodologias quando julgar necessário ao bom andamento pedagógico.',
                  estilo: estiloTextoPdf,
                ),

                titulo('CLÁUSULA 6 – RESPONSABILIDADES DO RESPONSÁVEL'),
                paragrafo(
                  'Compete ao responsável financeiro e/ou pedagógico: comparecer às reuniões e eventos escolares, acompanhar o desempenho do(a) aluno(a), manter os dados atualizados e zelar pelo cumprimento das normas internas da instituição.',
                  estilo: estiloTextoPdf,
                ),

                titulo('CLÁUSULA 7 – USO DO UNIFORME E OBJETOS PESSOAIS'),
                paragrafo(
                  'O uso do uniforme escolar é obrigatório durante o período letivo e atividades extracurriculares. A ESCOLA não se responsabiliza por perdas, danos ou furtos de objetos pessoais (celulares, joias, eletrônicos ou similares) nas dependências escolares ou fora delas.',
                  estilo: estiloTextoPdf,
                ),

                titulo('CLÁUSULA 8 – VALOR E CONDIÇÕES DE PAGAMENTO'),
                paragrafo(
                  'Pelos serviços educacionais contratados, o RESPONSÁVEL pagará à ESCOLA o valor anual de R\$ 1.500,00 (um mil e quinhentos reais), podendo ser quitado de forma única ou parcelada em 11 (onze) parcelas mensais de R\$ 150,00, com vencimento no último dia útil de cada mês. A matrícula será confirmada mediante o pagamento da taxa de R\$ 130,00 (cento e trinta reais).',
                  estilo: estiloTextoPdf,
                ),

                titulo('CLÁUSULA 9 – RELAÇÃO ENTRE ESCOLA E RESPONSÁVEL'),
                paragrafo(
                  'A relação entre as partes é de natureza civil e educacional, não configurando vínculo trabalhista, societário ou associativo. Toda comunicação oficial entre ESCOLA e RESPONSÁVEL poderá ser realizada por meios eletrônicos, aplicativos institucionais ou notificações escritas.',
                  estilo: estiloTextoPdf,
                ),

                titulo('CLÁUSULA 10 – FORMA DE PAGAMENTO'),
                paragrafo(
                  'O pagamento poderá ser feito à vista ou de forma parcelada, conforme opção do RESPONSÁVEL no ato da matrícula. Os pagamentos deverão ocorrer até a data de vencimento estipulada. A ESCOLA poderá oferecer descontos promocionais, os quais perderão validade em caso de atraso.',
                  estilo: estiloTextoPdf,
                ),

                titulo('CLÁUSULA 11 – MULTA, JUROS E INADIMPLÊNCIA'),
                paragrafo(
                  'O atraso no pagamento implicará multa de 2% (dois por cento) sobre o valor da parcela em atraso, acrescida de juros de 1% (um por cento) ao mês e correção monetária. Após 60 dias de inadimplência, a ESCOLA poderá suspender a renovação da matrícula e o acesso a serviços complementares, respeitando o direito à continuidade do ensino até o término do período letivo em curso.',
                  estilo: estiloTextoPdf,
                ),

                titulo('CLÁUSULA 12 – RESCISÃO CONTRATUAL'),
                paragrafo(
                  'Este contrato poderá ser rescindido por qualquer das partes mediante aviso prévio de 30 (trinta) dias. Caso o cancelamento ocorra por iniciativa do RESPONSÁVEL, não haverá restituição das parcelas já quitadas, salvo nos casos previstos em lei. A desistência não exime o pagamento das parcelas vencidas até a data da comunicação formal.',
                  estilo: estiloTextoPdf,
                ),

                titulo('CLÁUSULA 13 – DISPOSIÇÕES GERAIS'),
                paragrafo(
                  'O RESPONSÁVEL declara ter pleno conhecimento do regimento escolar e da proposta pedagógica da instituição, comprometendo-se a respeitar as normas internas e decisões administrativas da ESCOLA. Situações não previstas neste contrato serão resolvidas de comum acordo entre as partes, respeitada a legislação vigente.',
                  estilo: estiloTextoPdf,
                ),

                titulo('CLÁUSULA 14 – FORO'),
                paragrafo(
                  'Fica eleito o foro da comarca de Central – Bahia para dirimir quaisquer controvérsias oriundas deste contrato, com renúncia expressa a qualquer outro, por mais privilegiado que seja.',
                  estilo: estiloTextoPdf,
                ),

                pw.SizedBox(height: 40),
                pw.Text(
                  'Central – BA, ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
                  style: estiloTextoPdf,
                ),
                pw.SizedBox(height: 24),

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

  pw.Widget titulo(String titulo) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 12, bottom: 4),
      child: pw.Text(
        titulo,
        style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  pw.Widget paragrafo(String texto, {required pw.TextStyle estilo}) {
    return pw.Text(texto, style: estilo, textAlign: pw.TextAlign.justify);
  }
}
