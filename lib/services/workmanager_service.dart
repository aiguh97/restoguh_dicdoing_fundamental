import 'dart:math';

import 'package:restoguh_dicoding_fundamentl/services/api_service.dart';
import 'package:restoguh_dicoding_fundamentl/services/local_notification_service.dart';
import 'package:restoguh_dicoding_fundamentl/static/my_workmanager.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      final notificationService = LocalNotificationService();
      await notificationService.init();

      final apiService = ApiService(); // ✅ bikin instance

      if (task == MyWorkmanager.oneOff.taskName ||
          task == MyWorkmanager.oneOff.uniqueName) {
        print("One-off task inputData: $inputData");

        await notificationService.showNotification(
          id: 1,
          title: "One-off Task",
          body: inputData?['data'] ?? "One-off task executed!",
        );
      } else if (task == MyWorkmanager.periodic.taskName ||
          task == 'dailyTask') {
        final randomNumber =
            Random().nextInt(20) + 1; // ✅ lebih aman range kecil
        final result = await apiService.fetchRestaurantDetail("$randomNumber");
        print("Periodic task result: $result");

        await notificationService.showNotification(
          id: 2,
          title: "Daily Restaurant Reminder",
          body: "Coba lihat resto rekomendasi: ${result.name}",
        );
      }

      return Future.value(true);
    } catch (e, stack) {
      print("Error in Workmanager task '$task': $e\n$stack");
      return Future.value(false);
    }
  });
}

class WorkmanagerService {
  final Workmanager _workmanager;

  WorkmanagerService([Workmanager? workmanager])
      : _workmanager = workmanager ?? Workmanager();

  Future<void> init() async {
    await _workmanager.initialize(callbackDispatcher, isInDebugMode: true);
  }

  // Jalankan task satu kali
  Future<void> runOneOffTask() async {
    await _workmanager.registerOneOffTask(
      MyWorkmanager.oneOff.uniqueName,
      MyWorkmanager.oneOff.taskName,
      constraints: Constraints(networkType: NetworkType.connected),
      initialDelay: const Duration(seconds: 5),
      inputData: {
        "data": "This is a valid payload from oneoff task workmanager",
      },
    );
  }

  // Jalankan task periodic setiap 16 menit
  Future<void> runPeriodicTask() async {
    await _workmanager.registerPeriodicTask(
      MyWorkmanager.periodic.uniqueName,
      MyWorkmanager.periodic.taskName,
      frequency: const Duration(minutes: 16),
      initialDelay: Duration.zero,
      inputData: {
        "data": "This is a valid payload from periodic task workmanager",
      },
    );
  }

  // Jalankan task setiap hari pukul 11:00 AM
  Future<void> runDailyTaskAt11AM() async {
    final now = DateTime.now();
    DateTime next11AM = DateTime(
      now.year,
      now.month,
      now.day,
      11, // jam 11
      0, // menit 0
    );

    if (now.isAfter(next11AM)) {
      // kalau sudah lewat jam 11 hari ini, jadwalkan untuk besok
      next11AM = next11AM.add(const Duration(days: 1));
    }

    final initialDelay = next11AM.difference(now);

    await _workmanager.registerOneOffTask(
      'dailyTaskAt11AM',
      'dailyTask',
      constraints: Constraints(networkType: NetworkType.connected),
      initialDelay: initialDelay,
      inputData: {"data": "Payload for daily 11AM task"},
    );

    print("Daily task scheduled in $initialDelay");
  }

  Future<void> cancelAllTask() async {
    await _workmanager.cancelAll();
  }
}
