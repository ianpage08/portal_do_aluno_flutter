import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class ClassModel extends StatefulWidget {
  const ClassModel({super.key});

  @override
  State<ClassModel> createState() => _ClassModelState();
}

class _ClassModelState extends State<ClassModel> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _notaController = TextEditingController();

  String? _selectedTurma;
  List<String> turmas = ['Turma 1', 'Turma 2', 'Turma 3'];

  List<String> materias = ['Matemática', 'Português', 'História'];
  String? _selectedMateria;

  List<String> alunos = ['João', 'Maria', 'Pedro'];
  String? _selectedAluno;

  void showMaterialModal() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      context: context,
      builder: (context) {
        return ListView(
          children: materias.map((m) {
            return ListTile(
              leading: const Icon(Icons.book_outlined),
              title: Text(m),
              onTap: () {
                setState(() {
                  _selectedMateria = m;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  void showModalClasse() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      context: context,
      builder: (context) {
        return ListView(
          children: alunos.map((aluno) {
            return ListTile(
              leading: const Icon(Icons.person_outline),
              title: Text(aluno),
              onTap: () {
                setState(() {
                  _selectedAluno = aluno;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Nota lançada com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Classe'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Card de informações
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.group,
                              size: 18,
                              color: Colors.deepPurple,
                            ),
                            const SizedBox(width: 6),
                            Text("Turma: ${_selectedTurma ?? '-'}"),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.person,
                              size: 18,
                              color: Colors.deepPurple,
                            ),
                            const SizedBox(width: 6),
                            Text("Aluno: ${_selectedAluno ?? '-'}"),
                          ],
                        ),
                      ],
                    ),
                    const VerticalDivider(
                      thickness: 1,
                      color: Colors.deepPurple,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.school,
                              size: 18,
                              color: Colors.deepPurple,
                            ),
                            SizedBox(width: 6),
                            Text("Professor: João Silva"),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.menu_book,
                              size: 18,
                              color: Colors.deepPurple,
                            ),
                            const SizedBox(width: 6),
                            Text("Disciplina: ${_selectedMateria ?? '-'}"),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Formulário
            Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Selecione a Turma',
                      border: OutlineInputBorder(),
                    ),
                    items: turmas
                        .map(
                          (turma) => DropdownMenuItem(
                            value: turma,
                            child: Text(turma),
                          ),
                        )
                        .toList(),
                    value: _selectedTurma,
                    onChanged: (value) =>
                        setState(() => _selectedTurma = value),
                    validator: (value) =>
                        value == null ? 'Selecione uma Turma' : null,
                  ),
                  const SizedBox(height: 16),

                  // Selecionar Aluno
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.person),
                      onPressed: showModalClasse,
                      label: Text(
                        _selectedAluno == null
                            ? 'Selecione o Aluno'
                            : 'Aluno: $_selectedAluno',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Selecionar Matéria
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.book),
                      onPressed: showMaterialModal,
                      label: Text(
                        _selectedMateria == null
                            ? 'Selecione a Matéria'
                            : 'Matéria: $_selectedMateria',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Nota
                  TextFormField(
                    controller: _notaController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Nota do Teste',
                      prefixIcon: Icon(Icons.edit),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Informe a nota';
                      final nota = double.tryParse(value.replaceAll(',', '.'));
                      if (nota == null) return 'Informe um número válido';
                      if (nota < 0 || nota > 10)
                        return 'A nota deve ser entre 0 e 10';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Botão Lançar
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.send),
                      onPressed: _submitForm,
                      label: const Text(' Laçar nota '),
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
}
/*import 'package:flutter/material.dart'; import 'package:portal_do_aluno/shared/widgets/app_bar.dart'; class ClassModel extends StatefulWidget { const ClassModel({super.key}); @override State<ClassModel> createState() => _ClassModelState(); } class _ClassModelState extends State<ClassModel> { final _formKey = GlobalKey<FormState>(); final TextEditingController _notaController = TextEditingController(); String? _selectedTurma; List<String> turmas = ['Turma 1', 'Turma 2', 'Turma 3']; List<String> materias = ['Matemática', 'Português', 'História']; String? _selectedMateria; List<String> alunos = ['João', 'Maria', 'Pedro']; String? _selectedAluno; void showMaterialModal() { showModalBottomSheet( context: context, builder: (context) { return ListView( children: materias.map((m) { return ListTile( title: Text(m), onTap: () { setState(() { _selectedMateria = m; }); Navigator.pop(context); }, ); }).toList(), ); }, ); } void showModalClasse() { showModalBottomSheet( context: context, builder: (context) { return ListView( children: alunos.map((aluno) { return ListTile( title: Text(aluno), onTap: () { setState(() { _selectedAluno = aluno; }); Navigator.pop(context); }, ); }).toList(), ); }, ); } void _submitForm() { if (_formKey.currentState!.validate()) { // Aqui você pode salvar os dados ou enviar para backend ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text('Nota lançada com sucesso!')), ); } } @override Widget build(BuildContext context) { return Scaffold( appBar: const CustomAppBar(title: 'Classe'), body: Padding( padding: const EdgeInsets.all(16), child: Column( children: [ Card( color: const Color.fromARGB(255, 194, 169, 238), elevation: 2, shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(12), ), child: Padding( padding: const EdgeInsets.all(8), child: Row( mainAxisAlignment: MainAxisAlignment.spaceAround, children: [ Column( crossAxisAlignment: CrossAxisAlignment.start, children: [ Text( 'Turma: ${_selectedTurma ?? '-'}', style: const TextStyle( fontSize: 16, fontWeight: FontWeight.bold, ), ), Text( 'Aluno: ${_selectedAluno ?? '-'}', style: const TextStyle( fontSize: 16, fontWeight: FontWeight.bold, ), ), ], ), Container( width: 1, height: 40, color: const Color.fromARGB(255, 12, 9, 224), ), Column( crossAxisAlignment: CrossAxisAlignment.start, children: [ const Text( 'Professor: João Silva', style: TextStyle( fontSize: 16, fontWeight: FontWeight.bold, ), ), Text( 'Disciplina: ${_selectedMateria ?? '-'}', style: const TextStyle( fontSize: 16, fontWeight: FontWeight.bold, ), ), ], ), ], ), ), ), const SizedBox(height: 16), Form( key: _formKey, child: Column( children: [ DropdownButtonFormField<String>( hint: const Text('Selecione a Turma'), items: turmas .map( (turma) => DropdownMenuItem<String>( value: turma, child: Text(turma), ), ) .toList(), initialValue: _selectedTurma, onChanged: (value) { setState(() { _selectedTurma = value; }); }, validator: (value) => value == null ? 'Selecione uma Turma' : null, ), const SizedBox(height: 16), SizedBox( width: double.infinity, height: 50, child: ElevatedButton( onPressed: showModalClasse, child: Text( _selectedAluno == null ? 'Selecione o Aluno' : 'Aluno: $_selectedAluno', style: const TextStyle(fontSize: 20), ), ), ), const SizedBox(height: 16), SizedBox( width: double.infinity, height: 50, child: ElevatedButton( onPressed: showMaterialModal, child: Text( _selectedMateria == null ? 'Selecione a Matéria' : 'Matéria: $_selectedMateria', style: const TextStyle(fontSize: 20), ), ), ), const SizedBox(height: 16), TextFormField( controller: _notaController, keyboardType: const TextInputType.numberWithOptions( decimal: true, ), decoration: const InputDecoration( labelText: 'Nota do Teste', border: OutlineInputBorder(), ), validator: (value) { if (value == null || value.isEmpty) { return 'Informe a nota'; } final nota = double.tryParse(value.replaceAll(',', '.')); if (nota == null) { return 'Informe um número válido'; } if (nota < 0 || nota > 10) { return 'A nota deve ser entre 0 e 10'; } return null; }, ), const SizedBox(height: 24), SizedBox( width: double.infinity, height: 50, child: ElevatedButton( onPressed: _submitForm, child: const Text( 'Lançar Nota', style: TextStyle(fontSize: 20), ), ), ), ], ), ), ], ), ), ); } }

















 */