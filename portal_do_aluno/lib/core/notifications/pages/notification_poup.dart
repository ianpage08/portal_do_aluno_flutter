import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/admin/data/firestore_services/comunicado_service.dart';
import 'package:portal_do_aluno/admin/presentation/providers/user_provider.dart';
import 'package:portal_do_aluno/navigation/navigation_sevice.dart';

import 'package:provider/provider.dart';

class NotificationPoup extends StatefulWidget {
  final String? userId;
  final VoidCallback? onPressed;
  final String? route;

  const NotificationPoup({super.key, required this.userId, this.onPressed, this.route});

  @override
  State<NotificationPoup> createState() => _NotificationPoupState();
}

class _NotificationPoupState extends State<NotificationPoup> {
  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserProvider>(context).userId;
    if (userId == null || userId.isEmpty) {
      return const Icon(CupertinoIcons.bell, size: 25);
    }

    return StreamBuilder<int>(
      stream: ComunicadoService().contadorDeVisualizacoesNaoVistasPorId(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        }

        // quantidade de not  ificações não visualizadas
        final total = snapshot.data ?? 5;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              onPressed:
                  () {
                    ComunicadoService().atualizarVisualizacao(userId);
                    if (widget.route != null) {
                      NavigatorService.navigateTo(widget.route!);
                    }
                    
                  },
              icon: const Icon(CupertinoIcons.bell, size: 25),
            ),
            Positioned(
              right: 8,
              top: 4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 54, 57, 244),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  total.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
