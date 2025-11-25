import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/admin/data/firestore_services/frequencia_service.dart';
import 'package:portal_do_aluno/admin/data/models/frequencia.dart';
import 'package:portal_do_aluno/admin/presentation/providers/selected_provider.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/botao_salvar.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/data_picker_calendario.dart';
import 'package:portal_do_aluno/admin/helper/snack_bar_personalizado.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/widget_value_notifier/botao_selecionar_turma.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';
import 'package:portal_do_aluno/teacher/presentation/providers/presenca_provider.dart';
import 'package:provider/provider.dart';

class FrequenciaAdmin extends StatefulWidget {
  const FrequenciaAdmin({super.key});

  @override
  State<FrequenciaAdmin> createState() => _FrequenciaAdminState();
}

class _FrequenciaAdminState extends State<FrequenciaAdmin> {
  final FrequenciaService _frequenciaService = FrequenciaService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final ValueNotifier<String?> turmaSelecionada = ValueNotifier<String?>(null);
  String? turmaId;
  DateTime? dataSelecionada;

  bool _isSaving = false;

  Stream<QuerySnapshot<Map<String, dynamic>>> getAlunosPorTurma(
    String turmaId,
  ) {
    return _firestore
        .collection('matriculas')
        .where('dadosAcademicos.classId', isEqualTo: turmaId)
        .snapshots();
  }

  Widget alunoCard({
    required String id,
    required String nome,
    required Presenca? status,
    required Function(Presenca) onSelect,
  }) {
    Color corStatus = Colors.grey.shade300;

    if (status == Presenca.presente) corStatus = const Color(0xFF2ECC71);
    if (status == Presenca.falta) corStatus = const Color(0xFFE53935);
    if (status == Presenca.justificativa) corStatus = const Color(0xFF3498DB);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(40, 0, 0, 0),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Barra lateral com cor do status
          Container(
            width: 10,
            height: 95,
            decoration: BoxDecoration(
              color: corStatus,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nome,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      statusChip(
                        text: "Presente",
                        selected: status == Presenca.presente,
                        color: const Color(0xFF2ECC71),
                        onTap: () => onSelect(Presenca.presente),
                        icon: Icons.check_circle,
                      ),
                      statusChip(
                        text: "Falta",
                        selected: status == Presenca.falta,
                        color: const Color(0xFFE53935),
                        onTap: () => onSelect(Presenca.falta),
                        icon: Icons.close,
                      ),
                      statusChip(
                        text: "Justificar",
                        selected: status == Presenca.justificativa,
                        color: const Color(0xFF3498DB),
                        onTap: () => onSelect(Presenca.justificativa),
                        icon: Icons.note_alt_outlined,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget statusChip({
    required String text,
    required bool selected,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? color.withAlpha((0.2 * 255).toInt())
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? color : Colors.grey.shade400,
            width: 1.3,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: selected ? color : Colors.black54),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: selected ? color : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget listAluno() {
    final providerRead = context.read<PresencaProvider>();

    if (turmaId == null) return const SizedBox();

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: getAlunosPorTurma(turmaId!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data?.docs ?? [];

        return Consumer<PresencaProvider>(
          builder: (context, provider, _) {
            return ListView.builder(
              itemCount: docs.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final aluno = docs[index];
                final nome = aluno['dadosAluno']['nome'];
                final alunoId = aluno.id;
                final status = provider.presencas[alunoId];

                return alunoCard(
                  id: alunoId,
                  nome: nome,
                  status: status,
                  onSelect: (presenca) {
                    providerRead.marcarPresenca(alunoId, presenca);
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Future<void> salvarFrequencia() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    final frequenciaProvider = context.read<PresencaProvider>();
    final presencas = frequenciaProvider.presencas;
    final dataFormatada = DateTime.utc(
      dataSelecionada!.year,
      dataSelecionada!.month,
      dataSelecionada!.day,
    );

    if (dataSelecionada == null || turmaId == null) {
      snackBarPersonalizado(
        context: context,
        mensagem: 'Selecione turma e data.',
        cor: Colors.orange,
      );
      setState(() => _isSaving = false);
      return;
    }

    try {
      for (var pre in presencas.entries) {
        final frequencia = Frequencia(
          id: '',
          alunoId: pre.key,
          classId: turmaId!,
          data: dataFormatada,
          presenca: pre.value,
        );

        await _frequenciaService.salvarFrequenciaPorTurma(
          alunoId: pre.key,
          turmaId: turmaId!,
          frequencia: frequencia,
        );
      }
      if (mounted) {
        snackBarPersonalizado(
          context: context,
          mensagem: 'Presenças salvas!',
          cor: Colors.green,
        );
      }

      frequenciaProvider.limpar();
      if (mounted) {
        context.read<SelectedProvider>().limparDrop('turma');
      }
    } catch (e) {
      if (mounted) {
        snackBarPersonalizado(
          context: context,
          mensagem: 'Erro ao salvar.',
          cor: Colors.red,
        );
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Registro de Presença'),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
        child: BotaoSalvar(salvarconteudo: salvarFrequencia),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Turma', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 5),
            BotaoSelecionarTurma(
              turmaSelecionada: turmaSelecionada,
              onTurmaSelecionada: (id, nome) {
                setState(() => turmaId = id);
                turmaSelecionada.value = nome;
              },
            ),
            const SizedBox(height: 18),
            Text('Data', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 5),
            DataPickerCalendario(
              onDate: (data) => setState(() => dataSelecionada = data),
            ),
            const SizedBox(height: 20),
            turmaSelecionada.value != null
                ? listAluno()
                : const Text('Selecione uma turma acima'),
          ],
        ),
      ),
    );
  }
}
