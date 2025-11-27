import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/shared/widgets/navigation_bottonbar.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/transicao_page.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class ConfiguracaoPage extends StatefulWidget {
  const ConfiguracaoPage({super.key});

  @override
  State<ConfiguracaoPage> createState() => _ConfiguracaoPageState();
}

class _ConfiguracaoPageState extends State<ConfiguracaoPage> {
  final List<Widget> _pages = [
    const Center(child: Text('Página de Configurações')),
    const Center(child: Text('Página de Ajuda')),
    const Center(child: Text('Página de Suporte')),
  ];
  int _selectedIndex = 0;

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Configurações'),
      bottomNavigationBar: NavigationBottonbar(
        pageIndex: _selectedIndex,
        onTap: _onItemTap,
        items: const [
          CustomBottomItem(
            label: 'Configurações',
            icon: CupertinoIcons.settings,
          ),
          CustomBottomItem(
            label: 'Ajuda',
            icon: CupertinoIcons.question_circle,
          ),
          CustomBottomItem(label: 'Suporte', icon: CupertinoIcons.phone),
        ],
      ),
      body: TransicaoPage(child: _pages[_selectedIndex]),
    );
  }
}
