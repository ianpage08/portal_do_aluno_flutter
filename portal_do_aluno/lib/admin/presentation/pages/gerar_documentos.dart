import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class GerarDocumentosPage extends StatefulWidget {
  const GerarDocumentosPage({super.key});

  @override
  State<GerarDocumentosPage> createState() => _GerarDocumentosPageState();
}

class _GerarDocumentosPageState extends State<GerarDocumentosPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeAlunoController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  
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
      appBar: const CustomAppBar(title: 'Gerar Documentos'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(children: [_buildCardTipoDoc()]),
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
                Text('Tipo de Documento'),
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
    return Card();
  }
}
