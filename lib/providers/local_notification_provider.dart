import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restoguh_dicoding_fundamentl/services/local_notification_service.dart';
import 'package:restoguh_dicoding_fundamentl/services/workmanager_service.dart';

class LocalNotificationProvider extends ChangeNotifier {
  final LocalNotificationService flutterNotificationService;
  final WorkmanagerService workmanagerService;

  LocalNotificationProvider({
    required this.flutterNotificationService,
    required this.workmanagerService,
  });

  int _notificationId = 0;
  bool? _permission = false;
  bool? get permission => _permission;

  /// Menyimpan daftar notifikasi yang masih pending
  List<PendingNotificationRequest> pendingNotificationRequests = [];

  /// STATE: Daily Reminder
  bool _isDailyReminderOn = false;
  bool get isDailyReminderOn => _isDailyReminderOn;

  void setDailyReminder(bool value) {
    _isDailyReminderOn = value;
    notifyListeners();

    // Jalankan atau cancel task di Workmanager
    if (value) {
      workmanagerService.runDailyTaskAt11AM();
    } else {
      workmanagerService.cancelDailyTaskAt11AM();
    }
  }

  /// Minta izin notifikasi
  Future<void> requestPermissions() async {
    _permission = await flutterNotificationService.requestPermissions();
    notifyListeners();
  }

  /// Notifikasi sederhana
  void showNotification() {
    _notificationId += 1;
    flutterNotificationService.showNotification(
      id: _notificationId,
      title: "New Notification",
      body: "This is a new notification with id $_notificationId",
      payload: "payload_notification_$_notificationId",
    );
  }

  /// Notifikasi dengan Big Picture
  void showBigPictureNotification() {
    _notificationId += 1;
    flutterNotificationService.showBigPictureNotification(
      id: _notificationId,
      title: "New Big Picture Notification",
      body: "This is a big picture notification with id $_notificationId",
      payload: "payload_big_picture_$_notificationId",
    );
  }

  /// Test One-off notification via Workmanager
  Future<void> runOneOffTask() async {
    await workmanagerService.runOneOffTask();
  }

  /// Jadwalkan notifikasi 2 detik dari sekarang (LocalNotificationService)
  void scheduleCurrentNotif() {
    _notificationId += 1;
    flutterNotificationService.scheduleTwoSecondNotification(
      id: _notificationId,
    );
    notifyListeners();
  }

  /// Cek daftar notifikasi yang masih pending
  Future<void> checkPendingNotificationRequests() async {
    pendingNotificationRequests =
        await flutterNotificationService.pendingNotificationRequests();
    notifyListeners();
  }

  /// Batalkan notifikasi tertentu
  Future<void> cancelNotification(int id) async {
    await flutterNotificationService.cancelNotification(id);
    notifyListeners();
  }

  /// Test notifikasi manual (contoh: simulasi jam 1:30 AM)
  void showTestCurrentNotif() {
    _notificationId += 1;
    flutterNotificationService.showNotification(
      id: _notificationId,
      title: "🕜 Test 1:30 AM Notification",
      body: "Ini adalah test notifikasi untuk jam 1:30 AM",
      payload: "test_1_30_am",
    );
  }
}
