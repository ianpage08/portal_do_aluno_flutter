import 'dart:async';

import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/user/user.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NavigatorService {
  // Usuário logado (opcional)
  static Usuario? _currentUser;

  static BuildContext? get context => navigatorKey.currentContext;

  static void setCurrentUser(Usuario user) {
    _currentUser = user;
  }

  static Usuario? get currentUser => _currentUser;

  static void clearUser() {
    _currentUser = null;
  }

  // ---------- Util helpers ----------
  static NavigatorState? get _navigatorState => navigatorKey.currentState;

  static bool get isNavigatorReady => _navigatorState != null;

  /// Tenta esperar o navigator por até [timeout] antes de prosseguir.
  /// Útil se você quiser garantir navegação logo após init do app.
  static Future<bool> ensureInitializedBeforeNavigation({
    Duration timeout = const Duration(seconds: 3),
    Duration pollInterval = const Duration(milliseconds: 50),
  }) async {
    final completer = Completer<bool>();
    final stopwatch = Stopwatch()..start();

    Timer.periodic(pollInterval, (t) {
      if (isNavigatorReady) {
        t.cancel();
        completer.complete(true);
      } else if (stopwatch.elapsed > timeout) {
        t.cancel();
        completer.complete(false);
      }
    });

    return completer.future;
  }

  // ---------- Navegação segura ----------

  /// Navega para rota nomeada de forma segura.
  /// Retorna null se o navigator ainda não estiver pronto.
  static Future<T?>? navigateTo<T>(String routeName, {Object? arguments}) {
    final state = _navigatorState;
    if (state == null) {
      debugPrint(
        'NavigatorService.navigateTo: navigator não pronto para $routeName',
      );
      return null;
    }
    return state.pushNamed<T>(routeName, arguments: arguments);
  }

  /// Versão que tenta usar navigatorKey, e se não estiver pronta, tenta usar
  /// o context (se disponível). Não lança.
  static Future<T?>? tryNavigateTo<T>(String routeName, {Object? arguments}) {
    final state = _navigatorState;
    if (state != null) {
      return state.pushNamed<T>(routeName, arguments: arguments);
    }

    final ctx = navigatorKey.currentContext;
    if (ctx != null) {
      debugPrint(
        'NavigatorService.tryNavigateTo: fallback para Navigator.of(context) -> $routeName',
      );
      return Navigator.of(ctx).pushNamed<T>(routeName, arguments: arguments);
    }

    debugPrint(
      'NavigatorService.tryNavigateTo: impossível navegar agora -> $routeName',
    );
    return null;
  }

  static Future<T?>? navigateToWithAnimation<T>(
    Widget page, {
    RouteTransitionsBuilder transitionsBuilder = _defaultTransition,
  }) {
    final state = _navigatorState;
    if (state == null) {
      debugPrint('navigateToWithAnimation: navigator não pronto');
      return null;
    }
    return state.push<T>(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: transitionsBuilder,
        transitionDuration: const Duration(milliseconds: 200),
      ),
    );
  }

  static Widget _defaultTransition(
    BuildContext context,
    Animation<double> a,
    Animation<double> sa,
    Widget child,
  ) => FadeTransition(opacity: a, child: child);

  static void showSnackBar(String message) {
    final contextLocal = navigatorKey.currentContext;
    if (contextLocal == null) {
      debugPrint('showSnackBar: context nulo -> $message');
      return;
    }

    ScaffoldMessenger.of(contextLocal).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static Future<T?>? navigateReplaceWith<T, TO>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    final state = _navigatorState;
    if (state == null) {
      debugPrint('navigateReplaceWith: navigator não pronto para $routeName');
      return null;
    }
    return state.pushReplacementNamed<T, TO>(
      routeName,
      result: result,
      arguments: arguments,
    );
  }

  static Future<T?>? navigateAndRemoveUntil<T>(
    String routeName, {
    Object? arguments,
  }) {
    final state = _navigatorState;
    if (state == null) {
      debugPrint(
        'navigateAndRemoveUntil: navigator não pronto para $routeName',
      );
      return null;
    }
    return state.pushNamedAndRemoveUntil<T>(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  static void goBack<T>([T? result]) {
    final state = _navigatorState;
    if (state == null) {
      debugPrint('goBack: navigator não pronto');
      // fallback para context Navigator (se disponível)
      final ctx = navigatorKey.currentContext;
      if (ctx != null && Navigator.of(ctx).canPop()) {
        Navigator.of(ctx).pop<T>(result);
      }
      return;
    }
    if (state.canPop()) {
      state.pop<T>(result);
    } else {
      debugPrint('goBack: não era possível dar pop, canPop == false');
    }
  }

  static bool canGoBack() {
    final state = _navigatorState;
    if (state == null) return false;
    return state.canPop();
  }

  // ---------- Rotas específicas ----------

  static Future<void> navigateToDashboard([Usuario? user]) async {
  final userToUse = user ?? _currentUser;

  if (userToUse == null) {
    await navigateAndRemoveUntil(RouteNames.login);
    return;
  }

  late final String route;

  switch (userToUse.type) {
    case UserType.student:
      route = RouteNames.studentDashboard;
      break;
    case UserType.teacher:
      route = RouteNames.teacherDashboard;
      break;
    case UserType.parent:
      route = RouteNames.parentDashboard;
      break;
    case UserType.admin:
      route = RouteNames.adminDashboard;
      break;
    
  }

  await navigateAndRemoveUntil(
    route,
    arguments: {'user': userToUse.toJsonSafe()},
  );
}

  static Future<void> logout() async {
  clearUser();
  await navigateAndRemoveUntil(RouteNames.login);
}


 

  
  

  // Rotas de erro
  static Future<void> navigateToNotFound() {
    return navigateTo(RouteNames.notFound) ?? Future.value();
  }

  static Future<void> navigateToInternalServerError() {
    return navigateTo(RouteNames.internalServerError) ?? Future.value();
  }

  static Future<void> navigateToError(String errorMessage) {
    return navigateTo(
          RouteNames.error,
          arguments: {'errorMessage': errorMessage},
        ) ??
        Future.value();
  }
}
