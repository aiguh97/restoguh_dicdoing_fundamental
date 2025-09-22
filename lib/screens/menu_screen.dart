import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restoguh_dicoding_fundamentl/providers/theme_provider.dart';
import 'package:restoguh_dicoding_fundamentl/screens/home_screen.dart';
import 'package:restoguh_dicoding_fundamentl/screens/settings/setting_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [const HomeScreen(), const SettingScreen()];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // tetap fixed
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Theme.of(context).colorScheme.primary, // warna aktif
        unselectedItemColor: Colors.grey, // warna tidak aktif
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          themeProvider.toggleTheme(!themeProvider.isDarkMode);
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
