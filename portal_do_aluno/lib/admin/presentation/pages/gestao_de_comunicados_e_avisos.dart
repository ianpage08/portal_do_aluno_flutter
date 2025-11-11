import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portal_do_aluno/admin/data/firestore_services/comunicado_service.dart';
import 'package:portal_do_aluno/admin/data/models/comunicado.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/menu_pontinho.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/scaffold_messeger.dart';
import 'package:portal_do_aluno/admin/presentation/widgets/text_form_field.dart';
import 'package:portal_do_aluno/core/notifications/enviar_notication.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class ComunicacaoInstitucionalPage extends StatefulWidget {
  const ComunicacaoInstitucionalPage({super.key});

  @override
  State<ComunicacaoInstitucionalPage> createState() =>
      _ComunicacaoInstitucionalPageState();
}

class _ComunicacaoInstitucionalPageState
    extends State<ComunicacaoInstitucionalPage> {
  final ComunicadoService _comunicadoService = ComunicadoService();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _mensagemController = TextEditingController();

  destinatarioSelected() {
    switch (_isSelectedDestinatario) {
      case 'Todos':
        return Destinatario.todos;
      case 'Alunos':
        return Destinatario.alunos;
      case 'Professores':
        return Destinatario.professores;
      case 'Responsáveis':
        return Destinatario.responsaveis;
      default:
        return Destinatario.todos;
    }
  }

  final List<Map<String, dynamic>> historico = [
    {
      "titulo": "Reunião de Pais - 3º Bimestre",
      "destinatario": "Pais/Responsáveis",
      "mensagem": "Reunião será realizada no dia 15/12...",
      "data": "10/12 14:30",
      'vizualizacao': 45,
    },
    {
      "titulo": "Suspensão das Aulas - Feriado",
      "destinatario": "Todos",
      "mensagem": "Aulas suspensas no dia 15/11...",
      "data": "14/11 09:15",
      'vizualizacao': 90,
    },
  ];
  bool anexoAdicionado = false;
  String? _isSelectedDestinatario;
  Future<void> _enviarMenssagem() async {
    if (_formKey.currentState!.validate() && _isSelectedDestinatario != null) {
      final novoComunicado = Comunicado(
        id: '',
        titulo: _tituloController.text,
        mensagem: _mensagemController.text,
        dataPublicacao: DateTime.now(),
        destinatario: Destinatario.values.byName(
          _isSelectedDestinatario!.toLowerCase(),
        ),
      );

      try {
        await _comunicadoService.enviarComunidado(novoComunicado);
        final tokens = await _comunicadoService.getTokensDestinatario(
          _isSelectedDestinatario!,
        );

        for (final token in tokens) {
          await enviarNotification(
            token,
            novoComunicado.titulo,
            novoComunicado.mensagem,
          );
        }
        if (!context.mounted) return;
        if (mounted) {
          snackBarPersonalizado(
            context: context,
            mensagem: 'Comunicado enviado com sucesso! 🎉',
            cor: Colors.green,
          );
        }

        setState(() {
          _tituloController.clear();
          _mensagemController.clear();
          _isSelectedDestinatario = null;
          anexoAdicionado = false;
        });
      } catch (e, s) {
        if (mounted) {
          debugPrint('Erro ao enviar: $e');
          debugPrintStack(stackTrace: s);
          snackBarPersonalizado(
            context: context,
            mensagem: 'Erro ao enviar Comunicado',
            cor: Colors.red,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Comunicação Institucional'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildFormulario(),
              const SizedBox(height: 12),
              _buildEstatisticas(),
              const SizedBox(height: 12),
              _buildHistorico(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormulario() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const ListTile(
              leading: Icon(Icons.campaign, color: Colors.blue),
              title: Text(
                'Novo Comunicado',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormFieldPersonalizado(
                    controller: _tituloController,

                    prefixIcon: const Icon(Icons.title),
                    label: 'Título',
                    hintText: 'Reunião de Pais - 3º Bimestre',
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 60,

                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: Theme.of(context).elevatedButtonTheme.style,
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return ListView(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.people),
                                  title: const Text('Todos'),
                                  onTap: () {
                                    setState(() {
                                      _isSelectedDestinatario = 'Todos';
                                      Navigator.pop(context);
                                    });
                                  },
                                ),
                                const Divider(),
                                ListTile(
                                  leading: const Icon(Icons.groups),
                                  title: const Text('Alunos'),
                                  onTap: () {
                                    setState(() {
                                      _isSelectedDestinatario = 'Alunos';
                                      Navigator.pop(context);
                                    });
                                  },
                                ),
                                const Divider(),
                                ListTile(
                                  leading: const Icon(Icons.school),
                                  title: const Text('Professores'),
                                  onTap: () {
                                    setState(() {
                                      _isSelectedDestinatario = 'Professores';
                                      Navigator.pop(context);
                                    });
                                  },
                                ),
                                const Divider(),
                                ListTile(
                                  leading: const Icon(Icons.person),
                                  title: const Text('Responsáveis'),
                                  onTap: () {
                                    setState(() {
                                      _isSelectedDestinatario = 'Responsáveis';
                                      Navigator.pop(context);
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      label: Text(
                        _isSelectedDestinatario ?? 'Selecione o Destinatário',
                        style: const TextStyle(fontSize: 18),
                      ),
                      icon: const Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormFieldPersonalizado(
                    controller: _mensagemController,
                    maxLines: 4,
                    prefixIcon: const Icon(Icons.message),
                    label: 'Mensagem',
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Icon(Icons.attach_file),
                  const SizedBox(width: 12),
                  Text(
                    anexoAdicionado ? 'Anexo adicionado' : 'Nenhum Anexo ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: anexoAdicionado
                          ? const Color.fromARGB(255, 0, 73, 3)
                          : const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        anexoAdicionado = !anexoAdicionado;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Anexo Adicionado'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      });
                    },
                    child: const Text(
                      'Anexar',
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 60,

              child: ElevatedButton(
                style: Theme.of(context).elevatedButtonTheme.style,
                onPressed: _enviarMenssagem,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.send, color: Colors.white, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      'Enviar Comunicado',
                      style: Theme.of(context).textTheme.titleMedium,
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

  Widget _buildEstatisticas() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const SizedBox(width: 16),
        StreamBuilder<int>(
          stream: _comunicadoService
              .calcularQuantidadeDeCominicados()
              .asStream(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Erro ao carregar os dados'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final total = snapshot.data ?? 0;
            return _itemEstatisticas(
              Icons.send,
              'Enviados',
              total.toString(),
              Colors.blue,
              Colors.blue.shade50,
              Colors.blue.shade900,
            );
          },
        ),
        StreamBuilder<int>(
          stream: _comunicadoService.contadorDeVisualizacoesVistas(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              return const Text('Nenhum aruivo encontrado');
            }
            final total = snapshot.data ?? 0;

            return _itemEstatisticas(
              Icons.visibility,
              'Vizualizações',
              total.toString(),
              Colors.green,
              Colors.green.shade50,
              Colors.green.shade900,
            );
          },
        ),
      ],
    );
  }

  Widget _itemEstatisticas(
    IconData icon,
    String texto,
    String qtd,
    Color corIco,
    Color corCard,
    Color qtdText,
  ) {
    return Expanded(
      child: Card(
        color: corCard,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: corIco, size: 40),
              Text(
                qtd,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: qtdText,
                ),
              ),
              Text(
                texto,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistorico() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.history, color: Colors.deepPurple),
            SizedBox(width: 12),
            Text(
              'Histórico de Comunicados',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 12),
        StreamBuilder<QuerySnapshot>(
          stream: _comunicadoService.getComunicados(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Erro ao carregar os dados'));
            }
            final historicoData = snapshot.data!.docs;

            return ListView.builder(
              shrinkWrap: true,
              itemCount: historicoData.length,
              itemBuilder: (context, index) {
                final item = historicoData[index];
                final dataPublicacao = (item['dataPublicacao'] as Timestamp)
                    .toDate();
                final dataFormatada = DateFormat(
                  'dd/MM/yyyy HH:mm',
                ).format(dataPublicacao);

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: const Icon(Icons.person),
                    ),
                    title: Text(item['titulo']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['mensagem']),
                        const SizedBox(height: 8),
                        Text(
                          dataFormatada,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: MenuPontinhoGenerico(
                      id: item['id'],
                      items: [
                        MenuItemConfig(
                          value: 'Excluir',
                          label: 'Excluir',
                          onSelected: (id, context, extra) {
                            _comunicadoService.excluirComunicado(id!);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
