import 'package:flutter/material.dart';
import '../models/restaurant.dart';

class FavoriteProvider with ChangeNotifier {
  final List<Restaurant> _favorites = [];

  List<Restaurant> get favorites => _favorites;

  bool isFavorite(String id) {
    return _favorites.any((r) => r.id == id);
  }

  void toggleFavorite(Restaurant restaurant) {
    final index = _favorites.indexWhere((r) => r.id == restaurant.id);
    if (index >= 0) {
      _favorites.removeAt(index);
    } else {
      _favorites.add(restaurant);
    }
    notifyListeners();
  }
}
