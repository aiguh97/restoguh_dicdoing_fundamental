// lib/providers/home_provider.dart
import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../services/api_service.dart';

class HomeProvider extends ChangeNotifier {
  List<Restaurant>? _restaurants;
  List<Restaurant>? _filteredRestaurants;
  List<Restaurant>? get restaurants => _filteredRestaurants ?? _restaurants;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  String _query = '';
  String get query => _query;

  // Cache untuk hasil pencarian
  final Map<String, List<Restaurant>> _searchCache = {};

  HomeProvider() {
    fetchRestaurants();
  }

  Future<void> fetchRestaurants() async {
    _isLoading = true;
    notifyListeners();

    try {
      _restaurants = await ApiService.fetchRestaurants();
      _filteredRestaurants = null; // Reset filtered results
    } catch (e) {
      _restaurants = [];
      debugPrint('Error fetching restaurants: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Pencarian realtime dengan debounce
  void searchRestaurantsRealtime(String query) {
    _query = query.trim();
    _isSearching = _query.isNotEmpty;

    if (_query.isEmpty) {
      // Jika query kosong, tampilkan semua restoran
      _filteredRestaurants = null;
      notifyListeners();
      return;
    }

    // Debounce: tunggu 500ms sebelum melakukan pencarian
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_query == query.trim()) {
        // Pastikan query belum berubah
        _performSearch();
      }
    });
  }

  Future<void> _performSearch() async {
    if (_query.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Cek cache dulu
      if (_searchCache.containsKey(_query)) {
        _filteredRestaurants = _searchCache[_query];
      } else {
        // Lakukan pencarian ke API
        final results = await ApiService.searchRestaurants(_query);
        _filteredRestaurants = results;

        // Simpan ke cache
        _searchCache[_query] = results;
      }
    } catch (e) {
      _filteredRestaurants = [];
      debugPrint('Error searching restaurants: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    // Clear cache saat refresh
    _searchCache.clear();

    if (_query.isEmpty) {
      await fetchRestaurants();
    } else {
      await _performSearch();
    }
  }

  void startSearch() {
    _isSearching = true;
    notifyListeners();
  }

  void stopSearch() {
    _isSearching = false;
    _query = '';
    _filteredRestaurants = null;
    notifyListeners();
  }

  // Method untuk mendapatkan data asli (tanpa filter)
  List<Restaurant>? get originalRestaurants => _restaurants;
}
