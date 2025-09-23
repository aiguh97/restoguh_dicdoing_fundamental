import 'package:flutter/material.dart';
import 'package:restoguh_dicoding_fundamentl/theme/theme.dart';
import 'package:restoguh_dicoding_fundamentl/widgets/text/ReadMoreInline.dart';
import '../../../models/restaurant_detail.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
          style: const TextStyle(
            fontFamily: 'GillSansMT',
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
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
            const SizedBox(width: 6),
            Text(r.address, style: TextStyle(fontFamily: 'Geometr415')),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.star, size: 18, color: Colors.amber),
            const SizedBox(width: 6),
            Text(
              r.rating.toString(),
              style: TextStyle(fontFamily: 'Geometr415'),
            ),
            const SizedBox(width: 6),
            InkWell(
              onTap: onShowReviews,
              child: Text(
                'Lihat Review',
                style: TextStyle(
                  fontFamily: 'Geometr415',
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),
        // Text(r.description),
        ReadMoreInline(
          text: r.description ?? "",
          trimLines: 4,
          style: const TextStyle(
            color: Color.fromARGB(255, 61, 61, 61),
            letterSpacing: 1.45,
            fontFamily: 'SFUIDisplay',
          ),
          moreStyle: const TextStyle(
            color: Color.fromARGB(255, 66, 189, 74),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
