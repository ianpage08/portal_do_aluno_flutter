import 'package:flutter/material.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/add_usuarios.dart';
import 'package:portal_do_aluno/features/admin/presentation/pages/lista_de_usuarios_page.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/navigation_bottonbar.dart';
import 'package:portal_do_aluno/features/admin/presentation/widgets/transicao_page.dart';
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
      bottomNavigationBar: NavigationBottonbar(
        onTap: _onItemTap,
        pageIndex: _selectedIndex,
        items: const [
          CustomBottomItem(label: 'Adicionar', icon: CupertinoIcons.person_add),
          CustomBottomItem(
            label: 'Lista De Usuarios',
            icon: CupertinoIcons.person_2_square_stack,
          ),
        ],
      ),
      body: TransicaoPage(child: _pages[_selectedIndex]),
    );
  }
}
