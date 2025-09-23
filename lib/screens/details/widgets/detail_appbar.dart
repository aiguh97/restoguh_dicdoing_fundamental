import 'package:flutter/material.dart';
import 'package:restoguh_dicoding_fundamentl/widgets/images/CircleSVGImage.dart';
import '../../../services/api_service.dart';
import '../../../models/restaurant_detail.dart';

class DetailAppbar extends StatelessWidget {
  final RestaurantDetail r;
  final bool showAppbarTitle;

  const DetailAppbar({
    super.key,
    required this.r,
    required this.showAppbarTitle,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Text(
        r.name,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),

      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'img-${r.id}',
              child: Image.network(
                ApiService.imageUrl(r.pictureId),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(color: Colors.grey[200]),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                    Colors.black.withOpacity(0.2),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
            // Top Row
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 11,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleSvgImage(
                        assetPath: "assets/svg/arrow_back.svg",
                        onTap: () => Navigator.pop(context),
                        backgroundColor: const Color(
                          0XFF1B1E28,
                        ).withOpacity(0.3),
                        iconColor: Colors.white,
                      ),
                      // if (!showAppbarTitle)
                      //   Text(
                      //     r.name,
                      //     style: const TextStyle(
                      //       fontSize: 18,
                      //       fontFamily: 'SFUIDisplay',
                      //       fontWeight: FontWeight.bold,
                      //       color: Colors.white,
                      //     ),
                      //   ),
                      CircleSvgImage(
                        assetPath: "assets/svg/bookmark.svg",
                        onTap: () => print("Bookmark tapped!"),
                        backgroundColor: const Color(0XFF1B1E28),
                        iconColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
