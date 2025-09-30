import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:restoguh_dicoding_fundamentl/providers/detail_screen_provider.dart';
import 'package:restoguh_dicoding_fundamentl/providers/local_notification_provider.dart';
import 'package:restoguh_dicoding_fundamentl/providers/theme_provider.dart';
import 'package:restoguh_dicoding_fundamentl/services/api_service.dart';
import 'package:restoguh_dicoding_fundamentl/services/local_notification_service.dart';
import 'package:intl/date_symbol_data_local.dart';
// import 'package:restoguh_dicoding_fundamentl/providers/detail_screen_provider.dart';
import 'package:restoguh_dicoding_fundamentl/providers/favorite_provider.dart';
import 'package:restoguh_dicoding_fundamentl/providers/home_provider.dart';
import 'package:restoguh_dicoding_fundamentl/providers/menu_provider.dart';
import 'package:restoguh_dicoding_fundamentl/providers/onboarding_provider.dart';
import 'package:restoguh_dicoding_fundamentl/providers/read_more_provider.dart';
import 'package:restoguh_dicoding_fundamentl/providers/review_list_provider.dart';
import 'package:restoguh_dicoding_fundamentl/screens/onboarding_screen.dart';
import 'package:restoguh_dicoding_fundamentl/screens/menu_screen.dart';
import 'package:restoguh_dicoding_fundamentl/services/workmanager_service.dart';
import 'package:restoguh_dicoding_fundamentl/style/theme/restoguh_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:http/http.dart' as http;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // TODO: panggil service notifikasi atau API di sini
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // ✅ Request permission iOS
  final iosPlugin =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
  await iosPlugin?.requestPermissions(alert: true, badge: true, sound: true);

  // Ambil SharedPreferences untuk cek onboarding
  final prefs = await SharedPreferences.getInstance();
  final seenOnboarding = prefs.getBool("seenOnboarding") ?? false;

  // Inisialisasi locale untuk date formatting
  await initializeDateFormatting('id_ID', null);

  // Init Workmanager
  final notificationService = LocalNotificationService();
  await notificationService.init();

  await WorkmanagerService().init();
  runApp(
    MultiProvider(
      providers: [
        // ApiService harus paling atas dulu
        Provider<ApiService>(create: (_) => ApiService()),
        Provider(create: (context) => WorkmanagerService()..init()),
        // LocalNotificationService butuh ApiService
        Provider<LocalNotificationService>(
          create: (context) =>
              LocalNotificationService(context.read<ApiService>())
                ..init()
                ..configureLocalTimeZone(),
        ),

        // LocalNotificationProvider butuh LocalNotificationService
        ChangeNotifierProvider(
          create: (context) => LocalNotificationProvider(
            context.read<LocalNotificationService>(),
          )..requestPermissions(), // pastikan method ini ada
        ),

        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(create: (_) => ReadMoreProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => ReviewListProvider()),
        ChangeNotifierProvider(
          create: (_) => DetailScreenProvider(
            apiService: ApiService(client: http.Client()),
          ),
        ),

        // ChangeNotifierProvider(create: (_) => ReviewProvider()),
        ChangeNotifierProvider(create: (_) => MenuProvider()),
      ],
      child: MyApp(seenOnboarding: seenOnboarding),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool seenOnboarding;

  const MyApp({super.key, required this.seenOnboarding});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Restaurant App',
          debugShowCheckedModeBanner: false,
          theme: RestoguhTheme.lightTheme,
          darkTheme: RestoguhTheme.darkTheme,
          themeMode:
              themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          initialRoute: seenOnboarding ? "/home" : "/",
          routes: {
            "/": (context) => OnboardingScreen(),
            "/home": (context) => const MenuScreen(),
          },
        );
      },
    );
  }
}
