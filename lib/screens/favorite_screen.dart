import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restoguh_dicoding_fundamentl/screens/details/detail_screen.dart';
import '../providers/favorite_provider.dart';
import '../widgets/restaurant_card.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<FavoriteProvider>(context, listen: false).loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoriteProvider>(context);
    final favorites = provider.favorites;

    return Scaffold(
      appBar: AppBar(title: const Text("Favorite Restaurants")),
      body: favorites.isEmpty
          ? const Center(child: Text("Belum ada favorite"))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final restaurant = favorites[index];
                return RestaurantCard(
                  restaurant: restaurant,
                  index: index,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(
                          id: restaurant.id,
                          heroIndex: index,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
