import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:restoguh_dicoding_fundamentl/models/restaurant.dart';
import 'package:restoguh_dicoding_fundamentl/providers/favorite_provider.dart';
import 'package:restoguh_dicoding_fundamentl/db/database_helper.dart';

class MockDatabaseHelper extends Mock implements DatabaseHelper {}

void main() {
  late MockDatabaseHelper mockDb;
  late FavoriteProvider provider;

  final restaurant = Restaurant(
    id: "1",
    name: "Resto Test",
    city: "Jakarta",
    description: "Desc",
    pictureId: "pic1",
    rating: 4.5,
  );

  setUp(() {
    mockDb = MockDatabaseHelper();
    provider = FavoriteProvider()..overrideDbHelper(mockDb);
  });

  test('addFavorite harus panggil insertFavorite dan update list', () async {
    when(() => mockDb.insertFavorite(restaurant)).thenAnswer((_) async {});
    when(() => mockDb.getFavorites()).thenAnswer((_) async => [restaurant]);

    await provider.addFavorite(restaurant);

    expect(provider.favorites.length, 1);
    expect(provider.isFavorite("1"), true);
    verify(() => mockDb.insertFavorite(restaurant)).called(1);
  });

  test(
    'removeFavorite harus panggil removeFavorite dan kosongkan list',
    () async {
      when(() => mockDb.removeFavorite("1")).thenAnswer((_) async {});
      when(() => mockDb.getFavorites()).thenAnswer((_) async => []);

      await provider.removeFavorite("1");

      expect(provider.favorites.isEmpty, true);
      expect(provider.isFavorite("1"), false);
      verify(() => mockDb.removeFavorite("1")).called(1);
    },
  );

  test('isFavorite sinkron dari state lokal', () async {
    when(() => mockDb.insertFavorite(restaurant)).thenAnswer((_) async {});
    when(() => mockDb.getFavorites()).thenAnswer((_) async => [restaurant]);

    await provider.addFavorite(restaurant);

    expect(provider.isFavorite("1"), true);
    expect(provider.isFavorite("2"), false);
  });
}
