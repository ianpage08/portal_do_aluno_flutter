import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:portal_do_aluno/core/notifications/notification_chanel.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() => _notificationService;

  final FlutterLocalNotificationsPlugin _notificationServiceLocalPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);

    await _notificationServiceLocalPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint('Usuario Clicou na notificação: $details');
        // Handle notification tap here
      },
    );
    final androidImplementation = _notificationServiceLocalPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidImplementation?.requestNotificationsPermission();
  }

  Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const android = AndroidNotificationDetails(
      NotificationChanel.basicChannelId, // iddo canal
      NotificationChanel.basicChannelName, // nome do canal
      channelDescription:
          NotificationChanel.basicChannelDescription, // descrição do canal
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      icon: '@mipmap/ic_launcher',
    );
    const notificationDetails = NotificationDetails(android: android);
    await _notificationServiceLocalPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: 'teste',
    );
  }
}
