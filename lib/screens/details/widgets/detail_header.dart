import 'package:flutter/material.dart';
import 'package:restoguh_dicoding_fundamentl/widgets/text/ReadMoreInline.dart';
import '../../../models/restaurant_detail.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailHeader extends StatelessWidget {
  final RestaurantDetail r;
  final VoidCallback onShowReviews;

  const DetailHeader({super.key, required this.r, required this.onShowReviews});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Restaurant Name
        Text(
          r.name,
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        // Address Row
        Row(
          children: [
            SvgPicture.asset(
              "assets/svg/marker.svg",
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                colorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                r.address,
                style: textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Rating and Review Link
        Row(
          children: [
            Icon(
              Icons.star,
              size: 18,
              color: colorScheme.secondary, // bisa pakai secondary dari theme
            ),
            const SizedBox(width: 6),
            Text(r.rating.toString(), style: textTheme.bodyMedium),
            const SizedBox(width: 12),
            InkWell(
              onTap: onShowReviews,
              child: Text(
                'Lihat Review',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Description
        ReadMoreInline(
          text: r.description,
          trimLines: 4,
          style: textTheme.bodySmall?.copyWith(letterSpacing: 1.45),
          moreStyle: textTheme.bodySmall?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
