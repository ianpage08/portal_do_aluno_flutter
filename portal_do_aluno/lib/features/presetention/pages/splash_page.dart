import 'package:flutter/material.dart';
import 'package:portal_do_aluno/navigation/navigation_sevice.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';
import 'package:portal_do_aluno/shared/helpers/single_execution_flag.dart';
import 'package:portal_do_aluno/shared/services/auth_storage_token.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  // Controla a animação da splash
  late final AnimationController _controller;

  // Animação de escala do logo
  late final Animation<double> _scale;

  // Animação de opacidade do logo
  late final Animation<double> _opacity;

  // Garante que a navegação ocorra apenas uma vez
  final SingleExecutionFlag _navigationFlag = SingleExecutionFlag();

  @override
  void initState() {
    super.initState();

    // Inicializa o controller da animação
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // Animação de leve zoom
    _scale = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    // Animação de fade in
    _opacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Inicia a animação
    _controller.forward();

    // Executa a validação após o primeiro frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkToken();
    });
  }

  // Verifica se o usuário já está autenticado
  Future<void> checkToken() async {
    // Tempo mínimo de exibição da splash
    await Future.delayed(const Duration(seconds: 2));

    // Evita executar se a tela foi descartada
    if (!mounted) return;

    // Executa a navegação apenas uma vez
    _navigationFlag.execute(() async {
      final token = await AuthStorageService().getToken();
      final user = await AuthStorageService().getUser();

      // Garante que a tela ainda existe
      if (!mounted) return;

      if (token != null && user != null) {
        // Usuário autenticado
        NavigatorService.navigateToDashboard(user);
        debugPrint('Usuário já estava logado');
      } else {
        // Usuário não autenticado
        NavigatorService.navigateTo(RouteNames.login);
        debugPrint('Usuário não estava logado');
      }
    });
  }

  @override
  void dispose() {
    // Libera o controller da animação
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Background em gradiente
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 190, 200, 255),
              Color(0xFF6C88F2),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _opacity,
            child: ScaleTransition(
              scale: _scale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo do app
                  Image.asset('assets/logo.png', width: 300),
                  const SizedBox(height: 20),

                  // Espaçamento visual
                  const SizedBox(height: 12),

                  // Indicador de carregamento
                  const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
