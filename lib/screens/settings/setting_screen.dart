import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restoguh_dicoding_fundamentl/providers/local_notification_provider.dart';
import 'package:restoguh_dicoding_fundamentl/providers/theme_provider.dart';
import 'package:restoguh_dicoding_fundamentl/services/workmanager_service.dart';
import 'package:restoguh_dicoding_fundamentl/style/typography/typography_text_styles.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _isDailyReminderOn = false; // ✅ state switch

  @override
  Widget build(BuildContext context) {
    void _runDailyTaskAt11AM() async {
      await context.read<WorkmanagerService>().runDailyTaskAt11AM();
    }

    void _cancelDailyTaskAt11AM() async {
      await context.read<WorkmanagerService>().cancelDailyTaskAt11AM();
    }

    void _runOneOffTask() async {
      await context.read<WorkmanagerService>().runOneOffTask();
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

                    // Schedule 11:00 AM Notification
                    Row(
                      children: [
                        const Icon(
                          Icons.notifications_active,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Daily Reminder 11:00 AM",
                                style: RestoguhTextStyles.titleMedium,
                              ),
                              Text(
                                "Pengingat Notifikasi Restaurant",
                                style: RestoguhTextStyles.bodyLargeMedium
                                    .copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Consumer<LocalNotificationProvider>(
                          builder: (context, notificationProvider, _) => Switch(
                            value: notificationProvider.isDailyReminderOn,
                            onChanged: (value) async {
                              notificationProvider.setDailyReminder(value);

                              if (value) {
                                await notificationProvider.workmanagerService
                                    .runDailyTaskAt11AM();
                              } else {
                                await notificationProvider.workmanagerService
                                    .cancelDailyTaskAt11AM();
                              }
                            },
                          ),
                        ),
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
                          onPressed: () {
                            _runOneOffTask();
                          },
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
