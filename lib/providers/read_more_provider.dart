import 'package:flutter/material.dart';

class ReadMoreProvider with ChangeNotifier {
  bool _isExpanded = false;

  bool get isExpanded => _isExpanded;

  void toggle() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }

  void setExpanded(bool value) {
    _isExpanded = value;
    notifyListeners();
  }
}
