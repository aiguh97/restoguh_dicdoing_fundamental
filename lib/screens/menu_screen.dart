import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restoguh_dicoding_fundamentl/providers/theme_provider.dart';
import 'package:restoguh_dicoding_fundamentl/providers/menu_provider.dart';
import 'package:restoguh_dicoding_fundamentl/screens/favoirte_screen.dart';
import 'package:restoguh_dicoding_fundamentl/screens/home_screen.dart';
import 'package:restoguh_dicoding_fundamentl/screens/settings/setting_screen.dart';
import 'package:restoguh_dicoding_fundamentl/style/typography/typography_text_styles.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  final List<Widget> _screens = const [
    HomeScreen(),
    FavoriteScreen(),
    SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(index: menuProvider.currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: menuProvider.currentIndex,
        onTap: (index) => menuProvider.setIndex(index),
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: RestoguhTextStyles.bodyLargeBold.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
        unselectedLabelStyle: RestoguhTextStyles.bodyLargeRegular.copyWith(
          color: Colors.grey,
        ),
        showUnselectedLabels: true,
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => themeProvider.toggleTheme(!themeProvider.isDarkMode),
      //   backgroundColor: Theme.of(context).colorScheme.primary,
      //   child: Icon(
      //     themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
      //     color: Theme.of(context).colorScheme.onPrimary,
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
