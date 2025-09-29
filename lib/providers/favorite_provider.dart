import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/restaurant.dart';

class FavoriteProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Restaurant> _favorites = [];

  List<Restaurant> get favorites => _favorites;

  Future<void> loadFavorites() async {
    _favorites = await _dbHelper.getFavorites();
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

  Future<bool> isFavorite(String id) async {
    return await _dbHelper.isFavorite(id);
  }
}
