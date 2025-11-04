import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/notifications/notification_service_local.dart';
import 'package:portal_do_aluno/shared/widgets/app_bar.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationService _notificationService = NotificationService();

  void _menssagemLocal(String title, String body) async {
    await Future.delayed(const Duration(seconds: 5));

    _notificationService.showNotification(title: title, body: body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Notificações'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: ElevatedButton.icon(
            onPressed: () {
              _menssagemLocal('titulo', 'teste');
            },
            label: const Text('Mostrar Menssagem'),
            icon: const Icon(Icons.notifications),
          ),
        ),
      ),
    );
  }
}
