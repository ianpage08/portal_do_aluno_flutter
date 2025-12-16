import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/notifications/pages/notification_poup.dart';
import 'package:portal_do_aluno/core/theme/theme_provider.dart';
import 'package:portal_do_aluno/navigation/navigation_sevice.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';
import 'package:portal_do_aluno/shared/helpers/show_confirmation_dialog.dart';
import 'package:portal_do_aluno/shared/services/auth_storage_token.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? backGround;
  final String? userId;
  final String? nameRoute;

  const CustomAppBar({
    super.key,
    required this.title,
    this.backGround,
    this.userId,
    this.nameRoute,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    Future<void> logout() async {
      // Limpa storage
      await AuthStorageService().deleteToken();
      await AuthStorageService().deleteUser();
      // Navega limpando stack
      await NavigatorService.navigateAndRemoveUntil(RouteNames.login);
    }

    final themeProvider = Provider.of<ThemeProvider>(context);
    return AppBar(
      title: Text(title),
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      centerTitle: true,
      foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      actions: [
        Switch(
          value: themeProvider.isDarkmode,
          onChanged: (value) {
            themeProvider.setTheme(value);
          },
        ),

        NotificationPoup(userId: userId, route: nameRoute),
        IconButton(
          onPressed: () async {
            final sair = await showConfirmationDialog(
              context: context,
              title: 'Deseja Sair?',
              content: 'voce realmente deseja sair?',
              confirmText: 'Sair',
            );
            if (sair == true) { 
              await AuthStorageService().deleteToken();
              debugPrint('Token deletado');
              await AuthStorageService().deleteUser();
              debugPrint('Usuario deletado');
              logout();
            }
          },
          icon: const Icon(Icons.logout),
        ),
      ],
    );
  }
}
