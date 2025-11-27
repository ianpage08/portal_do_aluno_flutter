import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/notifications/notification_service_local.dart';

class NotificationServiceRemote {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  


  Future<void> init() async {
    
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: false,
      sound: true,
    );
    
    debugPrint('permissão de notificação: ${settings.authorizationStatus}');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Mensagem recebida: ${message.notification?.title}');
      debugPrint('Mensagem recebida: ${message.notification?.body}');
      if (message.notification != null) {
        NotificationService().showNotification(
          title: message.notification!.title ?? 'Sem Titulo',
          body: message.notification!.body ?? 'Sem Conteudo',
        );
      }
    });
    

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Mensagem aberta: O app foi aberto');
    });
    
  }
}
