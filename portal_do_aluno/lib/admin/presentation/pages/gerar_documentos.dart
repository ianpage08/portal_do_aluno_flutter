import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:portal_do_aluno/admin/data/firestore_services/contrato_pdf_service.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/widget_value_notifier/botao_selecionar_aluno.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/widget_value_notifier/botao_selecionar_turma.dart';
import 'package:printing/printing.dart';
import 'package:portal_do_aluno/admin/data/models/aluno.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/scaffold_messeger.dart';

class GerarDocumentosPage extends StatefulWidget {
  const GerarDocumentosPage({super.key});

  @override
  State<GerarDocumentosPage> createState() => _GerarDocumentosPageState();
}

class _GerarDocumentosPageState extends State<GerarDocumentosPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeAlunoController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _observacoesController = TextEditingController();
  final TextEditingController _anoEscolarController = TextEditingController();
  String? turmaId;
  final ValueNotifier<String?> turmaSelecionada = ValueNotifier<String?>(null);
  String? alunoId;
  final ValueNotifier<String?> alunoSelecionado = ValueNotifier<String?>(null);
  final ContratoPdfService _contratoPdfService = ContratoPdfService();

  Stream<QuerySnapshot<Map<String, dynamic>>> getAlunosPorTurma(
    String turmaId,
  ) {
    return FirebaseFirestore.instance
        .collection('matriculas')
        .where('dadosAcademicos.classId', isEqualTo: turmaId)
        .snapshots();
  }

  String? tipoDeDocumento;
  final List<Map<String, dynamic>> documentos = [
    {
      'nome': 'Certificado',
      'icon': Icons.school,
      'descricao': 'Certificado de conclusão Escolar',
      'cor': Colors.blue,
    },
    {
      'nome': 'Histórico',
      'icon': Icons.edit_document,
      'descricao': 'Historico de notas e carga horaria',
      'cor': Colors.green,
    },
    {
      'nome': 'Declaração',
      'icon': Icons.description,
      'descricao': 'Declaração de matrícula',
      'cor': Colors.deepPurple,
    },
    {
      'nome': 'Relatorio',
      'icon': Icons.analytics,
      'descricao': 'relatorio de desempenho ',
      'cor': Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerar Documentos'),

        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildCardTipoDoc(),
              const SizedBox(height: 16),
              _buildCardInfo(),
              const SizedBox(height: 16),

              const SizedBox(height: 16),
              _buildButoesDeAcao(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardTipoDoc() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.description, color: Colors.deepPurple),
                SizedBox(width: 16),
                Text(
                  'Tipo de Documento',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Selecione o tipo de Documento que deseja gerar'),
            const SizedBox(height: 16),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: documentos.map((doc) {
                return _buildCardDocumento(doc);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardDocumento(Map<String, dynamic> documento) {
    final isSelected = tipoDeDocumento == documento['nome'];

    return GestureDetector(
      onTap: () {
        setState(() {
          tipoDeDocumento = documento['nome'];
        });
      },
      child: Container(
        width: 160,
        height: 160,

        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? (documento['cor'] as Color).withAlpha(25)
              : Colors.white,
          border: Border.all(
            color: isSelected
                ? (documento['cor'] as Color).withAlpha(25)
                : Colors.grey,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(documento['icon'], size: 40, color: documento['cor']),
            const SizedBox(height: 8),
            Text(
              documento['nome'],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: documento['cor'],
              ),
            ),
            Text(
              documento['descricao'],
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.person, color: Colors.deepPurpleAccent),
                SizedBox(width: 16),
                Text(
                  'Dados do Documento',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  BotaoSelecionarTurma(
                    turmaSelecionada: turmaSelecionada,
                    onTurmaSelecionada: (id, turmaNome) {
                      setState(() {
                        turmaId = id;
                      });
                      turmaSelecionada.value = turmaNome;
                    },
                  ),
                  const SizedBox(height: 16),
                  turmaId != null
                      ? BotaoSelecionarAluno(
                          alunoSelecionado: alunoSelecionado,
                          turmaId: turmaId!,
                          onAlunoSelecionado: (id, nomeCompleto) {
                            alunoId = id;
                          },
                        )
                      : const Text('Selecione uma turma para ver os alunos'),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _observacoesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Observações (Opcional)',
                      prefixIcon: const Icon(Icons.note),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButoesDeAcao() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _gerarDocumento,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
              foregroundColor: Colors.white,
            ),

            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.save),
                SizedBox(width: 8),
                Text('Gerar Documento'),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: _limparCampos,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.clear),
                SizedBox(width: 8),
                Text('Limpar Campos'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _gerarDocumento() async {
    if (alunoId == null || turmaId == null) {
      snackBarPersonalizado(
        context: context,
        mensagem: 'Selecione um aluno e turma',
        cor: Colors.red,
      );
      return;
    }
    try {
      final docAluno = await FirebaseFirestore.instance
          .collection('matriculas')
          .doc(alunoId)
          .get();

      if (!docAluno.exists) {
        if (mounted) {
          snackBarPersonalizado(
            context: context,
            mensagem: 'Aluno não encontrado',
            cor: Colors.red,
          );
          return;
        }
      }
      final dados = docAluno.data()!;
      final dadosAcademicos = DadosAcademicos.fromJson(
        dados['dadosAcademicos'] ?? {},
      );
      final dadosAluno = DadosAluno.fromJson(dados['dadosAluno'] ?? {});
      final dadosResponsavel = ResponsaveisAluno.fromJson(
        dados['responsaveisAluno'] ?? {},
      );
      final dadosEndereco = EnderecoAluno.fromJson(
        dados['dadosEndereco'] ?? {},
      );

      final contratoPronto = await _contratoPdfService.gerarContratoPdf(
        dadosPdfAcademicos: dadosAcademicos,
        dadosPdfAluno: dadosAluno,
        dadosPdfResponsavel: dadosResponsavel,
        dadosPdfEndereco: dadosEndereco,
      );
      await Printing.layoutPdf(onLayout: (format) => contratoPronto);
      if (mounted) {
        snackBarPersonalizado(
          context: context,
          mensagem: 'Documento Gerado com sucesso! 🎉',
        );
      }
    } catch (e, s) {
      debugPrint('erro ao gerar documento $e \n $s');
      if (mounted) {
        snackBarPersonalizado(
          context: context,
          mensagem: 'Erro ao Gerar Documento ',
          cor: Colors.red,
        );
      }
    }
  }

  void _limparCampos() {
    setState(() {
      _nomeAlunoController.clear();
      _anoEscolarController.clear();
      _dataController.clear();
      _observacoesController.clear();
      tipoDeDocumento = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Limpo com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _nomeAlunoController.dispose(); // libera o TextEditingController
    _anoEscolarController.dispose();
    _dataController.dispose(); // idem
    _observacoesController.dispose(); // idem
    super.dispose(); // chama o dispose da classe pai
  }
}
