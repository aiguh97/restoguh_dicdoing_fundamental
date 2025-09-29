import 'package:flutter_test/flutter_test.dart';
import 'package:restoguh_dicoding_fundamentl/providers/menu_provider.dart';

void main() {
  group('MenuProvider Unit Tests', () {
    late MenuProvider menuProvider;

    setUp(() {
      menuProvider = MenuProvider();
    });

    test('default index is 0', () {
      expect(menuProvider.currentIndex, 0);
    });

    test('setIndex updates index', () {
      menuProvider.setIndex(1);
      expect(menuProvider.currentIndex, 1);
    });

    test('setIndex same value does not notify listeners', () {
      int callCount = 0;
      menuProvider.addListener(() => callCount++);
      menuProvider.setIndex(0); // same as default
      expect(callCount, 0);
    });

    test('setIndex different value calls notifyListeners', () {
      int callCount = 0;
      menuProvider.addListener(() => callCount++);
      menuProvider.setIndex(2);
      expect(callCount, 1);
    });
  });
}
