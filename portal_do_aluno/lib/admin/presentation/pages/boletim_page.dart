import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class BoletimTestePage extends StatefulWidget {
  const BoletimTestePage({super.key});

  @override
  State<BoletimTestePage> createState() => _BoletimTestePageState();
}

class _BoletimTestePageState extends State<BoletimTestePage> {
  final List<String> turma = ['turma 1', 'turma 2', 'turma 3'];
  final List<String> unidades = [
    'unidade 1',
    'unidade 2',
    'unidade 3',
    'unidade 4',
  ];
  final List<String> disciplinas = [
    'disciplina 1',
    'disciplina 2',
    'disciplina 3',
  ];
  final List<String> tiposDeAvaliacao = [
    'Teste',
    'Prova',
    'Trabalho',
    'Nota Extra',
  ];

  String? turmaSelecionada;
  String? alunoSelecionado;
  String? disciplinaSelecionada;
  String? unidadeSelecionada;
  String? tipoDeNota;

  // Retorna alunos conforme a turma
  List<String> _selecionarTurma() {
    switch (turmaSelecionada) {
      case 'turma 1':
        return ['aluno 1', 'aluno 2', 'aluno 3'];
      case 'turma 2':
        return ['aluno 4', 'aluno 5', 'aluno 6'];
      case 'turma 3':
        return ['aluno 7', 'aluno 8', 'aluno 9'];
      default:
        return [];
    }
  }

  // Mostra campo de nota de acordo com o tipo de avaliação
  Widget _selecionarTipoNota() {
    switch (tipoDeNota) {
      case 'Teste':
        return nota('Nota Teste', '3.5');
      case 'Prova':
        return nota('Nota Prova', '8.8');
      case 'Trabalho':
        return nota('Nota Trabalho', '9.0');
      case 'Nota Extra':
        return nota('Nota Extra', '10.0');
      default:
        return const Text('Selecione um tipo de avaliação');
    }
  }

  // Exibe modal de seleção (usado em todos os botões)
  void _showModalBottom({
    required List<String> items,
    required Function(String) onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          children: items.map((i) {
            return ListTile(
              title: Text(i),
              onTap: () {
                setState(() {
                  onSelected(i);
                  Navigator.pop(context);
                });
              },
            );
          }).toList(),
        );
      },
    );
  }

  // Campo de nota
  Widget nota(String label, String hintText) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(Icons.note_add),
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // Botão que abre modal
  Widget _buidBottomModal({
    required List<String> listas,
    required String? isSelected,
    required String title,
    required Icon icon,
    required Function(String) onSelected,
  }) {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        style: TextButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () => _showModalBottom(onSelected: onSelected, items: listas),
        icon: icon,
        label: Text(isSelected ?? title, style: const TextStyle(fontSize: 18)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Boletim Teste Page'),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      // Selecionar Turma
                      _buidBottomModal(
                        icon: const Icon(Icons.school),
                        isSelected: turmaSelecionada,
                        title: 'Selecione Uma Turma',
                        listas: turma,
                        onSelected: (value) {
                          setState(() {
                            turmaSelecionada = value;
                            alunoSelecionado = null;
                            disciplinaSelecionada = null;
                            unidadeSelecionada = null;
                            tipoDeNota = null;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Selecionar Aluno
                      if (turmaSelecionada != null)
                        _buidBottomModal(
                          listas: _selecionarTurma(),
                          isSelected: alunoSelecionado,
                          title: 'Selecione um Aluno',
                          icon: const Icon(Icons.person),
                          onSelected: (value) {
                            setState(() {
                              alunoSelecionado = value;
                            });
                          },
                        )
                      else
                        const Text('Selecione uma turma primeiro'),
                      const SizedBox(height: 16),

                      // Selecionar Disciplina
                      if (alunoSelecionado != null)
                        _buidBottomModal(
                          listas: disciplinas,
                          isSelected: disciplinaSelecionada,
                          title: 'Selecione uma Disciplina',
                          icon: const Icon(Icons.book),
                          onSelected: (value) {
                            setState(() {
                              disciplinaSelecionada = value;
                            });
                          },
                        )
                      else
                        const Text('Selecione um aluno primeiro'),
                      const SizedBox(height: 16),

                      // Selecionar Unidade
                      if (disciplinaSelecionada != null)
                        _buidBottomModal(
                          listas: unidades,
                          isSelected: unidadeSelecionada,
                          title: 'Selecione uma Unidade',
                          icon: const Icon(Icons.note_alt),
                          onSelected: (value) {
                            setState(() {
                              unidadeSelecionada = value;
                            });
                          },
                        )
                      else
                        const Text('Selecione uma disciplina primeiro'),
                      const SizedBox(height: 16),

                      // Selecionar Tipo de Avaliação
                      if (unidadeSelecionada != null)
                        _buidBottomModal(
                          listas: tiposDeAvaliacao,
                          isSelected: tipoDeNota,
                          title: 'Selecione um Tipo de Avaliação',
                          icon: const Icon(Icons.assignment),
                          onSelected: (value) {
                            setState(() {
                              tipoDeNota = value;
                            });
                          },
                        )
                      else
                        const Text('Selecione uma unidade primeiro'),
                      const SizedBox(height: 16),

                      // Campo de Nota
                      if (tipoDeNota != null)
                        _selecionarTipoNota()
                      else
                        const Text('Selecione um tipo de avaliação para inserir a nota'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Botões de Ação
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Salvo com sucesso!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('Salvar'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          turmaSelecionada = null;
                          alunoSelecionado = null;
                          disciplinaSelecionada = null;
                          unidadeSelecionada = null;
                          tipoDeNota = null;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Limpo com sucesso!'),
                            backgroundColor: Color.fromARGB(255, 175, 76, 76),
                          ),
                        );
                      },
                      icon: const Icon(Icons.clear),
                      label: const Text('Limpar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
