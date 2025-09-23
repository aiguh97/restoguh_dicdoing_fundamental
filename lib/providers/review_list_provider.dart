import 'package:flutter/material.dart';

class ReviewListProvider extends ChangeNotifier {
  int _itemsToShow = 2;

  int get itemsToShow => _itemsToShow;

  void reset() {
    _itemsToShow = 2;
    notifyListeners();
  }

  void loadMore(int totalItems) {
    if (_itemsToShow < totalItems) {
      _itemsToShow += 2;
      if (_itemsToShow > totalItems) {
        _itemsToShow = totalItems;
      }
      notifyListeners();
    }
  }
}
