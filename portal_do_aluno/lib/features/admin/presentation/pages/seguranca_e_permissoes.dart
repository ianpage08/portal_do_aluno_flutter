import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class SegurancaEPermissoes extends StatefulWidget {
  const SegurancaEPermissoes({super.key});

  @override
  State<SegurancaEPermissoes> createState() => _SegurancaEPermissoesState();
}

class _SegurancaEPermissoesState extends State<SegurancaEPermissoes> {
  final Map<String, dynamic> _dadosSeguranca = {
    'usuariosAtivos': 368,
    'professores': 25,
    'alunos': 265,
    'administradores': 3,
    'ultimoLoginSuspeito':
        'Último login suspeito há 10 horas - user@escola.com',
    'tentativasLogin': 12,
    'sessaoesAtivas': 45,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Segurança e Permissões'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUsuariosAtivos(),
            const SizedBox(height: 20),
            _buildPerfisCadastrados(),
            const SizedBox(height: 20),
            _buildAlertaSeguranca(),
            const SizedBox(height: 20),
            _buildSessoesAtivas(),
            const SizedBox(height: 20),
            _buildAcoesRapidas(),
          ],
        ),
      ),
    );
  }

  Widget _buildUsuariosAtivos() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.group, size: 30, color: Colors.green),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_dadosSeguranca['usuariosAtivos']}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Usuários Ativos',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Online',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerfisCadastrados() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.admin_panel_settings, color: Colors.blue),
                SizedBox(width: 12),
                Text(
                  'Perfis Cadastrados',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildItemPerfil(
                  'Professores',
                  '${_dadosSeguranca['professores']}',
                  Icons.school,
                  Colors.blue,
                ),
                _buildItemPerfil(
                  'Alunos',
                  '${_dadosSeguranca['alunos']}',
                  Icons.person,
                  Colors.orange,
                ),
                _buildItemPerfil(
                  'Admins',
                  '${_dadosSeguranca['administradores']}',
                  Icons.security,
                  Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemPerfil(
    String titulo,
    String valor,
    IconData icone,
    Color cor,
  ) {
    return Column(
      children: [
        Icon(icone, size: 40, color: cor),
        const SizedBox(height: 8),
        Text(
          valor,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: cor,
          ),
        ),
        Text(titulo, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildAlertaSeguranca() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.warning_amber_outlined, color: Colors.orange),
            SizedBox(width: 12),
            Text(
              'Alertas de Segurança',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildItemAlerta(
          Icons.login,
          _dadosSeguranca['ultimoLoginSuspeito'],
          Colors.deepOrange,
        ),
        _buildItemAlerta(
          Icons.block,
          '${_dadosSeguranca['tentativasLogin']} Tentativas de Login Falharam',
          Colors.red,
        ),
      ],
    );
  }

  Widget _buildSessoesAtivas() {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.devices, color: Colors.purple),
        title: const Text('Sessões Ativas'),
        subtitle: Text(
          '${_dadosSeguranca['sessaoesAtivas']} usuários conectados',
        ),
        trailing: TextButton(
          onPressed: () => _toast('TODO: Ver detalhes das sessões'),
          child: const Text('Ver Detalhes'),
        ),
      ),
    );
  }

  Widget _buildAcoesRapidas() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.security, color: Colors.indigo),
                SizedBox(width: 12),
                Text(
                  'Ações Rápidas',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _toast('TODO: Logout geral realizado'),
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout Geral'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _toast('TODO: Backup iniciado'),
                    icon: const Icon(Icons.backup),
                    label: const Text('Backup'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _toast('TODO: Relatório de segurança gerado'),
                icon: const Icon(Icons.report),
                label: const Text('Gerar Relatório de Segurança'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemAlerta(IconData ico, String mensagem, Color cor) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(ico, color: cor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                mensagem,
                style: TextStyle(color: cor, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
