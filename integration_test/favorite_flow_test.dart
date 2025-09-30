import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:restoguh_dicoding_fundamentl/models/restaurant.dart';
import 'package:restoguh_dicoding_fundamentl/providers/favorite_provider.dart';
import 'package:restoguh_dicoding_fundamentl/widgets/restaurant_card.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Favorite Flow Integration Test', () {
    testWidgets('menambahkan dan menghapus favorite di UI', (
      WidgetTester tester,
    ) async {
      final restaurant = Restaurant(
        id: "10",
        name: "Integration Resto",
        city: "Surabaya",
        description: "desc",
        pictureId: "pic10",
        rating: 4.8,
      );

      // Gunakan ChangeNotifierProvider agar state dapat diakses
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => FavoriteProvider(),
          child: MaterialApp(
            home: Scaffold(
              body: RestaurantCard(
                restaurant: restaurant,
                onTap: () {},
                // Gunakan Hero tag yang unik agar tidak error di test
                index: 0,
              ),
            ),
          ),
        ),
      );

      // Tunggu build
      await tester.pumpAndSettle();

      // Awalnya favorite border
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);

      // Tap jadi favorite
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.favorite), findsOneWidget);

      // Tap lagi jadi unfavorite
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });
  });
}
