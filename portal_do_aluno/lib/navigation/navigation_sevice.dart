import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/user/user.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';

/*O que é GlobalKey<NavigatorState>: Chave única que dá acesso ao Navigator de qualquer lugar do app. 
NavigatorState: Estado interno do Navigator (pilha de rotas)
 */
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NavigatorService {
  //tipo de usuario logado
  static User? _currentUser;

  static BuildContext? get context => navigatorKey.currentContext;

  //pegar o usuario atual
  static void setCurrentUser(User user) {
    _currentUser = user;
  }

  //Get usuario atual
  static User? get currentUser => _currentUser;

  //limpar usuario atual
  static void clearUser() {
    _currentUser = null;
  }

  /*Navegação basica */

  //navegar para uma nova rota
  static Future<T?> navigateTo<T>(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  //remover todas as rotas anteriores e ir para a nova rota
  static Future<T?> navigateReplaceWith<T, TO>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return navigatorKey.currentState!.pushReplacementNamed(
      routeName,
      result: result,
      arguments: arguments,
    );
  }

  //remover todas as rotas e ir para a nova rota
  static Future<T?> navigateAndRemoveUntil<T>(
    String routeName, {
    Object? arguments,
  }) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  // Voltar para tela anterior
  static void goBack<T>([T? result]) {
    return navigatorKey.currentState!.pop<T>(result);
  }

  // Verificar se pode voltar
  static bool canGoBack() {
    return navigatorKey.currentState!.canPop();
  }

  // NAVEGAÇÃO ESPECÍFICA POR TIPO DE USUÁRIO

  static Future<void> navigateToDashboard([User? user]) {
    final userToUse = user ?? _currentUser;
    if (userToUse == null) {
      return navigateAndRemoveUntil(RouteNames.login);
    }
    String route;

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
    return navigateAndRemoveUntil(
      route,
      arguments: {'user': userToUse.toJsonSafe()},




      
    );
  }

  static Future<void> logout() {
    clearUser();
    return navigateAndRemoveUntil(RouteNames.login);
  }

  // === NAVEGAÇÃO PARA FUNCIONALIDADES DO ALUNO ===
  static Future<void> navigateToStudentDashboard() {
    _validateUserType(UserType.student);
    return navigateTo(RouteNames.studentDashboard);
  }

  static Future<void> navigateToCalendar() {
    _validateUserType(UserType.student);
    return navigateTo(RouteNames.studentCalendar);
  }

  static Future<void> navigateToAttendance() {
    _validateUserType(UserType.student);
    return navigateTo(RouteNames.studentAttendance);
  }

  static Future<void> navigateToGrade() {
    _validateUserType(UserType.student);
    return navigateTo(RouteNames.studentGrades);
  }

  static Future<void> navigateToTask() {
    _validateUserType(UserType.student);
    return navigateTo(RouteNames.studentTasks);
  }

  static Future<void> navigateToStudentSettings() {
    _validateUserType(UserType.student);
    return navigateTo(RouteNames.studentSettings);
  }

  static Future<void> navigateToStudentHelp() {
    _validateUserType(UserType.student);
    return navigateTo(RouteNames.studentHelp);
  }

  // === NAVEGAÇÃO PARA FUNCIONALIDADES DO PROFESSOR ===
  static Future<void> navigateToTeacherDashboard() {
    _validateUserType(UserType.teacher);
    return navigateTo(RouteNames.teacherDashboard);
  }

  static Future<void> navigateToTeacherClasses() {
    _validateUserType(UserType.teacher);
    return navigateTo(RouteNames.teacherClasses, arguments: {
      'teacherId': _currentUser!.id.toString(),
    });
  }

  static Future<void> navigateToTeacherAssignments() {
    _validateUserType(UserType.teacher);
    return navigateTo(RouteNames.teacherAssignments);
  }

  static Future<void> navigateToTeacherAttendance() {
    _validateUserType(UserType.teacher);
    return navigateTo(RouteNames.teacherAttendance);
  }

  static Future<void> navigateToTeacherCalendar() {
    _validateUserType(UserType.teacher);
    return navigateTo(RouteNames.teacherCalendar);
  }

  static Future<void> navigateToTeacherSettings() {
    _validateUserType(UserType.teacher);
    return navigateTo(RouteNames.teacherSettings);
  }

  // === NAVEGAÇÃO PARA FUNCIONALIDADES DO RESPONSÁVEL ===
  static Future<void> navigateToParentDashboard() {
    _validateUserType(UserType.parent);
    return navigateTo(RouteNames.parentDashboard);
  }

  static Future<void> navigateToParentChildren() {
    _validateUserType(UserType.parent);
    return navigateTo(RouteNames.parentChildren, arguments: {
      'parentId': _currentUser!.id.toString(),
    });
  }

  static Future<void> navigateToParentGrades() {
    _validateUserType(UserType.parent);
    return navigateTo(RouteNames.parentGrades);
  }

  static Future<void> navigateToParentAttendance() {
    _validateUserType(UserType.parent);
    return navigateTo(RouteNames.parentAttendance);
  }

  static Future<void> navigateToParentCalendar() {
    _validateUserType(UserType.parent);
    return navigateTo(RouteNames.parentCalendar);
  }

  static Future<void> navigateToParentSettings() {
    _validateUserType(UserType.parent);
    return navigateTo(RouteNames.parentSettings);
  }

  // Navegar para notas de um filho específico
  static Future<void> navigateToChildGrades({
    required String childId,
    required String childName,
  }) {
    _validateUserType(UserType.parent);
    return navigateTo(RouteNames.studentGrades, arguments: {
      'studentId': childId,
      'studentName': childName,
      'isParentView': true,
    });
  }

  // === NAVEGAÇÃO PARA FUNCIONALIDADES DO ADMIN ===
  static Future<void> navigateToAdminDashboard() {
    _validateUserType(UserType.admin);
    return navigateTo(RouteNames.adminDashboard);
  }

  static Future<void> navigateToAdminUsers() {
    _validateUserType(UserType.admin);
    return navigateTo(RouteNames.adminUsers);
  }

  static Future<void> navigateToAdminReports() {
    _validateUserType(UserType.admin);
    return navigateTo(RouteNames.adminReports);
  }

  static Future<void> navigateToAdminSettings() {
    _validateUserType(UserType.admin);
    return navigateTo(RouteNames.adminSettings);
  }

  // === NAVEGAÇÃO PARA PÁGINAS COMPARTILHADAS ===
  // Configurações (disponível para todos os tipos)
  static Future<void> navigateToSettings() {
    if (_currentUser == null) {
      showErrorDialog('Usuário não autenticado');
      return Future.value();
    }

    String route;
    switch (_currentUser!.type) {
      case UserType.student:
        route = RouteNames.studentSettings;
        break;
      case UserType.teacher:
        route = RouteNames.teacherSettings;
        break;
      case UserType.parent:
        route = RouteNames.parentSettings;
        break;
      case UserType.admin:
        route = RouteNames.adminSettings;
        break;
    }

    return navigateTo(route);
  }

  // === NAVEGAÇÃO PARA PÁGINAS DE DETALHES (COM ARGUMENTOS) ===
  static Future<void> navigateToTaskDetails(String taskId) {
    return navigateTo(RouteNames.taskDetails, arguments: {
      'taskId': taskId,
    });
  }

  static Future<void> navigateToMessageDetails(String messageId) {
    return navigateTo(RouteNames.messageDetails, arguments: {
      'messageId': messageId,
    });
  }

  static Future<void> navigateToGradeDetails({
    required String gradeId,
    required String studentId,
  }) {
    // Validar se o usuário pode ver essas notas
    if (_currentUser == null) {
      showErrorDialog('Usuário não autenticado');
      return Future.value();
    }

    // Aluno só pode ver suas próprias notas
    if (_currentUser!.type == UserType.student && 
        _currentUser!.id.toString() != studentId) {
      showErrorDialog('Você não tem permissão para ver essas notas');
      return Future.value();
    }

    return navigateTo(RouteNames.gradeDetails, arguments: {
      'gradeId': gradeId,
      'studentId': studentId,
    });
  }

  // === NAVEGAÇÃO PARA PÁGINAS DE FORMULÁRIO ===
  static Future<void> navigateToEditProfile() {
    return navigateTo(RouteNames.editProfile);
  }

  static Future<void> navigateToChangePassword() {
    return navigateTo(RouteNames.changePassword);
  }

  static Future<void> navigateToContactSupport() {
    return navigateTo(RouteNames.contactSupport);
  }

  static Future<void> navigateToAddTask() {
    return navigateTo(RouteNames.addTask);
  }

  // === NAVEGAÇÃO PARA PÁGINAS DE ERRO ===
  static Future<void> navigateToNotFound() {
    return navigateTo(RouteNames.notFound);
  }

  static Future<void> navigateToInternalServerError() {
    return navigateTo(RouteNames.internalServerError);
  }

  static Future<void> navigateToError(String errorMessage) {
    return navigateTo(RouteNames.error, arguments: {
      'errorMessage': errorMessage,
    });
  }

  // === MÉTODOS AUXILIARES ===
  
  // Validar se o usuário atual tem o tipo correto
  static void _validateUserType(UserType requiredUserType) {
    /*if (_currentUser == null) {
      showErrorDialog('Usuário não autenticado');
      logout();
      return;
    }

    if (_currentUser!.type != requiredUserType) {
      showErrorDialog('Você não tem permissão para acessar esta funcionalidade');
      navigateToDashboard();
      return;
    }*/
  }

  // Verificar se o usuário tem permissão para uma funcionalidade
  static bool hasPermission(List<UserType> allowedTypes) {
    if (_currentUser == null) return false;
    return allowedTypes.contains(_currentUser!.type);
  }

  // === UTILITÁRIOS ===
  static void showErrorDialog(String mensagem) {
    if (context != null) {
      showDialog(
        context: context!,
        builder: (context) => AlertDialog(
          title: const Text('Erro'),
          content: Text(mensagem),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  static void showSnackBar(String message, {Color? backgroundColor}) {
    if (context != null) {
      ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor ?? Colors.red,
        ),
      );
    }
  }

  // Mostrar diálogo de confirmação
  static Future<bool> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
  }) async {
    if (context == null) return false;

    final result = await showDialog<bool>(
      context: context!,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  // Mostrar diálogo de confirmação de logout
  static Future<void> showLogoutConfirmation() async {
    final shouldLogout = await showConfirmDialog(
      title: 'Confirmar Logout',
      message: 'Tem certeza que deseja sair?',
      confirmText: 'Sair',
      cancelText: 'Cancelar',
    );

    if (shouldLogout) {
      await logout();
    }
  }
}