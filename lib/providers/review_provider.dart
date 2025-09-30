import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../models/restaurant_detail.dart';

class ReviewProvider extends ChangeNotifier {
  final ApiService apiService;

  ReviewProvider({required this.apiService});

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
      final success = await apiService.postReview(
          restaurantId, name, review); // ✅ pakai instance
      if (success) {
        await refreshRestaurantDetail(restaurantId);
      }
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<void> refreshRestaurantDetail(String restaurantId) async {
    _restaurantDetail = await apiService
        .fetchRestaurantDetail(restaurantId); // ✅ pakai instance
    notifyListeners();
  }
}
