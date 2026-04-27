import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/services/notification_service.dart';
import 'core/utils/logger.dart';
import 'features/app/ui/app.dart';
import 'firebase_options.dart';

// Обработчик фоновых уведомлений — должен быть top-level функцией
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  AppLogger.info('Фоновое уведомление: ${message.notification?.title}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Загружаем .env
  try {
    await dotenv.load();
    AppLogger.info('main: .env загружен');
  } catch (_) {
    AppLogger.warning('main: .env файл не найден');
  }

  // Инициализируем Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Регистрируем обработчик фоновых уведомлений
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  AppLogger.info('main: Firebase инициализирован');

  runApp(const App());
}