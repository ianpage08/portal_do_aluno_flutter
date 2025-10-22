import 'package:flutter/material.dart';

import 'package:portal_do_aluno/admin/presentation/pages/admin_dashboard.dart';
import 'package:portal_do_aluno/admin/presentation/pages/boletim_page.dart';
import 'package:portal_do_aluno/admin/presentation/pages/cadastrar_disciplina.dart';
import 'package:portal_do_aluno/admin/presentation/pages/cadastro_turma.dart';
import 'package:portal_do_aluno/admin/presentation/pages/conteudo_dado.dart';
import 'package:portal_do_aluno/admin/presentation/pages/controle_de_calendario.dart';
import 'package:portal_do_aluno/admin/presentation/pages/detalhes_do_aluno_test.dart';
import 'package:portal_do_aluno/admin/presentation/pages/frequencia_admin.dart';
import 'package:portal_do_aluno/admin/presentation/pages/gerar_documentos.dart';
import 'package:portal_do_aluno/admin/presentation/pages/gesta_academica.dart';
import 'package:portal_do_aluno/admin/presentation/pages/gestao_de_comunicados_e_avisos.dart';
import 'package:portal_do_aluno/admin/presentation/pages/gestao_de_usuarios.dart';
import 'package:portal_do_aluno/admin/presentation/pages/lista_de_usuarios_page.dart';
import 'package:portal_do_aluno/admin/presentation/pages/matricula_cadastro.dart';
import 'package:portal_do_aluno/admin/presentation/pages/relatorios_e_idicadores.dart';
import 'package:portal_do_aluno/admin/presentation/pages/seguranca_e_permissoes.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';
import 'package:portal_do_aluno/features/presetention/pages/login_page.dart';
import 'package:portal_do_aluno/student/presentation/pages/attendace_page.dart';
import 'package:portal_do_aluno/student/presentation/pages/calendar_page.dart';
import 'package:portal_do_aluno/student/presentation/pages/grades_page.dart';

import 'package:portal_do_aluno/student/presentation/pages/notices_page.dart';
import 'package:portal_do_aluno/student/presentation/pages/student_dashboard.dart';
import 'package:portal_do_aluno/teacher/presentation/pages/add_grade_page.dart';
import 'package:portal_do_aluno/teacher/presentation/pages/class_page.dart';
import 'package:portal_do_aluno/teacher/presentation/pages/send_notice_page.dart';
import 'package:portal_do_aluno/teacher/presentation/pages/teacher_dashboard.dart';

Map<String, WidgetBuilder> get routes => {
  RouteNames.login: (context) => const LoginPage(),
  RouteNames.adminMatriculaCadastro: (context) => const MatriculaCadastro(),
  RouteNames.adminDashboard: (context) => const AdminDashboard(),
  RouteNames.adminReports: (context) => const LoginPage(),
  RouteNames.adminGestao: (context) => const GestaoDeUsuarios(),
  RouteNames.adminGestaoEscolar: (context) => const GestaAcademica(),
  RouteNames.adminGeracaoDocumentos: (context) => const GerarDocumentosPage(),
  RouteNames.adminListaDeUsuarios: (context) => const ListaDeUsuariosPage(),
  RouteNames.adminFrequencia: (context) => const FrequenciaAdmin(),
  RouteNames.adminComunicacaoInstiticional: (context) =>
      const ComunicacaoInstitucionalPage(),
  RouteNames.adminDetalhesAlunos: (context) {
    final argumentos = ModalRoute.of(context)!.settings.arguments as String;
    return DetalhesAluno(alunoId: argumentos);
  },
  RouteNames.adminCalendar: (context) => const ControleDeCalendario(),
  RouteNames.boletim: (context) => const BoletimAddNotaPage(),
  RouteNames.adminRelatoriosGerenciais: (context) =>
      const RelatoriosGerenciais(),
  RouteNames.adminCadastroTurmas: (context) => const CadastroTurma(),
  RouteNames.adminCadastrarDisciplina: (context) => const CadastrarDisciplina(),
  RouteNames.adminSegurancaEPermissoes: (context) =>
      const SegurancaEPermissoes(),
  RouteNames.changePassword: (context) => const LoginPage(),
  RouteNames.contactSupport: (context) => const LoginPage(),
  RouteNames.editProfile: (context) => const LoginPage(),
  RouteNames.internalServerError: (context) => const LoginPage(),
  RouteNames.addOqueFoiDado: (context) => const OqueFoiDado(),

  //rotas de erro
  RouteNames.notFound: (context) => const LoginPage(),
  RouteNames.error: (context) => const LoginPage(),
  // rotas do Aluno
  RouteNames.studentDashboard: (context) => const StudentDashboard(),
  RouteNames.studentGrades: (context) => const LoginPage(),
  RouteNames.studentHelp: (context) => const NoticesPage(),
  RouteNames.studentSettings: (context) => const LoginPage(),
  RouteNames.studentTasks: (context) => const LoginPage(),
  RouteNames.studentCalendar: (context) => const CalendarPage(),
  RouteNames.studentAttendance: (context) => const AttendancePage(),
  RouteNames.studentComunicados: (context) => const NoticesPage(),
  RouteNames.studentBoletim: (context) => const BoletimPage(),
  // rotas de detalhes
  RouteNames.taskDetails: (context) => const LoginPage(),
  RouteNames.addTask: (context) => const LoginPage(),
  RouteNames.messageDetails: (context) => const LoginPage(),
  RouteNames.gradeDetails: (context) => const LoginPage(),
  // rotas do Professor
  RouteNames.teacherDashboard: (context) => const TeacherDashboard(),
  RouteNames.teacherAssignments: (context) => const ClassModel(),
  RouteNames.teacherAttendance: (context) => const AttendancePage(),
  RouteNames.teacherCalendar: (context) => const CalendarPage(),
  RouteNames.teacherSettings: (context) => const LoginPage(),
  RouteNames.teacherClasses: (context) => ClassPage(),
  RouteNames.comunicadosProfessor: (context) => const ComunicadosProfessor(),
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
