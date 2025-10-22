import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/auth/data/datasouces/buscar_aluno_por_id_test.dart'; // ✅ Mantém se precisar de outras funções
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class BoletimPage extends StatefulWidget {
  const BoletimPage({super.key});

  @override
  State<BoletimPage> createState() => _BoletimPageState();
}

class _BoletimPageState extends State<BoletimPage> {
  String? alunoId;

  @override
  void initState() {
    super.initState();
    _carregarAlunoId();
  }

  Future<void> _carregarAlunoId() async {
    final id =
        await getAlunoIdFromFirestore(); // ✅ Agora usa a função corrigida
    if (id != null) {
      setState(() => alunoId = id);
    } else {
      // ✅ Opcional: Mostrar mensagem se não encontrar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro: Aluno ID não encontrado. Faça login novamente.'),
        ),
      );
    }
  }

  // ✅ Stream corrigido: Busca o boletim diretamente pelo alunoId (único documento)
  Stream<DocumentSnapshot<Map<String, dynamic>>> getBoletim(String alunoId) {
    return FirebaseFirestore.instance
        .collection('boletim')
        .doc(alunoId) // ✅ Usa o alunoId como ID do documento
        .snapshots();
  }

  Widget _buildStreamNotasView() {
    if (alunoId == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Carregando boletim...'),
          ],
        ),
      );
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: getBoletim(alunoId!), // ✅ Stream direto pelo ID
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Erro ao carregar boletim: ${snapshot.error}'),
          );
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(
            child: Text('Nenhum boletim encontrado para este aluno'),
          );
        }

        final data = snapshot.data!.data()!;
        final disciplinas = data['disciplinas'] as List<dynamic>? ?? [];

        if (disciplinas.isEmpty) {
          return const Center(
            child: Text('Nenhuma disciplina encontrada no boletim'),
          );
        }

        return Column(
          children: [
            ExpansionPanelList.radio(
              children: disciplinas.map((disc) {
                final nomeDisc =
                    disc['nomeDisciplina'] ?? 'Disciplina sem nome';
                final notas = disc['notas'] as Map<String, dynamic>? ?? {};

                return ExpansionPanelRadio(
                  value: disc['id'] ?? disc['disciplinaId'],
                  headerBuilder: (context, isExpanded) {
                    return ListTile(title: Text(nomeDisc.toUpperCase()));
                  },
                  body: Column(
                    children: notas.entries.map((entry) {
                      final unidade = entry.key;
                      final valores =
                          entry.value as Map<String, dynamic>? ?? {};

                      return ListTile(
                        title: Text('Unidade $unidade'),
                        subtitle: Text(
                          'Teste: ${valores['teste'] ?? '-'} | '
                          'Prova: ${valores['prova'] ?? '-'} | '
                          'Trabalho: ${valores['trabalho'] ?? '-'} | '
                          'Extra: ${valores['extra'] ?? '-'}',
                        ),
                      );
                    }).toList(),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Boletim Escolar',
        backGround: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildStreamNotasView(),

              const SizedBox(height: 20),

              // ✅ Stream para média e status (usando o mesmo stream)
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: alunoId != null ? getBoletim(alunoId!) : null,
                builder: (context, snapshot) {
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const SizedBox();
                  }

                  final data = snapshot.data!.data()!;
                  final mediaGeral = data['mediageral'] ?? 0.0;
                  final status = data['situacao'] ?? 'Indefinido';

                  return SizedBox(
                    width: double.infinity,
                    height: 75,
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Média Geral: ${mediaGeral.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Status: $status',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: status == 'Aprovado'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
