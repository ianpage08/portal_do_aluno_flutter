import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

enum PresencaStatus { presente, falta, justificativa }

class Aluno {
  final String nome;
  PresencaStatus status;

  Aluno({required this.nome, this.status = PresencaStatus.falta});
}

class AttedancePage extends StatefulWidget {
  const AttedancePage({super.key});

  @override
  State<AttedancePage> createState() => _AttedancePageState();
}

class _AttedancePageState extends State<AttedancePage> {
  final List<Aluno> alunos = List.generate(
    10,
    (index) => Aluno(nome: 'Aluno $index'),
  );

  // Função para retornar a cor de acordo com o status
  Color _corStatus(PresencaStatus status) {
    switch (status) {
      case PresencaStatus.presente:
        return Colors.green;
      case PresencaStatus.falta:
        return Colors.red;
      case PresencaStatus.justificativa:
        return Colors.orange;
    }
  }

  void marcarStatus(Aluno aluno, PresencaStatus status) {
    setState(() {
      aluno.status = status;
    });
  }

  // Função para retornar o texto do status
  String _labelStatus(PresencaStatus status) {
    switch (status) {
      case PresencaStatus.presente:
        return 'Presente';
      case PresencaStatus.falta:
        return 'Falta';
      case PresencaStatus.justificativa:
        return 'Justificativa';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Página de Presença'),
      body: ListView.separated(
        itemCount: alunos.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final aluno = alunos[index];
          return ListTile(
            title: Text(aluno.nome),
            subtitle: Row(
              children: PresencaStatus.values.map((status) {
                final isSelected =
                    aluno.status ==
                    status; // Corrigido: comparação (==) e não atribuição (=)
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected
                            ? _corStatus(status)
                            : Colors.grey,
                        foregroundColor: isSelected
                            ? Colors.white
                            : Colors.black,
                      ),
                      onPressed: () => marcarStatus(aluno, status),
                      child: Text(
                        _labelStatus(status),
                        style: const TextStyle(fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Presença marcada com sucesso!',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            );
          },
          child: const Text('Salvar Presença', style: TextStyle(fontSize: 20)),
        ),
      ),
    );
  }
}
