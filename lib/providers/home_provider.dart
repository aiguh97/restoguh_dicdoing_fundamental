// lib/providers/home_provider.dart
import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../services/api_service.dart';
import '../static/restoguh_list_result_state.dart';

class HomeProvider extends ChangeNotifier {
  final ApiService apiService;
  HomeProvider({ApiService? apiService})
      : apiService = apiService ?? ApiService();

  RestoguhListResultState _state = RestoguhListNoneState();
  RestoguhListResultState get state => _state;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  String _query = '';
  String get query => _query;

  final Map<String, List<Restaurant>> _searchCache = {};

  Future<void> fetchRestaurants() async {
    _state = RestoguhListLoadingState();
    notifyListeners();

    try {
      final restaurants = await apiService.fetchRestaurants();
      _state = RestoguhListLoadedState(restaurants);
    } catch (e) {
      _state = RestoguhListErrorState("Koneksi Terputus");
    }

    notifyListeners();
  }

  Future<void> searchRestaurantsRealtime(String query) async {
    _query = query.trim();
    if (_query.isEmpty) {
      return fetchRestaurants();
    }

    _state = RestoguhListLoadingState();
    notifyListeners();

    try {
      if (_searchCache.containsKey(_query)) {
        _state = RestoguhListLoadedState(_searchCache[_query]!, query: _query);
      } else {
        final results = await apiService.searchRestaurants(_query);
        _state = RestoguhListLoadedState(results, query: _query);
        _searchCache[_query] = results;
      }
    } catch (e) {
      _state = RestoguhListErrorState("Pencarian gagal: $e");
    }

    notifyListeners();
  }

  Future<void> refresh() async {
    _searchCache.clear();
    if (_query.isEmpty) {
      await fetchRestaurants();
    } else {
      await searchRestaurantsRealtime(_query);
    }
  }

  void startSearch() {
    _isSearching = true;
    notifyListeners();
  }

  void stopSearch() {
    _isSearching = false;
    _query = '';
    fetchRestaurants();
  }
}
