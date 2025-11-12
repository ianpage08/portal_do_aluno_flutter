import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/admin/presentation/providers/user_provider.dart';

import 'package:portal_do_aluno/shared/widgets/app_bar.dart';
import 'package:provider/provider.dart';

class BoletimPage extends StatefulWidget {
  const BoletimPage({super.key});

  @override
  State<BoletimPage> createState() => _BoletimPageState();
}

class _BoletimPageState extends State<BoletimPage> {
  String? alunoId;
  String? turmaId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userId = Provider.of<UserProvider>(context, listen: false).userId;
      if (userId == null) {
        return;
      }
      final alunoRef = await _getAlunoIdFromUsuario(userId);
      if (mounted && alunoRef != null) {
        setState(() {
          alunoId = alunoRef;
        });
      } else {
        debugPrint('❌ Error: Aluno não encontrado');
      }
    });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getBoletim(String alunoId) {
    return FirebaseFirestore.instance
        .collection('boletim')
        .doc(alunoId)
        .snapshots();
  }

  Future<String?> _getAlunoIdFromUsuario(String usuarioId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(usuarioId)
        .get();

    if (snapshot.exists) {
      //  AQUI: pega o campo 'alunoId' salvo no Firestore
      return snapshot.data()?['alunoId'];
    }
    return null;
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
      stream: getBoletim(alunoId!),
      builder: (context, snapshot) {
        if (snapshot.hasError) debugPrint('❌ Error: ${snapshot.error}');
        if (snapshot.hasData && snapshot.data!.exists) {
          debugPrint('📄 Data: ${snapshot.data!.data()}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Erro ao carregar boletim: ${snapshot.error}'),
          );
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return _buildCriarBoletimAutomaticamente();
        }

        final data = snapshot.data!.data()! as Map<String, dynamic>?;
        if (data == null || !data.containsKey('disciplinas')) {
          return _buildCriarBoletimAutomaticamente();
        }
        final disciplinas = List<Map<String, dynamic>>.from(
          data['disciplinas'],
        );

        if (disciplinas.isEmpty) {
          return const Center(
            child: Text('Nenhuma disciplina encontrada no boletim'),
          );
        }

        return ExpansionPanelList.radio(
          children: disciplinas.map((disc) {
            final nomeDisc = disc['nomeDisciplina'] ?? 'Disciplina sem nome';
            final notas = disc['notas'] as Map<String, dynamic>? ?? {};

            return ExpansionPanelRadio(
              value: disc['id'] ?? disc['disciplinaId'],
              headerBuilder: (context, isExpanded) {
                return ListTile(title: Text(nomeDisc.toUpperCase()));
              },
              body: Column(
                children: notas.entries.map((entry) {
                  final unidade = entry.key;
                  final valores = entry.value as Map<String, dynamic>? ?? {};

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
        );
      },
    );
  }

  // ✅ Widget para criar boletim automaticamente se não existir
  Widget _buildCriarBoletimAutomaticamente() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Nenhum boletim encontrado. Criar automaticamente?'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              await _criarBoletimVazio();
              setState(() {}); // Recarrega a tela
            },
            child: const Text('Criar Boletim'),
          ),
        ],
      ),
    );
  }

  // ✅ Função para criar boletim vazio
  Future<void> _criarBoletimVazio() async {
    if (alunoId == null) return;

    await FirebaseFirestore.instance.collection('boletim').doc(alunoId).set({
      'alunoId': alunoId,
      'disciplinas': [], // Começa vazio
      'mediaGeral': 0.0,
      'situacao': 'Em andamento',
      'dataCriacao': FieldValue.serverTimestamp(),
    });

    debugPrint('✅ Boletim vazio criado para alunoId: $alunoId');
  }

  Widget _buildMediaEStatus() {
    if (alunoId == null) return const SizedBox();

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: getBoletim(alunoId!),
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
                    color: status == 'Aprovado' ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (alunoId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
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
              _buildMediaEStatus(),
            ],
          ),
        ),
      ),
    );
  }
}
