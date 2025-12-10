import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:portal_do_aluno/core/theme/dark_theme.dart';
import 'package:portal_do_aluno/core/theme/light_theme.dart';
import 'package:portal_do_aluno/core/theme/theme_provider.dart';
import 'package:portal_do_aluno/navigation/app_route.dart';
import 'package:portal_do_aluno/navigation/navigation_sevice.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

class MyApp extends StatelessWidget {
  
  const MyApp({super.key, });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 500, name: MOBILE),
          const Breakpoint(start: 501, end: 800, name: TABLET),
          const Breakpoint(start: 800, end: double.infinity, name: DESKTOP),
        ],
      ),
      navigatorKey: navigatorKey,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      title: 'Portal do Aluno',
      themeMode: themeProvider.themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,

      initialRoute: RouteNames.slashScreen,
      routes: routes,
      onGenerateRoute: onGenerateRoute,

      debugShowCheckedModeBanner: false,
    );
  }
}
