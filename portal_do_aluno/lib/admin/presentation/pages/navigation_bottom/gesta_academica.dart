import 'package:flutter/material.dart';
import 'package:portal_do_aluno/admin/presentation/pages/gestao_escolar/controle_de_calendario.dart';
import 'package:flutter/cupertino.dart';
import 'package:portal_do_aluno/admin/presentation/pages/gestao_escolar/diciplinas_page.dart';
import 'package:portal_do_aluno/admin/presentation/pages/gestao_escolar/matriculas_page.dart';

import 'package:portal_do_aluno/admin/presentation/pages/turma_page.dart';
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.doc_chart),
            label: 'Turmas',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.book),
            label: 'Disciplinas',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.calendar_badge_plus),
            label: 'Calendario',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_2_fill),
            label: 'Matriculas',
          ),
        ],
      ),
      body: _pages[_selectedIndex],
    );
  }
}
