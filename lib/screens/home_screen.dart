import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restoguh_dicoding_fundamentl/providers/theme_provider.dart';
import 'package:restoguh_dicoding_fundamentl/screens/details/detail_screen.dart';
import 'package:restoguh_dicoding_fundamentl/screens/settings/setting_screen.dart';
import '../services/api_service.dart';
import '../models/restaurant.dart';
import '../widgets/restaurant_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Restaurant>> _future;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _future = ApiService.fetchRestaurants();
  }

  Future<void> _refresh() async {
    setState(() {
      if (_query.isEmpty) {
        _future = ApiService.fetchRestaurants();
      } else {
        _future = ApiService.searchRestaurants(_query);
      }
    });
    await _future;
  }

  void _onSearch(String query) {
    setState(() {
      _query = query.trim();
      if (_query.isEmpty) {
        _future = ApiService.fetchRestaurants();
      } else {
        _future = ApiService.searchRestaurants(_query);
      }
    });
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _searchController.clear();
      _query = '';
      _isSearching = false;
      _future = ApiService.fetchRestaurants();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Cari restoran...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    fontFamily: 'Geometr415',
                    color: Theme.of(context).hintColor,
                  ),
                ),
                style: TextStyle(
                  fontFamily: 'Geometr415',
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: _onSearch,
              )
            : const Text(
                'Restoguh',
                style: TextStyle(fontFamily: 'Geometr415'),
              ),
        actions: [
          // Theme toggle button
          _isSearching
              ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _stopSearch,
                )
              : IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _startSearch,
                ),
        ],
      ),
      // ✅ Drawer Menu yang diperbaiki
      drawer: _buildDrawer(context),
      body: FutureBuilder<List<Restaurant>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return _buildError(snapshot.error.toString());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmpty();
          } else {
            final data = snapshot.data!;
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: data.length,
                itemBuilder: (context, idx) {
                  final r = data[idx];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: RestaurantCard(
                      restaurant: r,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailScreen(id: r.id),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      child: Column(
        children: [
          // Header Drawer
          Container(
            width: double.infinity,
            height: 160,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
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
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Temukan restoran terbaik',
                  style: TextStyle(
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
                  onTap: () {
                    Navigator.pop(context);
                  },
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
                // Theme toggle di drawer
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
                    onChanged: (value) {
                      themeProvider.toggleTheme(value);
                      Navigator.pop(context); // Tutup drawer setelah toggle
                    },
                  ),
                  onTap: () {
                    themeProvider.toggleTheme(!themeProvider.isDarkMode);
                    Navigator.pop(context);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('Tentang Aplikasi'),
                  onTap: () {
                    _showAboutDialog(context);
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
        title: const Text('Tentang Restoguh'),
        content: const Text(
          'Aplikasi pencarian restoran berbasis Flutter. '
          'Menampilkan berbagai restoran terbaik di sekitar Anda.',
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

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Gagal memuat data',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _refresh, child: const Text('Coba Lagi')),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            _query.isEmpty
                ? 'Tidak ada restoran'
                : 'Hasil pencarian tidak ditemukan',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            _query.isEmpty
                ? 'Silakan refresh untuk memuat ulang data'
                : 'Coba kata kunci lain',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (_query.isNotEmpty) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _stopSearch,
              child: const Text('Tampilkan Semua'),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
