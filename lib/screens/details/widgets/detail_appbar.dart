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
      backgroundColor: showAppbarTitle
          ? Theme.of(context).colorScheme.primary
          : Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false, // hilangkan back default
      title: showAppbarTitle
          ? Text(
              r.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: 'img-${r.id}',
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Hero Image
              Image.network(
                ApiService.imageUrl(r.pictureId),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(color: Colors.grey[200]),
              ),

              // Overlay Gradient opsional biar teks lebih jelas
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(0.3), Colors.transparent],
                  ),
                ),
              ),

              // Top Bar (Back + Title + Bookmark)
              // Top Bar (Back + Title + Bookmark)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
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
                        const Text(
                          "Details",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'SFUIDisplay',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        CircleSvgImage(
                          assetPath: "assets/svg/bookmark.svg",
                          onTap: () {
                            print("Bookmark tapped!");
                          },
                          backgroundColor: const Color(
                            0XFF1B1E28,
                          ).withOpacity(0.3),
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
      ),
    );
  }
}
