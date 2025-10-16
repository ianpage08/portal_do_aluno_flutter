import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class CadastroProfessor extends StatefulWidget {
  const CadastroProfessor({super.key});

  @override
  State<CadastroProfessor> createState() => _CadastroProfessorState();
}

class _CadastroProfessorState extends State<CadastroProfessor> {
  @override
  Widget _buildTextForm({required String label, required String hintText}) {
    return TextFormField(
      decoration: InputDecoration(
        label: Text(label),
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: const Color.fromARGB(15, 72, 1, 204),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            width: 2,
            color: Color.fromARGB(255, 74, 1, 92),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Professor'),
        automaticallyImplyLeading: false,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.add))],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Form(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      children: [
                        _buildTextForm(
                          label: 'Nome Completo do Professor',
                          hintText: 'Ex: Marta da Silva Santos ',
                        ),
                        _buildTextForm(label: '', hintText: 'hintText')
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
