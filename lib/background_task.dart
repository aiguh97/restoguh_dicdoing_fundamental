import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'services/api_service.dart';
import 'models/restaurant.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();

    // Init plugin notifikasi
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await flutterLocalNotificationsPlugin.initialize(initSettings);

    // Init timezone
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    // Pakai ApiService instance, bukan static
    final apiService = ApiService();

    try {
      final restaurants = await apiService.fetchRestaurants();
      if (restaurants.isNotEmpty) {
        final random = Random().nextInt(restaurants.length);
        final resto = restaurants[random];

        const androidDetails = AndroidNotificationDetails(
          'daily_resto',
          'Daily Restaurant Reminder',
          channelDescription: 'Rekomendasi restoran setiap hari',
          importance: Importance.max,
          priority: Priority.high,
        );

        const iosDetails = DarwinNotificationDetails();

        const notificationDetails = NotificationDetails(
          android: androidDetails,
          iOS: iosDetails,
        );

        await flutterLocalNotificationsPlugin.show(
          0,
          "🍽️ Rekomendasi Restoran Hari Ini",
          "${resto.name} • ${resto.city}",
          notificationDetails,
        );
      }
    } catch (e) {
      await flutterLocalNotificationsPlugin.show(
        0,
        "⚠️ Gagal memuat data",
        "Tidak bisa mengambil data restoran",
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_resto',
            'Daily Restaurant Reminder',
            channelDescription: 'Notifikasi gagal load data',
            importance: Importance.defaultImportance,
          ),
        ),
      );
    }

    return Future.value(true);
  });
}
