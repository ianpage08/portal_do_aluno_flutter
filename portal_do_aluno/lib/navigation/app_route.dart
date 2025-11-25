import 'package:flutter/material.dart';

import 'package:portal_do_aluno/admin/presentation/pages/admin_dashboard.dart';
import 'package:portal_do_aluno/core/notifications/pages/notification_page.dart';
import 'package:portal_do_aluno/features/presetention/pages/splash_page.dart';
import 'package:portal_do_aluno/student/presentation/pages/exercicios_aluno_page.dart';
import 'package:portal_do_aluno/teacher/presentation/pages/boletim_page.dart';
import 'package:portal_do_aluno/admin/presentation/pages/gestao_escolar/cadastrar_disciplina.dart';
import 'package:portal_do_aluno/admin/presentation/pages/gestao_escolar/cadastro_turma.dart';
import 'package:portal_do_aluno/teacher/presentation/pages/conteudo_dado.dart';
import 'package:portal_do_aluno/admin/presentation/pages/gestao_escolar/controle_de_calendario.dart';
import 'package:portal_do_aluno/admin/presentation/pages/gestao_escolar/detalhes_do_aluno_test.dart';
import 'package:portal_do_aluno/teacher/presentation/pages/cadastro_exercicio.dart';
import 'package:portal_do_aluno/teacher/presentation/pages/frequencia_alunos.dart';
import 'package:portal_do_aluno/admin/presentation/pages/navigation_bottom/configuracao_page.dart';

import 'package:portal_do_aluno/admin/presentation/pages/navigation_bottom/gesta_academica.dart';
import 'package:portal_do_aluno/admin/presentation/pages/gestao_de_comunicados_e_avisos.dart';
import 'package:portal_do_aluno/admin/presentation/pages/navigation_bottom/gestao_de_usuarios.dart';

import 'package:portal_do_aluno/admin/presentation/pages/lista_de_usuarios_page.dart';
import 'package:portal_do_aluno/admin/presentation/pages/matricula_cadastro.dart';
import 'package:portal_do_aluno/admin/presentation/pages/navigation_bottom/relatorios_e_documentos.dart';
import 'package:portal_do_aluno/admin/presentation/pages/relatorios.dart';
import 'package:portal_do_aluno/admin/presentation/pages/seguranca_e_permissoes.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';
import 'package:portal_do_aluno/features/presetention/pages/login_page.dart';

import 'package:portal_do_aluno/student/presentation/pages/calendar_page.dart';
import 'package:portal_do_aluno/student/presentation/pages/boletim_page_aluno.dart';

import 'package:portal_do_aluno/student/presentation/pages/aluno_comunicados_page.dart';
import 'package:portal_do_aluno/student/presentation/pages/student_dashboard.dart';

import 'package:portal_do_aluno/teacher/presentation/pages/turma_page.dart';
import 'package:portal_do_aluno/teacher/presentation/pages/professor_comunicados_page.dart';
import 'package:portal_do_aluno/teacher/presentation/pages/teacher_dashboard.dart';

Map<String, WidgetBuilder> get routes => {
  RouteNames.slashScreen: (context) => const SplashPage(),
  RouteNames.login: (context) => const LoginPage(),
  RouteNames.notification: (context) => const NotificationPage(),
  RouteNames.adminMatriculaCadastro: (context) => const MatriculaCadastro(),
  RouteNames.adminDashboard: (context) => const AdminDashboard(),

  RouteNames.adminGestao: (context) => const GestaoDeUsuarios(),
  RouteNames.adminGestaoEscolar: (context) => const GestaAcademica(),
  RouteNames.adminGeracaoDocumentos: (context) =>
      const RelatoriosDocumentosPage(),
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

  RouteNames.addOqueFoiDado: (context) => const OqueFoiDado(),

  // rotas do Aluno
  RouteNames.studentDashboard: (context) => const StudentDashboard(),

  RouteNames.studentHelp: (context) => const NoticesPage(),
  RouteNames.studentSettings: (context) => const ConfiguracaoPage(),

  RouteNames.studentCalendar: (context) => const CalendarPage(),

  RouteNames.studentComunicados: (context) => const NoticesPage(),
  RouteNames.studentBoletim: (context) => const BoletimPage(),
  RouteNames.studentExercicios: (context) => const ExerciciosAlunoPage(),
  // rotas de detalhes

  // rotas do Professor
  RouteNames.teacherDashboard: (context) => const TeacherDashboard(),

  RouteNames.teacherCalendar: (context) => const CalendarPage(),
  RouteNames.teacherClasses: (context) => ClassPage(),
  RouteNames.comunicadosProfessor: (context) => const ComunicadosProfessor(),
  RouteNames.teacherExercicios: (context) => const CadastroExercicio(),
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
