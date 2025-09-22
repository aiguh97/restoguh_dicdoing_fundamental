import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  "assets/svg/marker.svg",
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    Theme.of(
                      context,
                    ).primaryColor, // pakai primary color dari theme
                    BlendMode.srcIn,
                  ),
                ),

                const SizedBox(width: 4),
                Text(restaurant.city),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text(restaurant.rating.toString()),
              ],
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
