import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restoguh_dicoding_fundamentl/models/restaurant.dart';
import 'package:restoguh_dicoding_fundamentl/screens/details/detail_screen.dart';
import 'package:restoguh_dicoding_fundamentl/screens/settings/setting_screen.dart';
import '../../providers/home_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/restaurant_card.dart';
import '../../style/typography/typography_text_styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  // ignore: unused_field
  late HomeProvider _homeProvider;

  @override
  void initState() {
    super.initState();
    _homeProvider = Provider.of<HomeProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<HomeProvider, ThemeProvider>(
      builder: (context, homeProvider, themeProvider, _) {
        return Scaffold(
          appBar: _buildAppBar(context, homeProvider),
          drawer: _buildDrawer(context, themeProvider, homeProvider),
          body: _buildBody(context, homeProvider),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, HomeProvider homeProvider) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: homeProvider.isSearching ? 72 : 54,
      title: homeProvider.isSearching
          ? TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Cari restoran...',
                border: InputBorder.none,
                hintStyle: RestoguhTextStyles.bodyLargeRegular.copyWith(
                  color: Colors.white,
                ),
              ),
              style: RestoguhTextStyles.bodyLargeRegular.copyWith(
                color: Colors.white,
              ),
              textInputAction: TextInputAction.search,
              onChanged: homeProvider.searchRestaurantsRealtime,
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  homeProvider.searchRestaurantsRealtime(value);
                }
              },
            )
          : Text('Restoguh', style: RestoguhTextStyles.displayLarge),
      actions: [
        IconButton(
          icon: Icon(homeProvider.isSearching ? Icons.close : Icons.search),
          onPressed: () {
            if (homeProvider.isSearching) {
              _searchController.clear();
              homeProvider.stopSearch();
            } else {
              homeProvider.startSearch();
              Future.delayed(const Duration(milliseconds: 100), () {
                FocusScope.of(context).requestFocus(FocusNode());
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, HomeProvider homeProvider) {
    return RefreshIndicator(
      onRefresh: () => homeProvider.refresh(),
      child: _buildContent(context, homeProvider),
    );
  }

  Widget _buildContent(BuildContext context, HomeProvider homeProvider) {
    if (homeProvider.isLoading && homeProvider.restaurants == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final data = homeProvider.restaurants;

    if (data == null || data.isEmpty) {
      return _buildEmptyState(context, homeProvider);
    }

    return _buildRestaurantList(context, data);
  }

  Widget _buildEmptyState(BuildContext context, HomeProvider homeProvider) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              homeProvider.query.isEmpty ? Icons.restaurant : Icons.search_off,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              homeProvider.query.isEmpty
                  ? 'Tidak ada restoran'
                  : 'Hasil pencarian tidak ditemukan',
              style: RestoguhTextStyles.titleLarge.copyWith(
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              homeProvider.query.isEmpty
                  ? 'Silakan refresh untuk memuat data'
                  : 'Coba dengan kata kunci lain',
              style: RestoguhTextStyles.bodyLargeRegular.copyWith(
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
            if (homeProvider.query.isNotEmpty) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _searchController.clear();
                  homeProvider.stopSearch();
                },
                child: const Text('Tampilkan Semua Restoran'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantList(BuildContext context, List<Restaurant> data) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final restaurant = data[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: RestaurantCard(
            restaurant: restaurant,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailScreen(id: restaurant.id),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildDrawer(
    BuildContext context,
    ThemeProvider themeProvider,
    HomeProvider homeProvider,
  ) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 160,
            color: Theme.of(context).colorScheme.primary,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.restaurant,
                    size: 40,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Restoguh',
                  style: RestoguhTextStyles.titleLarge.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Temukan restoran terbaik',
                  style: RestoguhTextStyles.bodyLargeRegular.copyWith(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Pengaturan'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    themeProvider.isDarkMode
                        ? Icons.light_mode
                        : Icons.dark_mode,
                  ),
                  title: Text(
                    themeProvider.isDarkMode ? 'Mode Terang' : 'Mode Gelap',
                  ),
                  trailing: Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: themeProvider.toggleTheme,
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('Tentang Aplikasi'),
                  onTap: () {
                    Navigator.pop(context);
                    _showAboutDialog(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.refresh),
                  title: const Text('Refresh Data'),
                  onTap: () {
                    Navigator.pop(context);
                    homeProvider.refresh();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Data berhasil di-refresh'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Tentang Restoguh',
          style: RestoguhTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const SingleChildScrollView(
          child: Text(
            'Restoguh adalah aplikasi pencarian restoran berbasis Flutter '
            'yang membantu Anda menemukan berbagai restoran terbaik di sekitar Anda. '
            'Aplikasi ini menampilkan informasi detail restoran, menu, dan ulasan pelanggan.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
