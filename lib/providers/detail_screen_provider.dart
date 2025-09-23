import 'package:flutter/material.dart';
import 'package:restoguh_dicoding_fundamentl/services/api_service.dart';
import 'package:restoguh_dicoding_fundamentl/static/restoguh_detail_result_state%20.dart';
// import 'package:restoguh_dicoding_fundamentl/static/restoguh_detail_result_state.dart';

class DetailScreenProvider extends ChangeNotifier {
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

      final result = await ApiService.fetchRestaurantDetail(id);

      _resultState = RestoguhDetailLoadedState(result);
      notifyListeners();
    } catch (e) {
      _resultState = RestoguhDetailErrorState(e.toString());
      notifyListeners();
    }
  }
}
