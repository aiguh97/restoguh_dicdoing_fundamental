import 'package:flutter/foundation.dart';
import '../db/database_helper.dart';
import '../models/restaurant.dart';

class FavoriteProvider with ChangeNotifier {
  DatabaseHelper _dbHelper = DatabaseHelper();
  List<Restaurant> _favorites = [];
  final Set<String> _favoriteIds = {};

  List<Restaurant> get favorites => _favorites;

  Future<void> loadFavorites() async {
    _favorites = await _dbHelper.getFavorites();
    _favoriteIds
      ..clear()
      ..addAll(_favorites.map((r) => r.id));
    notifyListeners();
  }

  Future<void> addFavorite(Restaurant restaurant) async {
    await _dbHelper.insertFavorite(restaurant);
    await loadFavorites();
  }

  Future<void> removeFavorite(String id) async {
    await _dbHelper.removeFavorite(id);
    await loadFavorites();
  }

  bool isFavorite(String id) => _favoriteIds.contains(id);

  /// 🔹 method khusus buat unit test, biar bisa mock DatabaseHelper
  @visibleForTesting
  void overrideDbHelper(DatabaseHelper helper) {
    _dbHelper = helper;
  }
}
