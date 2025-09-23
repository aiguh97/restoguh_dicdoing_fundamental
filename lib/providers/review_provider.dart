import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../models/restaurant_detail.dart';

class ReviewProvider extends ChangeNotifier {
  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  RestaurantDetail? _restaurantDetail;
  RestaurantDetail? get restaurantDetail => _restaurantDetail;

  Future<void> submitReview(
    String restaurantId,
    String name,
    String review,
  ) async {
    _isSubmitting = true;
    notifyListeners();

    try {
      final success = await ApiService.postReview(restaurantId, name, review);
      if (success) {
        await refreshRestaurantDetail(restaurantId);
      }
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> refreshRestaurantDetail(String restaurantId) async {
    _restaurantDetail = await ApiService.fetchRestaurantDetail(restaurantId);
    notifyListeners();
  }
}
