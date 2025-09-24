// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircleSvgImage extends StatelessWidget {
  final String assetPath;
  final VoidCallback onTap;
  final double iconSize;
  final double padding;
  final Color backgroundColor;
  final Color iconColor;

  const CircleSvgImage({
    super.key,
    required this.assetPath,
    required this.onTap,
    this.iconSize = 20,
    this.padding = 8,
    this.backgroundColor = Colors.black26,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
        ),
        child: SvgPicture.asset(
          assetPath,
          width: iconSize,
          height: iconSize,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
      ),
    );
  }
}
