import 'package:flutter/material.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';
import 'package:portal_do_aluno/shared/pages/login_page.dart';
import 'package:portal_do_aluno/student/presentatton/pages/attendace_page.dart';
import 'package:portal_do_aluno/student/presentatton/pages/calendar_page.dart';
import 'package:portal_do_aluno/student/presentatton/pages/grades_page.dart';
import 'package:portal_do_aluno/student/presentatton/pages/notices_page.dart';
import 'package:portal_do_aluno/student/presentatton/pages/student_dashboard.dart';

Map<String, WidgetBuilder> get routes => {
  RouteNames.login: (context) => const LoginPage(),
  RouteNames.adminDashboard: (context) => const LoginPage(),
  RouteNames.adminReports: (context) => const LoginPage(),
  RouteNames.changePassword: (context) => const LoginPage(),
  RouteNames.contactSupport: (context) => const LoginPage(),
  RouteNames.editProfile: (context) => const LoginPage(),
  RouteNames.internalServerError: (context) => const LoginPage(),
  //rotas de erro
  RouteNames.notFound: (context) => const LoginPage(),
  RouteNames.error: (context) => const LoginPage(),
  // rotas do Aluno
  RouteNames.studentDashboard: (context) => const StudentDashboard(),
  RouteNames.studentGrades: (context) => const BoletimPage(),
  RouteNames.studentHelp: (context) => const NoticesPage(),
  RouteNames.studentSettings: (context) => const LoginPage(),
  RouteNames.studentTasks: (context) => const LoginPage(),
  RouteNames.studentCalendar: (context) => const CalendarPage(),
  RouteNames.studentAttendance: (context) => const AttendancePage(),
  // rotas de detalhes
  RouteNames.taskDetails: (context) => const LoginPage(),
  RouteNames.addTask: (context) => const LoginPage(),
  RouteNames.messageDetails: (context) => const LoginPage(),
  RouteNames.gradeDetails: (context) => const LoginPage(),
  // rotas do Professor
  RouteNames.teacherDashboard: (context) => const LoginPage(),
  RouteNames.teacherAssignments: (context) => const LoginPage(),
  RouteNames.teacherAttendance: (context) => const LoginPage(),
  RouteNames.teacherCalendar: (context) => const LoginPage(),
  RouteNames.teacherSettings: (context) => const LoginPage(),
  RouteNames.teacherClasses: (context) => const LoginPage(),
  // rotas do Responsável
  RouteNames.parentDashboard: (context) => const LoginPage(),
  RouteNames.parentChildren: (context) => const LoginPage(),
  RouteNames.parentGrades: (context) => const LoginPage(),
  RouteNames.parentAttendance: (context) => const LoginPage(),
  RouteNames.parentCalendar: (context) => const LoginPage(),
  RouteNames.parentSettings: (context) => const LoginPage(),
  // rotas do Administrador
  RouteNames.adminUsers: (context) => const LoginPage(),
  RouteNames.adminSettings: (context) => const LoginPage(),
};

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RouteNames.gradeDetails:
      return _buidRoute(settings, const LoginPage());
  }
  return _buidRoute(settings, const LoginPage());
}

Route<dynamic> _buidRoute(RouteSettings settings, Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secundaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(position: animation.drive(tween), child: child);
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}
