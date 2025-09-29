import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorite_provider.dart';
import '../widgets/restaurant_card.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final favorites = favoriteProvider.favorites;

    if (favorites.isEmpty) {
      return const Scaffold(body: Center(child: Text("Belum ada favorite")));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Favorite Restaurants")),
      body: ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final restaurant = favorites[index];
          return RestaurantCard(
            restaurant: restaurant,
            onTap: () {
              // bisa navigasi ke detail restaurant kalau ada
            },
          );
        },
      ),
    );
  }
}
