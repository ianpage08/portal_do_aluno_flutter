import 'package:flutter/material.dart';
import 'package:portal_do_aluno/navigation/navigation_sevice.dart';

import 'package:portal_do_aluno/navigation/route_names.dart';

import 'package:portal_do_aluno/shared/services/auth_storage_token.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    checkToken();

    // Animation Controller corrigido
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _scale = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _opacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    // Timer para navegação
  }

  Future<void> checkToken() async {
    await Future.delayed(const Duration(seconds: 2));

    final token = await AuthStorageService().getToken();
    final user = await AuthStorageService().getUser();

    if (!mounted) {
      return;
    }

    if (token != null && user != null && mounted) {
      NavigatorService.navigateToDashboard(user);
      debugPrint('Usuario já estava logado');
    } else {
      NavigatorService.navigateTo(RouteNames.login);
      debugPrint('Usuario não estava logado');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 190, 200, 255), Color(0xFF6C88F2)],
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
                  Image.asset('assets/logo.png', width: 300),
                  const SizedBox(height: 20),

                  // Nome do app
                  const SizedBox(height: 12),

                  // Loader opcional
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
