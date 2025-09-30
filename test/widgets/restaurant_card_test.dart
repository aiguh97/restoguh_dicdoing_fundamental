import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:restoguh_dicoding_fundamentl/models/restaurant.dart';
import 'package:restoguh_dicoding_fundamentl/providers/favorite_provider.dart';
import 'package:restoguh_dicoding_fundamentl/widgets/restaurant_card.dart';

// Fake provider pakai synchronous isFavorite
class FakeFavoriteProvider extends FavoriteProvider {
  bool fav = false;

  @override
  bool isFavorite(String id) => fav;

  @override
  Future<void> addFavorite(Restaurant restaurant) async {
    fav = true;
    notifyListeners();
  }

  @override
  Future<void> removeFavorite(String id) async {
    fav = false;
    notifyListeners();
  }

  @override
  List<Restaurant> get favorites => [];
}

void main() {
  testWidgets('RestaurantCard menampilkan info resto dan toggle favorite', (
    tester,
  ) async {
    final restaurant = Restaurant(
      id: "1",
      name: "Test Resto",
      city: "Bandung",
      description: "desc",
      pictureId: "pic",
      rating: 4.2,
    );

    final provider = FakeFavoriteProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider<FavoriteProvider>.value(
        value: provider,
        child: MaterialApp(
          home: Scaffold(
            body: RestaurantCard(restaurant: restaurant, onTap: () {}),
          ),
        ),
      ),
    );

    // Tunggu build pertama selesai
    await tester.pump();

    // ✅ Nama resto & kota muncul
    expect(find.text("Test Resto"), findsOneWidget);
    expect(find.text("Bandung"), findsOneWidget);

    // ✅ Awalnya favorite_border
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);

    // ✅ Tap tombol favorite
    await tester.tap(find.byType(IconButton));
    await tester.pump();

    // ✅ Setelah di-tap jadi favorite
    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });
}
