import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_colors.dart';

class AvatarWidget extends StatelessWidget {
  final String imageUrl;
  final double size;
  final String? fallbackInitial;
  final bool showBorder;

  const AvatarWidget({
    super.key,
    required this.imageUrl,
    this.size = 40,
    this.fallbackInitial,
    this.showBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(color: AppColors.accentGold, width: 2)
            : null,
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (_, _) => Container(
            color: AppColors.cardBackgroundLight,
            child: Center(
              child: Text(
                fallbackInitial ?? '?',
                style: TextStyle(
                  color: AppColors.accentGold,
                  fontSize: size * 0.35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          errorWidget: (_, _, _) => Container(
            color: AppColors.cardBackgroundLight,
            child: Center(
              child: Text(
                fallbackInitial ?? '?',
                style: TextStyle(
                  color: AppColors.accentGold,
                  fontSize: size * 0.35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
