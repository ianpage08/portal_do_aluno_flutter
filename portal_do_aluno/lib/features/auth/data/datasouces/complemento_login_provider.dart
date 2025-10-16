import 'package:portal_do_aluno/admin/data/models/usuario_provider.dart';
import 'package:portal_do_aluno/features/auth/data/datasouces/auth_service_datasource.dart';
import 'package:portal_do_aluno/navigation/navigation_sevice.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';

class AuthController {
  final AuthServico _authServico = AuthServico();
  final UsuarioProvider _usuarioProvider = UsuarioProvider();

  /// Faz login com CPF e senha sem precisar de BuildContext
  Future<void> loginComCpf(String cpf, String senha) async {
    try {
      final usuario = await _authServico.loginCpfsenha(cpf, senha);

      // Salva globalmente o usuário logado
      _usuarioProvider.setUsuario(usuario);

      // Navega para o dashboard
      await NavigatorService.navigateTo(RouteNames.adminDashboard);
    } catch (e) {
      // Como não há BuildContext, usamos o NavigationService para mostrar erros globais
      NavigatorService.showSnackBar(
        'Erro ao fazer login: ${e.toString().replaceAll("Exception:", "").trim()}',
      );
    }
  }
}
