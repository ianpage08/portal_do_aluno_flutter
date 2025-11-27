import 'package:flutter/material.dart';
import 'package:portal_do_aluno/navigation/navigation_sevice.dart';
import 'package:portal_do_aluno/navigation/route_names.dart';

class PasswordChangedSuccessPage extends StatefulWidget {
  const PasswordChangedSuccessPage({super.key});

  @override
  State<PasswordChangedSuccessPage> createState() =>
      _PasswordChangedSuccessPageState();
}

class _PasswordChangedSuccessPageState
    extends State<PasswordChangedSuccessPage> {

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      NavigatorService.navigateAndRemoveUntil(RouteNames.adminListaDeUsuarios);
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícone de sucesso
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_circle,
                    size: 80, color: Colors.green.shade700),
              ),

              const SizedBox(height: 24),

              Text(
                'Senha atualizada com sucesso!',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              Text(
                'Você será redirecionado automaticamente...',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 40),

              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
