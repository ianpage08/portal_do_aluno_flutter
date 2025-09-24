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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _mensagemController = TextEditingController();
  final List<Map<String, dynamic>> destinatarios = [
    {'nome': 'Todos', 'icon': Icons.people, 'cor': Colors.purple},
    {'nome': 'Alunos', 'icon': Icons.groups, 'cor': Colors.blue},
    {'nome': 'Professores', 'icon': Icons.school, 'cor': Colors.green},
    {'nome': 'Responsáveis', 'icon': Icons.person, 'cor': Colors.red},
  ];
  final List<Map<String, dynamic>> historico = [
    {
      "titulo": "Reunião de Pais - 3º Bimestre",
      "destinatario": "Pais/Responsáveis",
      "mensagem": "Reunião será realizada no dia 15/12...",
      "data": "10/12 14:30",
      'vizualizacao': 45,
    },
    {
      "titulo": "Suspensão das Aulas - Feriado",
      "destinatario": "Todos",
      "mensagem": "Aulas suspensas no dia 15/11...",
      "data": "14/11 09:15",
      'vizualizacao': 90,
    },
  ];
  bool anexoAdicionado = false;
  String? _isSelectedDestinatario;
  void _enviarMenssagem() {
    if (_formKey.currentState!.validate() && _isSelectedDestinatario != null) {
      setState(() {
        historico.insert(0, {
          'titulo': _tituloController.text,
          'destinatario': _isSelectedDestinatario,
          'mensagem': _mensagemController.text,
          'data':
              "${DateTime.now().day}/${DateTime.now().month} ${DateTime.now().hour}:${DateTime.now().minute}",
          'vizualizacao': 0,
        });
        _tituloController.clear();
        _isSelectedDestinatario = null;
        _mensagemController.clear();
        anexoAdicionado = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Comunicação Institucional'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildFormulario(),
              const SizedBox(height: 12),
              _buildEstatisticas(),
              const SizedBox(height: 12),
              _buildHistorico(),
            ],
          ),
        ),
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
              leading: Icon(Icons.campaign, color: Colors.blue),
              title: Text(
                'Novo Comunicado',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _tituloController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.title),
                      labelText: 'Título',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _isSelectedDestinatario,
                    decoration: InputDecoration(
                      label: const Text('Destinatário'),
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: destinatarios.map((tipo) {
                      return DropdownMenuItem(
                        value: tipo['nome'] as String,
                        child: Row(
                          children: [
                            Icon(tipo['icon'], color: tipo['cor']),
                            const SizedBox(width: 16),

                            Text(tipo['nome']),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _isSelectedDestinatario = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Selecione Uma Opção Por favor';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _mensagemController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.message),
                      labelText: 'Mensagem',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Icon(Icons.attach_file),
                  const SizedBox(width: 12),
                  Text(
                    anexoAdicionado ? 'Anexo adicionado' : 'Nenhum Anexo ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: anexoAdicionado
                          ? const Color.fromARGB(255, 0, 73, 3)
                          : const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        anexoAdicionado = !anexoAdicionado;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Anexo Adicionado'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      });
                    },
                    child: const Text(
                      'Anexar',
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 60,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _enviarMenssagem,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.send, color: Colors.white, size: 20),
                    SizedBox(width: 12),
                    Text(
                      'Enviar Comunicado',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstatisticas() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _itemEstatisticas(
          Icons.send,
          'Enviados',
          historico.length.toString(),
          Colors.blue,
          Colors.blue.shade50,
          Colors.blue.shade900,
        ),
        const SizedBox(width: 16),
        _itemEstatisticas(
          Icons.visibility,
          'Vizualizações',
          '135',
          Colors.green,
          Colors.green.shade50,
          Colors.green.shade900,
        ),
      ],
    );
  }

  Widget _itemEstatisticas(
    IconData icon,
    String texto,
    String qtd,
    Color corIco,
    Color corCard,
    Color qtdText,
  ) {
    return Expanded(
      child: Card(
        color: corCard,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: corIco, size: 40),
              Text(
                qtd,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: qtdText,
                ),
              ),
              Text(
                texto,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistorico() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.history, color: Colors.deepPurple),
            SizedBox(width: 12),
            Text(
              'Histórico de Comunicados',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: historico.length,
          itemBuilder: (context, index) {
            final item = historico[index];
            final destinatario = destinatarios.firstWhere(
              (i) => i['nome'] == item['destinatario'],
              orElse: () => {'icon': Icons.person, 'cor': Colors.grey},
            );

            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Icon(destinatario['icon'], color: destinatario['cor']),
                ),
                title: Text(item['titulo']),
                subtitle: Text(item['mensagem']),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(item['data'], style: const TextStyle(fontSize: 12)),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.visibility,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(item['vizualizacao'].toString()),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
