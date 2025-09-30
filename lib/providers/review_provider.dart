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

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Submit review ke server
  Future<void> submitReview(
    String restaurantId,
    String name,
    String review,
  ) async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await apiService.postReview(
        id: restaurantId,
        name: name,
        review: review,
      );

      if (success) {
        await refreshRestaurantDetail(restaurantId);
      } else {
        _errorMessage = "Gagal mengirim ulasan";
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  /// Refresh detail restoran setelah kirim review
  Future<void> refreshRestaurantDetail(String restaurantId) async {
    try {
      _restaurantDetail = await apiService.fetchRestaurantDetail(restaurantId);
    } catch (e) {
      _errorMessage = e.toString();
    }
    notifyListeners();
  }
}
