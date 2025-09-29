import 'package:flutter_test/flutter_test.dart';
import 'package:restoguh_dicoding_fundamentl/providers/onboarding_provider.dart';

void main() {
  group('OnboardingProvider Unit Tests', () {
    late OnboardingProvider provider;

    setUp(() {
      provider = OnboardingProvider();
    });

    test('default page is 0', () {
      expect(provider.currentPage, 0);
    });

    test('setPage updates currentPage', () {
      provider.setPage(1);
      expect(provider.currentPage, 1);
    });

    test('setPage same value does not notify listeners', () {
      int callCount = 0;
      provider.addListener(() => callCount++);
      provider.setPage(0); // same as default
      expect(callCount, 0);
    });
  });
}
