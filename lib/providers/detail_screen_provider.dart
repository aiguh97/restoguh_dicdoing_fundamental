import 'package:flutter/material.dart';

class DetailScreenProvider extends ChangeNotifier {
  bool _showAppbarTitle = false;
  bool get showAppbarTitle => _showAppbarTitle;

  void updateAppbarTitle(bool value) {
    if (_showAppbarTitle != value) {
      _showAppbarTitle = value;
      notifyListeners();
    }
  }
}
