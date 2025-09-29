import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restoguh_dicoding_fundamentl/providers/menu_provider.dart';
import 'package:restoguh_dicoding_fundamentl/screens/favoirte_screen.dart';
import 'package:restoguh_dicoding_fundamentl/screens/home_screen.dart';
import 'package:restoguh_dicoding_fundamentl/screens/settings/setting_screen.dart';

class MenuScreen extends StatelessWidget {
  final List<Widget>? screens;
  const MenuScreen({super.key, this.screens});

  @override
  Widget build(BuildContext context) {
    final menuProvider = context.watch<MenuProvider>();

    final List<Widget> pages =
        screens ?? const [HomeScreen(), FavoriteScreen(), SettingScreen()];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(index: menuProvider.currentIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: menuProvider.currentIndex,
        onTap: menuProvider.setIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
