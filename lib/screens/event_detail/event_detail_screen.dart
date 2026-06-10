import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../constants/app_colors.dart';
import '../../models/post_model.dart';
import '../../providers/app_provider.dart';
import '../../widgets/avatar_widget.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/deadline_badge.dart';

class EventDetailScreen extends StatelessWidget {
  final PostModel post;
  const EventDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final isRsvpd = provider.isRsvpd(post.id);
    final isSaved = provider.isSaved(post.id);

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: CustomScrollView(
        slivers: [
          // Hero image app bar
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppColors.cardBackground,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded,
                      color: Colors.white, size: 18),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: IconButton(
                    icon: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_outline,
                      color: isSaved ? AppColors.accentGold : Colors.white,
                      size: 18,
                    ),
                    onPressed: () => provider.toggleSave(post.id),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: post.coverImageUrl,
                fit: BoxFit.cover,
                placeholder: (_, _) =>
                    Container(color: AppColors.cardBackgroundLight),
                errorWidget: (_, _, _) =>
                    Container(color: AppColors.cardBackgroundLight),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category + deadline
                  Row(
                    children: [
                      _CategoryTag(post.category),
                      const SizedBox(width: 8),
                      DeadlineBadge(daysLeft: post.daysUntilDeadline),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Title
                  Text(
                    post.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Meta info cards
                  Row(
                    children: [
                      Expanded(
                        child: _MetaCard(
                          icon: Icons.calendar_today_outlined,
                          title: 'Date',
                          value: DateFormat('EEE, MMM d').format(post.date),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _MetaCard(
                          icon: Icons.access_time_rounded,
                          title: 'Time',
                          value: DateFormat('h:mm a').format(post.date),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _MetaCard(
                          icon: Icons.location_on_outlined,
                          title: 'Location',
                          value: post.location,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _MetaCard(
                          icon: Icons.people_alt_outlined,
                          title: 'Attending',
                          value:
                              '${post.rsvpCount} / ${post.maxParticipants}',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Organizer
                  Row(
                    children: [
                      AvatarWidget(
                        imageUrl: post.organizerAvatar,
                        size: 40,
                        fallbackInitial: post.organizerName[0],
                        showBorder: true,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Organised by',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            post.organizerName,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Description
                  const Text(
                    'About This Event',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    post.description,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tags
                  if (post.tags.isNotEmpty) ...[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: post.tags
                          .map((t) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.cardBackgroundLight,
                                  borderRadius: BorderRadius.circular(20),
                                  border:
                                      Border.all(color: AppColors.borderColor),
                                ),
                                child: Text(
                                  '#$t',
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Attendance bar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Spots Filled',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '${((post.rsvpCount / post.maxParticipants) * 100).round()}%',
                            style: const TextStyle(
                              color: AppColors.accentGold,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: post.rsvpCount / post.maxParticipants,
                          backgroundColor: AppColors.borderColor,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.accentGold),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // RSVP button
                  CustomButton(
                    label: isRsvpd ? 'You\'re In! ✓' : 'RSVP Now',
                    width: double.infinity,
                    color: isRsvpd ? AppColors.successGreen : AppColors.accentGold,
                    onTap: () => provider.toggleRsvp(post.id),
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    label: 'Share Event',
                    width: double.infinity,
                    isOutlined: true,
                    icon: Icons.share_outlined,
                    onTap: () {},
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryTag extends StatelessWidget {
  final String category;
  const _CategoryTag(this.category);

  Color get _color {
    switch (category) {
      case 'Events':
        return const Color(0xFF6366F1);
      case 'Opportunities':
        return AppColors.successGreen;
      case 'Academic':
        return const Color(0xFF0EA5E9);
      default:
        return AppColors.accentAmber;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: _color.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _color.withAlpha(80)),
      ),
      child: Text(
        category,
        style: TextStyle(
          color: _color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _MetaCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  const _MetaCard({required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accentGold, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 11)),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
