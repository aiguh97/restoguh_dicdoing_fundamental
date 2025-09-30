import 'package:flutter/material.dart';
import 'package:restoguh_dicoding_fundamentl/models/restaurant_detail.dart';
import 'package:restoguh_dicoding_fundamentl/services/api_service.dart';
import 'package:restoguh_dicoding_fundamentl/static/restoguh_detail_result_state%20.dart';

// State result (pastikan kamu sudah punya class-class ini)
abstract class RestoguhDetailResultState {}

class RestoguhDetailNoneState extends RestoguhDetailResultState {}

class RestoguhDetailLoadingState extends RestoguhDetailResultState {}

class RestoguhDetailLoadedState extends RestoguhDetailResultState {
  final RestaurantDetail restaurantDetail;
  RestoguhDetailLoadedState(this.restaurantDetail);
}

class RestoguhDetailErrorState extends RestoguhDetailResultState {
  final String message;
  RestoguhDetailErrorState(this.message);
}

class DetailScreenProvider extends ChangeNotifier {
  final ApiService apiService;

  DetailScreenProvider({required this.apiService});

  bool _showAppbarTitle = false;
  bool get showAppbarTitle => _showAppbarTitle;

  RestoguhDetailResultState _resultState = RestoguhDetailNoneState();
  RestoguhDetailResultState get resultState => _resultState;

  void updateAppbarTitle(bool value) {
    if (_showAppbarTitle != value) {
      _showAppbarTitle = value;
      notifyListeners();
    }
  }

  Future<void> fetchRestaurantDetail(String id) async {
    try {
      _resultState = RestoguhDetailLoadingState();
      notifyListeners();

      final result = await apiService.fetchRestaurantDetail(id);
      _resultState = RestoguhDetailLoadedState(result);
    } catch (e) {
      _resultState = RestoguhDetailErrorState(e.toString());
    }
    notifyListeners();
  }
}
