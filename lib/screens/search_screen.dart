import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/restaurant.dart';
import '../widgets/restaurant_card.dart';
import 'details/detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _ctl = TextEditingController();
  Future<List<Restaurant>>? _future;
  String? _error;

  void _doSearch(String q) {
    if (q.trim().isEmpty) return;
    setState(() {
      _error = null;
      _future = ApiService.searchRestaurants(q.trim());
    });
  }

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cari Restoran')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _ctl,
              onSubmitted: _doSearch,
              decoration: InputDecoration(
                hintText: 'Masukkan kata kunci (contoh: cafe)',
                suffixIcon: IconButton(
                  onPressed: () => _doSearch(_ctl.text),
                  icon: const Icon(Icons.search),
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _future == null
                  ? Center(child: Text('Masukkan kata kunci untuk mencari'))
                  : FutureBuilder<List<Restaurant>>(
                      future: _future,
                      builder: (context, snap) {
                        if (snap.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snap.hasError) {
                          return Center(child: Text('Error: ${snap.error}'));
                        } else if (!snap.hasData || snap.data!.isEmpty) {
                          return const Center(
                            child: Text('Hasil tidak ditemukan'),
                          );
                        } else {
                          final data = snap.data!;
                          return ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, idx) {
                              final r = data[idx];
                              return RestaurantCard(
                                restaurant: r,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DetailScreen(id: r.id),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
