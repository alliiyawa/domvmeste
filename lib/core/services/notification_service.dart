import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Сервис для работы с push уведомлениями.
/// 
/// Отвечает за:
/// 1. Инициализацию FCM и локальных уведомлений
/// 2. Получение и сохранение FCM токена
/// 3. Показ уведомлений когда приложение открыто
/// 4. Сохранение уведомлений в Firestore
class NotificationService {
  static final NotificationService instance = NotificationService._();
  NotificationService._();

  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  final _firestore = FirebaseFirestore.instance;

  // Канал уведомлений для Android
  static const _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'Важные уведомления',
    description: 'Уведомления от ДОМ ВМЕСТЕ',
    importance: Importance.high,
  );

  /// Инициализация сервиса — вызывается в main.dart
  Future<void> initialize(String userId) async {
    // 1. Запрашиваем разрешение
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 2. Создаём канал уведомлений Android
    await _localNotifications
        .resolvePlatformSpecificImplementation
            <AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    // 3. Инициализируем локальные уведомления
    await _localNotifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );

    // 4. Получаем и сохраняем FCM токен
    final token = await _messaging.getToken();
    if (token != null && userId.isNotEmpty) {
      await _saveToken(userId, token);
    }

    // 5. Слушаем уведомления когда приложение открыто
    FirebaseMessaging.onMessage.listen((message) {
      _showLocalNotification(message);
      _saveNotificationToFirestore(userId, message);
    });

    // 6. Обновляем токен если он изменился
    _messaging.onTokenRefresh.listen((newToken) {
      if (userId.isNotEmpty) {
        _saveToken(userId, newToken);
      }
    });
  }

  /// Сохраняем FCM токен пользователя в Firestore
  Future<void> _saveToken(String userId, String token) async {
    await _firestore.collection('users').doc(userId).update({
      'fcmToken': token,
    });
  }

  /// Показываем локальное уведомление когда приложение открыто
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }

  /// Сохраняем уведомление в Firestore для истории
  Future<void> _saveNotificationToFirestore(
    String userId,
    RemoteMessage message,
  ) async {
    if (userId.isEmpty) return;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .add({
      'title': message.notification?.title ?? '',
      'body': message.notification?.body ?? '',
      'category': message.data['category'] ?? '',
      'isRead': false,
      'isImportant': message.data['isImportant'] == 'true',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Получаем настройки уведомлений из SharedPreferences
  Future<Map<String, bool>> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'news': prefs.getBool('notif_news') ?? true,
      'announcements': prefs.getBool('notif_announcements') ?? true,
      'repair': prefs.getBool('notif_repair') ?? true,
      'lost': prefs.getBool('notif_lost') ?? true,
      'rules': prefs.getBool('notif_rules') ?? true,
    };
  }

  /// Сохраняем настройки уведомлений
  Future<void> saveSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_$key', value);
  }

  /// Отмечаем уведомление как прочитанное
  Future<void> markAsRead(String userId, String notificationId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .doc(notificationId)
        .update({'isRead': true});
  }

  /// Получаем стрим уведомлений пользователя
  Stream<QuerySnapshot> getNotificationsStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}