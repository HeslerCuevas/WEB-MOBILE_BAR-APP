import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NotificationService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _orderUpdatesKey = 'notification_order_updates';
  static const String _specialEventsKey = 'notification_special_events';
  static const String _accountSecurityKey = 'notification_account_security';

  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {},
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'order_updates',
      'Detalles de su orden',
      description: 'Notificaciones sobre sus pagos y órdenes',
      importance: Importance.max,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  static Future<bool> areOrderUpdatesEnabled() async {
    return (await _storage.read(key: _orderUpdatesKey)) != 'false';
  }

  static Future<void> setOrderUpdatesEnabled(bool enabled) {
    return _storage.write(key: _orderUpdatesKey, value: enabled.toString());
  }

  static Future<bool> areSpecialEventsEnabled() async {
    return (await _storage.read(key: _specialEventsKey)) != 'false';
  }

  static Future<void> setSpecialEventsEnabled(bool enabled) {
    return _storage.write(key: _specialEventsKey, value: enabled.toString());
  }

  static Future<bool> isAccountSecurityEnabled() async {
    return (await _storage.read(key: _accountSecurityKey)) != 'false';
  }

  static Future<void> setAccountSecurityEnabled(bool enabled) {
    return _storage.write(key: _accountSecurityKey, value: enabled.toString());
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    bool force = false,
  }) async {
    if (!force && !await areOrderUpdatesEnabled()) {
      return;
    }

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

  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    if (message.data['action'] == 'ORDER_PAID') {
      final uuid = message.data['factura_uuid'];

      if (uuid != null) {
        await showNotification(
          id: uuid.hashCode,
          title: '¡Pago Confirmado!',
          body: 'Tu cuenta ha sido pagada. ¡Gracias por visitarnos!',
        );
      }
    }
  }
}
