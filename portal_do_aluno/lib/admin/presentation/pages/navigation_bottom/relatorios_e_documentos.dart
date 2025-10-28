import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/admin/presentation/pages/gerar_documentos.dart';
import 'package:portal_do_aluno/admin/presentation/pages/relatorios_e_idicadores.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class RelatoriosDocumentosPage extends StatefulWidget {
  const RelatoriosDocumentosPage({super.key});

  @override
  State<RelatoriosDocumentosPage> createState() =>
      _RelatoriosDocumentosPageState();
}

class _RelatoriosDocumentosPageState extends State<RelatoriosDocumentosPage> {
  final List<Widget> _pages = [
    const RelatoriosGerenciais(),
    const GerarDocumentosPage(),
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
      appBar: const CustomAppBar(title: 'Relatórios de Documentos'),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTap,
        currentIndex: _selectedIndex,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chart_bar_alt_fill),
            label: 'Relatórios Gerenciais',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.doc_on_doc),
            label: 'Gerar',
          ),
        ],
      ),
      body: _pages[_selectedIndex],
    );
  }
}
