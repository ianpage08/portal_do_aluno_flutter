import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/admin/data/datasources/contrato_pdf_service.dart';
import 'package:portal_do_aluno/admin/data/models/aluno.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';
import 'package:printing/printing.dart';

class DetalhesAluno extends StatefulWidget {
  final String alunoId;

  const DetalhesAluno({super.key, required this.alunoId});

  @override
  State<DetalhesAluno> createState() => _DetalhesAlunoState();
}

class _DetalhesAlunoState extends State<DetalhesAluno> {
  final minhaStream = FirebaseFirestore.instance.collection('matriculas');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Detalhes do Aluno'),
      body: _buildStream(),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: valueColor ?? Colors.black87,
                fontWeight: valueColor != null
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStream() {
    return StreamBuilder<DocumentSnapshot>(
      stream: minhaStream.doc(widget.alunoId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text('Aluno Não Encontrado'));
        }

        final docMatricula = snapshot.data!.data() as Map<String, dynamic>;
        final dadosAluno = DadosAluno.fromJson(
          docMatricula['dadosAluno'] ?? {},
        );
        final dadosAcademicos = DadosAcademicos.fromJson(
          docMatricula['dadosAcademicos'],
        );
        final dadosPais = ResponsaveisAluno.fromJson(
          docMatricula['responsaveisAluno'] ?? {},
        );
        final dadosEndereco = EnderecoAluno.fromJson(
          docMatricula['enderecoAluno'] ?? {},
        );
        final dadosMedicos = InformacoesMedicasAluno.fromJson(
          docMatricula['informacoesMedicasAluno'] ?? {},
        );

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.blue.shade100,
                        child: const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dadosAluno.nome,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              dadosAcademicos.numeroMatricula,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${dadosAcademicos.turma}º Ano - ${dadosAcademicos.turno}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildSection(context, 'Dados Pessoais', Icons.person, [
                _buildInfoRow('Nome', dadosAluno.nome),
                _buildInfoRow('CPF', dadosAluno.cpf),
                _buildInfoRow(
                  'Data de Nascimento',
                  dadosAluno.formatarDataNascimento,
                ),
                _buildInfoRow('Sexo', dadosAluno.sexo),
                _buildInfoRow('Naturalidade', dadosAluno.naturalidade),
              ]),
              _buildSection(context, 'Acadêmico', Icons.school, [
                _buildInfoRow('Matrícula', dadosAcademicos.numeroMatricula),
                _buildInfoRow('Série', dadosAcademicos.turma),
                _buildInfoRow('Turno', dadosAcademicos.turno),
                _buildInfoRow('Situação', dadosAcademicos.situacao),
              ]),
              _buildSection(
                context,
                'Pais/Responsáveis',
                Icons.family_restroom,
                [
                  _buildInfoRow('Mãe', dadosPais.nomeMae ?? '---'),
                  _buildInfoRow('Cpf', dadosPais.cpfMae ?? '---'),
                  _buildInfoRow('Telefone', dadosPais.telefoneMae ?? '---'),
                  _buildInfoRow('Pai', dadosPais.nomePai ?? '---'),
                  _buildInfoRow('Cpf', dadosPais.cpfPai ?? '---'),
                  _buildInfoRow('Telefone', dadosPais.telefonePai ?? '---'),
                ],
              ),
              _buildSection(context, 'Endereço', Icons.location_on, [
                _buildInfoRow('Cep', dadosEndereco.cep),
                _buildInfoRow('Cidade', dadosEndereco.cidade),
                _buildInfoRow('Estado', dadosEndereco.estado),
                _buildInfoRow('Rua', dadosEndereco.rua),
                _buildInfoRow('Numero', dadosEndereco.numero),
              ]),
              _buildSection(
                context,
                'Informações Médicas',
                Icons.medical_information,
                [
                  _buildInfoRow(
                    'Tipo(s) Alergia',
                    dadosMedicos.alergia ?? '---',
                  ),
                  _buildInfoRow('Medicação', dadosMedicos.medicacao ?? '---'),
                  _buildInfoRow(
                    'Obeservações',
                    dadosMedicos.observacoes ?? '---',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () async {
                  final pdfService = ContratoPdfService();
                  final pdfPronto = await pdfService.gerarContratoPdf(
                    dadosPdfAluno: dadosAluno,
                    dadosPdfAcademicos: dadosAcademicos,
                    dadosPdfResponsavel: dadosPais,
                    dadosPdfEndereco: dadosEndereco,
                  );
                  await Printing.layoutPdf(onLayout: (format) => pdfPronto);
                },
                label: const Text('Gerar PDF'),
                icon: const Icon(Icons.picture_as_pdf),
              ),
            ],
          ),
        );
      },
    );
  }
}
