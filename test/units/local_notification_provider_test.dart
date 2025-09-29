import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:restoguh_dicoding_fundamentl/providers/local_notification_provider.dart';
import 'package:restoguh_dicoding_fundamentl/services/local_notification_service.dart';

class MockLocalNotificationService extends Mock
    implements LocalNotificationService {}

void main() {
  late LocalNotificationProvider provider;
  late MockLocalNotificationService mockService;

  setUp(() {
    mockService = MockLocalNotificationService();
    provider = LocalNotificationProvider(mockService);
  });

  test('requestPermissions updates permission', () async {
    when(() => mockService.requestPermissions()).thenAnswer((_) async => true);
    await provider.requestPermissions();
    expect(provider.permission, true);
  });

  test('showNotification calls service', () {
    when(
      () => mockService.showNotification(
        id: any(named: 'id'),
        title: any(named: 'title'),
        body: any(named: 'body'),
        payload: any(named: 'payload'),
      ),
    ).thenAnswer((_) async {});

    provider.showNotification();
    verify(
      () => mockService.showNotification(
        id: 1,
        title: any(named: 'title'),
        body: any(named: 'body'),
        payload: any(named: 'payload'),
      ),
    ).called(1);
  });
}
