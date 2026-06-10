import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/post_model.dart';
import '../providers/app_provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_routes.dart';
import 'avatar_widget.dart';
import 'deadline_badge.dart';

class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  Color _categoryColor(String cat) {
    switch (cat) {
      case 'Events':
        return const Color(0xFF6366F1);
      case 'Opportunities':
        return AppColors.successGreen;
      case 'Academic':
        return const Color(0xFF0EA5E9);
      case 'Clubs':
        return AppColors.accentAmber;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final isSaved = provider.isSaved(post.id);
    final isRsvpd = provider.isRsvpd(post.id);
    final catColor = _categoryColor(post.category);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.eventDetail, arguments: post),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: post.coverImageUrl,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, _) => Container(
                      height: 160,
                      color: AppColors.cardBackgroundLight,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.accentGold,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    errorWidget: (_, _, _) => Container(
                      height: 160,
                      color: AppColors.cardBackgroundLight,
                      child: const Icon(Icons.image_outlined, color: AppColors.textSecondary),
                    ),
                  ),
                  // Category tag
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: catColor.withAlpha(230),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        post.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  // Save button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => provider.toggleSave(post.id),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          isSaved ? Icons.bookmark : Icons.bookmark_outline,
                          color: isSaved ? AppColors.accentGold : Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + deadline badge
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          post.title,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      DeadlineBadge(daysLeft: post.daysUntilDeadline),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Organizer row
                  Row(
                    children: [
                      AvatarWidget(
                        imageUrl: post.organizerAvatar,
                        size: 22,
                        fallbackInitial: post.organizerName[0],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        post.organizerName,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.location_on_outlined,
                          size: 13, color: AppColors.textTertiary),
                      const SizedBox(width: 2),
                      Flexible(
                        child: Text(
                          post.location,
                          style: const TextStyle(
                            color: AppColors.textTertiary,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Date row
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          size: 13, color: AppColors.textTertiary),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('EEE, MMM d · h:mm a').format(post.date),
                        style: const TextStyle(
                          color: AppColors.textTertiary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Quick actions row
                  Row(
                    children: [
                      _ActionChip(
                        label: isRsvpd ? 'RSVPd ✓' : 'RSVP',
                        count: post.rsvpCount,
                        isActive: isRsvpd,
                        onTap: () => provider.toggleRsvp(post.id),
                        activeColor: AppColors.accentGold,
                      ),
                      const SizedBox(width: 8),
                      _ActionChip(
                        label: 'Interested',
                        count: post.interestedCount,
                        isActive: false,
                        onTap: () {},
                        activeColor: AppColors.successGreen,
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {},
                        child: const Icon(
                          Icons.share_outlined,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final String label;
  final int count;
  final bool isActive;
  final VoidCallback onTap;
  final Color activeColor;

  const _ActionChip({
    required this.label,
    required this.count,
    required this.isActive,
    required this.onTap,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? activeColor.withAlpha(38) : AppColors.cardBackgroundLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? activeColor : AppColors.borderColor,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isActive ? activeColor : AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              count.toString(),
              style: TextStyle(
                color: isActive ? activeColor : AppColors.textTertiary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
