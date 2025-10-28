import 'package:flutter/material.dart';
import 'package:portal_do_aluno/admin/presentation/pages/add_usuarios.dart';
import 'package:portal_do_aluno/admin/presentation/pages/lista_de_usuarios_page.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';
import 'package:flutter/cupertino.dart';

class GestaoDeUsuarios extends StatefulWidget {
  const GestaoDeUsuarios({super.key});

  @override
  State<GestaoDeUsuarios> createState() => _GestaoDeUsuariosState();
}

class _GestaoDeUsuariosState extends State<GestaoDeUsuarios> {
  final List<Widget> _pages = [
    const AddUsuarioPage(),
    const ListaDeUsuariosPage(),
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
      appBar: const CustomAppBar(title: 'Gestão de Usuários'),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_add),
            label: 'adicionar Usuário',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_2_fill),
            label: 'Lista de Usuários',
          ),
        ],
      ),
      body: _pages[_selectedIndex],
    );
  }
}
