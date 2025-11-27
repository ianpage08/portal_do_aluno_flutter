import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/gerar_documentos.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/relatorios.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/navigation_bottonbar.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/transicao_page.dart';
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
      appBar: const CustomAppBar(title: 'Rela e Doc'),
      bottomNavigationBar: NavigationBottonbar(
        pageIndex: _selectedIndex,
        onTap: _onItemTap,
        items: const [
          CustomBottomItem(
            label: 'Relatórios',
            icon: CupertinoIcons.chart_bar_alt_fill,
          ),
          CustomBottomItem(
            label: 'Documentos',
            icon: CupertinoIcons.doc_on_doc,
          ),
        ],
      ),
      body: TransicaoPage(child: _pages[_selectedIndex]),
    );
  }
}
