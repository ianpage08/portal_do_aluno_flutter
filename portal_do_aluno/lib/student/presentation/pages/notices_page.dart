import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class NoticesPage extends StatefulWidget {
  const NoticesPage({super.key});

  @override
  State<NoticesPage> createState() => _NoticesPageState();
}

class _NoticesPageState extends State<NoticesPage> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _noticias = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _addNoticia() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _noticias.add(_controller.text.trim());
        _controller.clear();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Notícias'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Lista de notícias
            Expanded(
              child: _noticias.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhuma mensagem ainda!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      itemCount: _noticias.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shadowColor: Colors.deepPurpleAccent[200],
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 20,
                            ),
                            leading: CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.deepPurpleAccent[200],
                              child: const Icon(
                                Icons.person,
                                color: Colors.deepPurple,
                              ),
                            ),
                            title: const Text(
                              'Professor tal',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Text(
                                _noticias[index],
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 16),
            // Formulário de envio
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _controller,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Digite uma mensagem válida';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Digite sua mensagem',
                          filled: true,
                          fillColor: Colors.deepPurple[50],
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(18),
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.deepPurpleAccent[100],
                        elevation: 4,
                      ),
                      onPressed: _addNoticia,
                      child: const Icon(Icons.add, size: 24),
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
}
