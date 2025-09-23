import 'package:flutter/material.dart';
import 'package:restoguh_dicoding_fundamentl/style/colors/restoguh_colors.dart';
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
                Theme.of(context).primaryColor,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 6),
            Text(r.address, style: const TextStyle(fontFamily: 'Geometr415')),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.star,
              size: 18,
              color: RestoguhColors.amber.primaryColor, // pakai RestoguhColors
            ),
            const SizedBox(width: 6),
            Text(
              r.rating.toString(),
              style: const TextStyle(fontFamily: 'Geometr415'),
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
        ReadMoreInline(
          text: r.description,
          trimLines: 4,
          style: const TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            letterSpacing: 1.45,
            fontFamily: 'SFUIDisplay',
          ),
          moreStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
