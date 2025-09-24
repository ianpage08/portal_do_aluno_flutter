import 'package:flutter/material.dart';
import 'package:portal_do_aluno/navigation/navigation_sevice.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? backGround;

  const CustomAppBar({super.key, required this.title, this.backGround});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor:
          backGround ?? Colors.deepPurple, // cor padrão se não passar nada
      centerTitle: true,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          onPressed: () {
            // ação de notificação
          },
          icon: const Icon(Icons.notifications),
        ),
        IconButton(
          onPressed: () {
            NavigatorService.navigateTo(RouteNames.login);
          },
          icon: const Icon(Icons.logout),
        ),
      ],
    );
  }
}
