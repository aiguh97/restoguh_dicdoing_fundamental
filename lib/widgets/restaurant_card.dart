import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:restoguh_dicoding_fundamentl/providers/favorite_provider.dart';
import '../models/restaurant.dart';
import '../services/api_service.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback onTap;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final isFav = favoriteProvider.isFavorite(restaurant.id);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 9),
      child: ListTile(
        onTap: onTap,
        leading: Hero(
          tag: 'img-${restaurant.id}',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              ApiService.imageUrl(restaurant.pictureId),
              width: 96,
              height: 96,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 96,
                height: 96,
                color: Colors.grey[200],
                child: const Icon(Icons.photo),
              ),
            ),
          ),
        ),
        title: Text(
          restaurant.name,
          style: const TextStyle(
            fontFamily: 'Geometr415',
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/svg/marker.svg",
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      restaurant.city,
                      style: const TextStyle(fontFamily: 'GillSansMT'),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      restaurant.rating.toString(),
                      style: const TextStyle(fontFamily: 'GillSansMT'),
                    ),
                  ],
                ),
              ],
            ),
            IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.red : Colors.grey,
              ),
              onPressed: () => favoriteProvider.toggleFavorite(restaurant),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
