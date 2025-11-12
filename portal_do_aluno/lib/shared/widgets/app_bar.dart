import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/notifications/pages/notification_poup.dart';
import 'package:portal_do_aluno/core/theme/theme_provider.dart';
import 'package:portal_do_aluno/navigation/navigation_sevice.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';
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

        NotificationPoup(userId: userId, route: nameRoute,),
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
