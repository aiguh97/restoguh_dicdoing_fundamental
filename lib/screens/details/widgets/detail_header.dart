import 'package:flutter/material.dart';
import 'package:restoguh_dicoding_fundamentl/screens/details/widgets/detail_add_review.dart';
import '../../../models/restaurant_detail.dart';

class DetailHeader extends StatelessWidget {
  final RestaurantDetail r;
  final VoidCallback onShowReviews;
  const DetailHeader({super.key, required this.r, required this.onShowReviews});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          r.name,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.place, size: 16),
            const SizedBox(width: 6),
            Text(r.address),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.star, size: 18, color: Colors.amber),
            const SizedBox(width: 6),
            Text(r.rating.toString()),
            const SizedBox(width: 6),
            InkWell(
              onTap: onShowReviews,
              child: Text(
                'Lihat Review',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),
        Text(r.description),
      ],
    );
  }
}
