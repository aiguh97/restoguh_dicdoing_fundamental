import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restoguh_dicoding_fundamentl/services/local_notification_service.dart';

class LocalNotificationProvider extends ChangeNotifier {
  final LocalNotificationService flutterNotificationService;

  LocalNotificationProvider(this.flutterNotificationService);

  int _notificationId = 0;
  bool? _permission = false;
  bool? get permission => _permission;

  List<PendingNotificationRequest> pendingNotificationRequests = [];

  // ✅ METHOD BARU: Schedule notifikasi jam 1:30 AM
  // void scheduleDailyOneThirtyAMNotification() {
  //   _notificationId += 1;
  //   flutterNotificationService.scheduleDailyOneThirtyAMNotification(
  //     id: _notificationId,
  //   );
  //   notifyListeners();
  // }

  // METHOD LAMA: Tetap pertahankan
  void scheduleDailyTenAMNotification() {
    _notificationId += 1;
    flutterNotificationService.scheduleDailyTenAMNotification(
      id: _notificationId,
    );
    notifyListeners();
  }

  void scheduleCurrentNotif() {
    _notificationId += 1;
    flutterNotificationService.scheduleTwoSecondNotification(
      id: _notificationId,
    );
    notifyListeners();
  }

  Future<void> checkPendingNotificationRequests(BuildContext context) async {
    pendingNotificationRequests = await flutterNotificationService
        .pendingNotificationRequests();
    notifyListeners();
  }

  Future<void> cancelNotification(int id) async {
    await flutterNotificationService.cancelNotification(id);
  }

  Future<void> requestPermissions() async {
    _permission = await flutterNotificationService.requestPermissions();
    notifyListeners();
  }

  void showNotification() {
    _notificationId += 1;
    flutterNotificationService.showNotification(
      id: _notificationId,
      title: "New Notification",
      body: "This is a new notification with id $_notificationId",
      payload: "This is a payload from notification with id $_notificationId",
    );
  }

  // ✅ METHOD BARU: Untuk testing notifikasi 1:30 AM
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
