import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:portal_do_aluno/features/admin/data/datasources/contrato_pdf_service.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/widget_value_notifier/botao_selecionar_aluno.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/widget_value_notifier/botao_selecionar_turma.dart';
import 'package:printing/printing.dart';
import 'package:portal_do_aluno/features/admin/data/models/aluno.dart';
import 'package:portal_do_aluno/shared/helpers/snack_bar_helper.dart';

class GerarDocumentosPage extends StatefulWidget {
  const GerarDocumentosPage({super.key});

  @override
  State<GerarDocumentosPage> createState() => _GerarDocumentosPageState();
}

class _GerarDocumentosPageState extends State<GerarDocumentosPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _mapController = {
    'nomeAluno': TextEditingController(),
    'anoEscolar': TextEditingController(),
    'data': TextEditingController(),
    'observacoes': TextEditingController(),
  };

  final Map<String, String?> _mapSelectedValues = {
    'turmaId': null,
    'alunoId': null,
  };

  final Map<String, ValueNotifier<String?>> _mapValueNotifier = {
    'turma': ValueNotifier<String?>(null),
    'aluno': ValueNotifier<String?>(null),
  };
  List<TextEditingController> get _allControllers =>
      _mapController.values.toList();

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
      'cor': const Color.fromARGB(255, 118, 166, 255),
    },
    {
      'nome': 'Histórico',
      'icon': Icons.edit_document,
      'descricao': 'Historico de notas e carga horaria',
      'cor': const Color.fromARGB(255, 118, 166, 255),
    },
    {
      'nome': 'Declaração',
      'icon': Icons.description,
      'descricao': 'Declaração de matrícula',
      'cor': const Color.fromARGB(255, 118, 166, 255),
    },
    {
      'nome': 'Relatorio',
      'icon': Icons.analytics,
      'descricao': 'relatorio de desempenho ',
      'cor': const Color.fromARGB(255, 118, 166, 255),
    },
    {
      'nome': 'Matricula',
      'icon': Icons.dock,
      'descricao': 'Contrato de matricula',
      'cor': const Color.fromARGB(255, 118, 166, 255),
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
              spacing: 10,
              runSpacing: 10,
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
          debugPrint(tipoDeDocumento);
        });
      },
      child: Container(
        width: 140,
        height: 140,

        padding: const EdgeInsets.all(12),
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
        padding: const EdgeInsets.all(16),
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
                    turmaSelecionada: _mapValueNotifier['turma']!,
                    onTurmaSelecionada: (id, turmaNome) {
                      setState(() {
                        _mapSelectedValues['turmaId'] = id;
                      });
                      _mapValueNotifier['turma']!.value = turmaNome;
                    },
                  ),
                  const SizedBox(height: 16),
                  _mapSelectedValues['turmaId'] != null
                      ? BotaoSelecionarAluno(
                          alunoSelecionado: _mapValueNotifier['aluno']!,
                          turmaId: _mapSelectedValues['turmaId']!,
                          onAlunoSelecionado: (id, nomeCompleto, cpf) {
                            _mapSelectedValues['alunoId'] = id;
                          },
                        )
                      : const Text('Selecione uma turma para ver os alunos'),
                  const SizedBox(height: 16),
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
            onPressed: () async {
              switch (tipoDeDocumento) {
                case 'Certificado':
                  snackBarPersonalizado(
                    context: context,
                    mensagem: 'Certificado gerado com sucesso!',
                  );
                  _limparCampos();
                  break;
                case 'Histórico':
                  snackBarPersonalizado(
                    context: context,
                    mensagem: 'Histórico gerado com sucesso!',
                  );
                  _limparCampos();
                  break;
                case 'Declaração':
                  snackBarPersonalizado(
                    context: context,
                    mensagem: 'Declaração gerado com sucesso!',
                  );
                  _limparCampos();
                  break;
                case 'Relatorio':
                  snackBarPersonalizado(
                    context: context,
                    mensagem: 'Relatorio gerado com sucesso!',
                  );
                  _limparCampos();
                  break;
                case 'Matricula':
                  if (_mapValueNotifier['turma']!.value == null ||
                      _mapValueNotifier['aluno']!.value == null) {
                    return snackBarPersonalizado(
                      context: context,
                      mensagem: 'Selecione um aluno e turma',
                      cor: Colors.red,
                    );
                  }
                  _gerarContratoMatricula();
                  _limparCampos();
                  break;
                default:
              }
            },
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
      ],
    );
  }

  Future<void> _gerarContratoMatricula() async {
    if (_mapSelectedValues['turmaId'] == null ||
        _mapSelectedValues['alunoId'] == null) {
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
          .doc(_mapSelectedValues['alunoId'])
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
      tipoDeDocumento = null;
    });
  }

  @override
  void dispose() {
    for (var controller in _allControllers) {
      controller.dispose();
    }
    _mapValueNotifier['turma']!.dispose();
    _mapValueNotifier['aluno']!.dispose();

    super.dispose(); // chama o dispose da classe pai
  }
}
