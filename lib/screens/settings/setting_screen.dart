import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:restoguh_dicoding_fundamentl/providers/local_notification_provider.dart';
import 'package:restoguh_dicoding_fundamentl/providers/theme_provider.dart';
import 'package:restoguh_dicoding_fundamentl/providers/reminder_provider.dart';
import 'package:restoguh_dicoding_fundamentl/services/local_notification_service.dart';
import 'package:restoguh_dicoding_fundamentl/style/typography/typography_text_styles.dart';

import 'package:workmanager/workmanager.dart';
// import 'background_task.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    Future<void> _requestPermission() async {
      await context.read<LocalNotificationProvider>().requestPermissions();
    }

    Future<void> _scheduleDailyRestaurantReminder() async {
      await Workmanager().registerPeriodicTask(
        "dailyRestoTask",
        "showDailyRestoNotification",
        frequency: const Duration(hours: 24),
        initialDelay: const Duration(
          seconds: 10,
        ), // testing: 10 detik setelah aktif
        constraints: Constraints(
          networkType: NetworkType.connected, // butuh internet untuk fetch API
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Daily Restaurant Reminder diaktifkan!'),
          duration: Duration(seconds: 2),
        ),
      );
    }

    Future<void> _testNotification() async {
      await _requestPermission(); // Request permission dulu
      context.read<LocalNotificationProvider>().scheduleCurrentNotif();

      // Tampilkan info di layar juga
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅  Notifikasi 2 detik dari sekarang"),
          duration: Duration(milliseconds: 450),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Pengaturan",
          style: RestoguhTextStyles.displayLarge.copyWith(fontSize: 20),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // === THEME SECTION ===
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "TAMPILAN",
                      style: RestoguhTextStyles.labelLarge.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.dark_mode),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            "Mode Gelap",
                            style: RestoguhTextStyles.titleMedium,
                          ),
                        ),
                        Switch(
                          value: themeProvider.isDarkMode,
                          onChanged: themeProvider.toggleTheme,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // === NOTIFICATION SECTION ===
          Consumer<LocalNotificationProvider>(
            builder: (context, notificationProvider, _) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "PENGINGAT OTOMATIS",
                      style: RestoguhTextStyles.labelLarge.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Schedule 1:30 AM Notification
                    Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.nightlight_round,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Daily Reminder 11:0 AM",
                                    style: RestoguhTextStyles.titleMedium,
                                  ),
                                  Text(
                                    "Pengingat Notifikasi Restaurant",
                                    // style: RestoguhTextStyles.bodySmall
                                    //     .copyWith(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _scheduleDailyRestaurantReminder,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text(
                                  'Aktifkan Pengingat 11:00 AM',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),

                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),

                    // Test Simple Notification
                    Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.notification_add),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                "Test Notification",
                                style: RestoguhTextStyles.titleMedium,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _testNotification,
                          child: const Text("Test Show Notification"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
