import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class DetalhesAluno extends StatelessWidget {
  const DetalhesAluno({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Detalhes do Aluno'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto e informações básicas
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
                            'João Silva Santos',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Matrícula: 2024001234',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '9º Ano - Turma A',
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

            // Dados Pessoais
            _buildSection(context, 'Dados Pessoais', Icons.person_outline, [
              _buildInfoRow('Nome Completo', 'João Silva Santos'),
              _buildInfoRow('Data de Nascimento', '15/03/2010'),
              _buildInfoRow('Idade', '14 anos'),
              _buildInfoRow('Sexo', 'Masculino'),
              _buildInfoRow('Naturalidade', 'São Paulo - SP'),
            ]),

            // Documentos
            _buildSection(context, 'Documentos', Icons.description_outlined, [
              _buildInfoRow('CPF', '123.456.789-00'),
              _buildInfoRow('RG', '12.345.678-9 SSP/SP'),
              _buildInfoRow(
                'Certidão de Nascimento',
                '123456 01 55 2010 1 00001 123 1234567 12',
              ),
              _buildInfoRow('Cartão SUS', '123 4567 8901 2345'),
            ]),

            // Dados dos Pais/Responsáveis
            _buildSection(context, 'Pais/Responsáveis', Icons.family_restroom, [
              _buildInfoRow('Nome da Mãe', 'Maria Silva Santos'),
              _buildInfoRow('CPF da Mãe', '987.654.321-00'),
              _buildInfoRow('Telefone da Mãe', '(11) 99999-1234'),
              const Divider(),
              _buildInfoRow('Nome do Pai', 'José Santos Silva'),
              _buildInfoRow('CPF do Pai', '456.789.123-00'),
              _buildInfoRow('Telefone do Pai', '(11) 99999-5678'),
            ]),

            // Endereço
            _buildSection(context, 'Endereço', Icons.location_on_outlined, [
              _buildInfoRow('CEP', '01234-567'),
              _buildInfoRow('Logradouro', 'Rua das Flores, 123'),
              _buildInfoRow('Bairro', 'Centro'),
              _buildInfoRow('Cidade', 'São Paulo'),
              _buildInfoRow('Estado', 'São Paulo'),
            ]),

            // Informações Acadêmicas
            _buildSection(
              context,
              'Informações Acadêmicas',
              Icons.school_outlined,
              [
                _buildInfoRow('Número da Matrícula', '2024001234'),
                _buildInfoRow('Data da Matrícula', '01/02/2024'),
                _buildInfoRow('Série/Ano', '9º Ano'),
                _buildInfoRow('Turma', 'Turma A'),
                _buildInfoRow('Turno', 'Matutino'),
                _buildInfoRow('Status', 'Ativo', valueColor: Colors.green),
              ],
            ),

            // Informações Médicas
            _buildSection(
              context,
              'Informações Médicas',
              Icons.medical_services_outlined,
              [
                _buildInfoRow('Tipo Sanguíneo', 'O+'),
                _buildInfoRow('Alergias', 'Nenhuma alergia conhecida'),
                _buildInfoRow('Medicamentos', 'Nenhum medicamento contínuo'),
                _buildInfoRow('Observações', 'Usa óculos para leitura'),
              ],
            ),

            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pdf Gerado com Todos os dados do aluno '),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              label: const Text('Gerar PDF'),
              icon: const Icon(Icons.picture_as_pdf),
            ),
          ],
        ),
      ),
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
}
