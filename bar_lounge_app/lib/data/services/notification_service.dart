import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS configuration
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
      },
    );

    // Creates the channel for Android (required for foreground/background alerts)
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'order_updates', // id
      'Detalles de su orden', // title
      description: 'Notificaciones sobre sus pagos y órdenes', // description
      importance: Importance.max,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'order_updates',
      'Detalles de su orden',
      channelDescription: 'Notificaciones sobre sus pagos y órdenes',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  // Called to process FCM data in background
  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    if (message.data['action'] == 'ORDER_PAID') {
      final uuid = message.data['factura_uuid'];
      if (uuid != null) {
        // Show visual local notification since data-only messages won't do it
        await showNotification(
          id: uuid.hashCode,
          title: '¡Pago Confirmado!',
          body: 'Tu cuenta ha sido pagada. ¡Gracias por visitarnos!',
        );
      }
    }
  }
}
