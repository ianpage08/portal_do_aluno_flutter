import 'package:flutter/material.dart';
import 'package:portal_do_aluno/admin/presentation/pages/diciplinas_page.dart';
import 'package:portal_do_aluno/admin/presentation/pages/matriculas_page.dart';
import 'package:portal_do_aluno/admin/presentation/pages/relatorios_page.dart';
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
    const MatriculasPage(),
    const RelatoriosPage(),
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Gestão Escolar'),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.class_),
                label: Text('Turmas'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.menu_book),
                label: Text('Disciplinas'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.how_to_reg),
                label: Text('Matriculas'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.assessment),
                label: Text('Relatorios'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
    );
  }
}
