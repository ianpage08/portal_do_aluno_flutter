import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/gestao_escolar/controle_de_calendario_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/gestao_escolar/diciplinas_page_page.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/gestao_escolar/matriculas_page.dart';

import 'package:portal_do_aluno/features/admin/presentation/pages/turma_page.dart';
import 'package:portal_do_aluno/shared/widgets/navigation_bottonbar.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/transicao_page.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class GestaAcademica extends StatefulWidget {
  const GestaAcademica({super.key});

  @override
  State<GestaAcademica> createState() => _GestaAcademicaState();
}

class _GestaAcademicaState extends State<GestaAcademica> {
  final List<Widget> _pages = [
    const TurmaPage(),
    const DiciplinasPage(),
    const ControleDeCalendario(),
    const MatriculasPage(),
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
      appBar: const CustomAppBar(title: 'Gestão Escolar'),

      bottomNavigationBar: NavigationBottonbar(
        onTap: _onItemTap,
        pageIndex: _selectedIndex,

        items: const [
          CustomBottomItem(label: 'Turmas', icon: CupertinoIcons.doc_append),
          CustomBottomItem(label: 'Disciplinas', icon: CupertinoIcons.book),
          CustomBottomItem(
            label: 'Calendário',
            icon: CupertinoIcons.calendar_badge_plus,
          ),
          CustomBottomItem(label: 'Matriculas', icon: CupertinoIcons.person_3),
        ],
      ),
      body: TransicaoPage(child: _pages[_selectedIndex]),
    );
  }
}
