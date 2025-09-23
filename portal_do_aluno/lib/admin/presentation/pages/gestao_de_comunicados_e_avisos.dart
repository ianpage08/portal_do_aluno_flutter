import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class ComunicacaoInstitucionalPage extends StatefulWidget {
  const ComunicacaoInstitucionalPage({super.key});

  @override
  State<ComunicacaoInstitucionalPage> createState() =>
      _ComunicacaoInstitucionalPageState();
}

class _ComunicacaoInstitucionalPageState
    extends State<ComunicacaoInstitucionalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Comunicação Institucional'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [_buildFormulario()]),
      ),
    );
  }

  Widget _buildFormulario() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const ListTile(
              leading: Icon(Icons.school),
              title: Text(
                'Novo Comunicado',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
