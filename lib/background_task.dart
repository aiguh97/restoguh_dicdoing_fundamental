import 'dart:math';
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
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    // Fetch restoran dari API
    try {
      final restaurants = await ApiService.fetchRestaurants();
      if (restaurants.isNotEmpty) {
        final random = Random().nextInt(restaurants.length);
        final Restaurant resto = restaurants[random];

        const androidDetails = AndroidNotificationDetails(
          'daily_resto',
          'Daily Restaurant Reminder',
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
          ),
        ),
      );
    }

    return Future.value(true);
  });
}
