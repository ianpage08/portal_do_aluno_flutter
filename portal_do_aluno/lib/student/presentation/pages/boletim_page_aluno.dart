import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/admin/data/models/disciplinas/nota_disciplina.dart';
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

        // ignore: avoid_unnecessary_containers
        return Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [Color(0xFFFFFFFF), Color.fromARGB(255, 240, 240, 240)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(44, 0, 0, 0),
                offset: Offset(0, 5),
                blurRadius: 5,
              ),
            ],
            border: Border.all(
              color: Colors.grey.withOpacity(0.15),
              width: 1.2,
            ),
          ),

          child: Column(
            children: disciplinas.map((materia) {
              final notas = materia['notas'] as Map<String, dynamic>? ?? {};
              return Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: Builder(
                  builder: (context) {
                    final disciplina = NotaDisciplina.fromJson(materia);

                    final mediaFinal = disciplina.calcularMediaFinal() ?? 0.0;
                    final mediasPorUnidade = disciplina
                        .calcularMediaPorUnidade();

                    return ExpansionTile(
                      leading: const Icon(CupertinoIcons.book),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            disciplina.nomeDisciplina,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            'Média Final: ${mediaFinal.toStringAsFixed(1)}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      children: disciplina.notas.entries.map((entry) {
                        final unidade = entry.key;
                        final valores = entry.value;

                        final mediaUnidade = mediasPorUnidade[unidade] ?? 0.0;

                        return ListTile(
                          title: Text('Unidade $unidade'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Média desta unidade: ${mediaUnidade.toStringAsFixed(1)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  item(
                                    'Teste: ${valores['teste'] ?? '---'}',
                                    CupertinoIcons.checkmark_alt_circle,
                                  ),
                                  item(
                                    'Trabalho: ${valores['trabalho'] ?? '---'}',
                                    CupertinoIcons.briefcase,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  item(
                                    'Prova: ${valores['prova'] ?? '---'}',
                                    CupertinoIcons.doc_text_search,
                                  ),
                                  item(
                                    'Extra: ${valores['extra'] ?? '---'}',
                                    CupertinoIcons.star_circle,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  //  Widget para criar boletim automaticamente se não existir
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

  //   Função para criar boletim vazio
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
              Text(
                'Boletim do Aluno',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              _buildStreamNotasView(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget item(String titulo, IconData icone) {
    return Row(
      children: [Icon(icone, size: 16), const SizedBox(width: 8), Text(titulo)],
    );
  }
}
