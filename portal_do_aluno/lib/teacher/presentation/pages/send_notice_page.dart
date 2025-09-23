import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class EnviarComunicado extends StatefulWidget {
  const EnviarComunicado({super.key});

  @override
  State<EnviarComunicado> createState() => _EnviarComunicadoState();
}

class _EnviarComunicadoState extends State<EnviarComunicado> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _conteudoController = TextEditingController();
  List<String> comunicado = [];

  void _enviarComunicado() {
    if (_formKey.currentState!.validate()) {
      final texto = _conteudoController.text.trim();
      if (texto.isNotEmpty) {
        setState(() {
          comunicado.add(texto);
          _conteudoController.clear();
        });
      }
    }
  }

  void showModalLimpar() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Limpar Texto'),
          content: const Text('Realmente deseja limpar o texto?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _limparComunicado();
                Navigator.pop(context);
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void _limparComunicado() {
    setState(() {
      _conteudoController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Comunicado'),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Comunicado',
                  hintText: 'Digite o comunicado',
                ),
                controller: _conteudoController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe um comunicado válido';
                  }
                  return null;
                },
                maxLines: 3,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 199, 139, 255),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _enviarComunicado,
                    child: const Text('Enviar', style: TextStyle(fontSize: 20)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 253, 179, 179),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: showModalLimpar,
                    child: const Text('Limpar', style: TextStyle(fontSize: 20)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: comunicado.isEmpty
                  ? const Center(child: Text('Nenhum comunicado encontrado'))
                  : ListView.builder(
                      itemCount: comunicado.length,
                      itemBuilder: (context, index) {
                        final conteudoComunicado = comunicado[index];
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.all(8),
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Professor: portal',
                                  style: TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(conteudoComunicado),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
