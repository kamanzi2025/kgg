import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_routes.dart';
import '../../providers/app_provider.dart';
import '../../widgets/avatar_widget.dart';
import '../../widgets/post_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  Color _roleColor(String role) {
    switch (role) {
      case 'Club Leader':
        return const Color(0xFF6366F1);
      case 'Entrepreneur':
        return AppColors.accentGold;
      case 'Event Organizer':
        return AppColors.successGreen;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final user = provider.currentUser;
    if (user == null) return const SizedBox.shrink();

    final myPosts = provider.myPosts;
    final savedPosts = provider.savedPosts;
    final roleColor = _roleColor(user.role);

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: NestedScrollView(
        headerSliverBuilder: (_, _) => [
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Profile header
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1B2A4A), AppColors.primaryDark],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Profile',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.logout_rounded,
                                color: AppColors.textSecondary),
                            onPressed: () async {
                              await provider.logout();
                              if (!context.mounted) return;
                              Navigator.pushReplacementNamed(
                                  context, AppRoutes.login);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      AvatarWidget(
                        imageUrl: user.avatarUrl,
                        size: 80,
                        fallbackInitial: user.name[0],
                        showBorder: true,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user.name,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: roleColor.withAlpha(30),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: roleColor.withAlpha(80)),
                            ),
                            child: Text(
                              user.role,
                              style: TextStyle(
                                color: roleColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.cardBackgroundLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on_outlined,
                                    size: 12,
                                    color: AppColors.textSecondary),
                                const SizedBox(width: 4),
                                Text(
                                  user.campus,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Stats row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _StatBox(
                              value: user.eventsAttended,
                              label: 'Events\nAttended'),
                          _Divider(),
                          _StatBox(
                              value: provider.joinedCommunities.length,
                              label: 'Communities\nJoined'),
                          _Divider(),
                          _StatBox(
                              value: user.connections,
                              label: 'Connections'),
                        ],
                      ),
                    ],
                  ),
                ),

                // Contribution timeline
                _ContributionTimeline(provider: provider, userId: user.id),

                // Tab bar
                Container(
                  color: AppColors.cardBackground,
                  child: TabBar(
                    controller: _tabCtrl,
                    indicatorColor: AppColors.accentGold,
                    labelColor: AppColors.accentGold,
                    unselectedLabelColor: AppColors.textSecondary,
                    labelStyle: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700),
                    tabs: const [
                      Tab(text: 'My Posts'),
                      Tab(text: 'Saved'),
                      Tab(text: 'Settings'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabCtrl,
          children: [
            // My Posts tab
            myPosts.isEmpty
                ? _EmptyState(
                    icon: Icons.post_add_rounded,
                    message: provider.canPost
                        ? 'You haven\'t posted anything yet'
                        : 'Students can\'t create posts',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 100),
                    itemCount: myPosts.length,
                    itemBuilder: (_, i) => PostCard(post: myPosts[i]),
                  ),

            // Saved tab
            savedPosts.isEmpty
                ? const _EmptyState(
                    icon: Icons.bookmark_outline_rounded,
                    message: 'No saved posts yet',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 100),
                    itemCount: savedPosts.length,
                    itemBuilder: (_, i) => PostCard(post: savedPosts[i]),
                  ),

            // Settings tab
            _SettingsTab(user: user),
          ],
        ),
      ),
    );
  }
}

// Contribution timeline showing a 12-week activity heatmap + recent activity list
class _ContributionTimeline extends StatelessWidget {
  final AppProvider provider;
  final String userId;

  const _ContributionTimeline({
    required this.provider,
    required this.userId,
  });

  // Build a mock 12-week grid where intensity reflects saved+rsvp activity
  List<int> _buildWeekGrid() {
    final saved = provider.savedPosts.length;
    final rsvps = provider.currentUser?.rsvpPostIds.length ?? 0;
    final total = saved + rsvps;
    // Distribute activity realistically across 84 days
    final grid = List<int>.filled(84, 0);
    final rng = total * 3; // amplify for visual interest
    for (int i = 0; i < rng && i < 84; i++) {
      final idx = (i * 7 + i * 3) % 84;
      grid[idx] = (grid[idx] + 1).clamp(0, 4);
    }
    // Always show some baseline activity so profile isn't empty
    for (int i = 0; i < 84; i += 11) {
      grid[i] = grid[i].clamp(1, 4);
    }
    return grid;
  }

  Color _cellColor(int level) {
    switch (level) {
      case 0:
        return AppColors.borderColor;
      case 1:
        return AppColors.accentGold.withAlpha(50);
      case 2:
        return AppColors.accentGold.withAlpha(110);
      case 3:
        return AppColors.accentGold.withAlpha(180);
      default:
        return AppColors.accentGold;
    }
  }

  @override
  Widget build(BuildContext context) {
    final grid = _buildWeekGrid();
    final recentActivity = _buildRecentActivity();

    return Container(
      color: AppColors.primaryDark,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Contribution Activity',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${provider.savedPosts.length + (provider.currentUser?.rsvpPostIds.length ?? 0)} actions',
                style: const TextStyle(
                  color: AppColors.accentGold,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 12-week heatmap grid (7 rows × 12 cols)
          SizedBox(
            height: 72,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 12,
                mainAxisSpacing: 3,
                crossAxisSpacing: 3,
              ),
              itemCount: 84,
              itemBuilder: (_, i) => Container(
                decoration: BoxDecoration(
                  color: _cellColor(grid[i]),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),

          // Legend
          Row(
            children: [
              const Text('Less',
                  style: TextStyle(
                      color: AppColors.textTertiary, fontSize: 10)),
              const SizedBox(width: 4),
              ...List.generate(5, (i) => Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(right: 3),
                    decoration: BoxDecoration(
                      color: _cellColor(i),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  )),
              const Text('More',
                  style: TextStyle(
                      color: AppColors.textTertiary, fontSize: 10)),
            ],
          ),
          const SizedBox(height: 16),

          // Recent activity timeline
          const Text(
            'Recent Activity',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),

          ...recentActivity.asMap().entries.map((entry) {
            final i = entry.key;
            final item = entry.value;
            final isLast = i == recentActivity.length - 1;
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timeline spine
                  SizedBox(
                    width: 24,
                    child: Column(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: item.color,
                          ),
                        ),
                        if (!isLast)
                          Expanded(
                            child: Container(
                              width: 1.5,
                              color: AppColors.borderColor,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.text,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                height: 1.4,
                              ),
                            ),
                          ),
                          Text(
                            item.time,
                            style: const TextStyle(
                              color: AppColors.textTertiary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  List<_ActivityItem> _buildRecentActivity() {
    final items = <_ActivityItem>[];
    final saved = provider.savedPosts;
    final rsvps = provider.currentUser?.rsvpPostIds ?? [];
    final joined = provider.joinedCommunities;

    for (final p in saved.take(2)) {
      items.add(_ActivityItem(
        text: 'Saved "${p.title}"',
        time: '2d ago',
        color: AppColors.accentGold,
      ));
    }
    if (rsvps.isNotEmpty) {
      items.add(_ActivityItem(
        text: 'RSVPd to ${rsvps.length} event${rsvps.length > 1 ? 's' : ''}',
        time: '3d ago',
        color: AppColors.successGreen,
      ));
    }
    for (final c in joined.take(2)) {
      items.add(_ActivityItem(
        text: 'Joined "${c.name}"',
        time: '1w ago',
        color: const Color(0xFF6366F1),
      ));
    }

    // Fallback so timeline never looks empty
    if (items.isEmpty) {
      items.addAll([
        _ActivityItem(
            text: 'Joined ALU Connect',
            time: 'recently',
            color: AppColors.accentGold),
        _ActivityItem(
            text: 'Set up your profile',
            time: 'recently',
            color: AppColors.successGreen),
      ]);
    }
    return items;
  }
}

class _ActivityItem {
  final String text;
  final String time;
  final Color color;
  const _ActivityItem(
      {required this.text, required this.time, required this.color});
}

class _StatBox extends StatelessWidget {
  final int value;
  final String label;
  const _StatBox({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$value',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      color: AppColors.borderColor,
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 48),
          const SizedBox(height: 12),
          Text(message,
              style: const TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _SettingsTab extends StatelessWidget {
  final dynamic user;
  const _SettingsTab({required this.user});

  @override
  Widget build(BuildContext context) {
    final items = [
      _SettingItem(
          icon: Icons.person_outline_rounded, label: 'Edit Profile'),
      _SettingItem(
          icon: Icons.notifications_outlined, label: 'Notifications'),
      _SettingItem(icon: Icons.lock_outline_rounded, label: 'Privacy'),
      _SettingItem(
          icon: Icons.help_outline_rounded, label: 'Help & Support'),
      _SettingItem(
          icon: Icons.info_outline_rounded, label: 'About ALU Connect'),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      children: items
          .map((item) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: Row(
                  children: [
                    Icon(item.icon,
                        color: AppColors.textSecondary, size: 20),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(item.label,
                          style: const TextStyle(
                              color: AppColors.textPrimary, fontSize: 14)),
                    ),
                    const Icon(Icons.chevron_right_rounded,
                        color: AppColors.textSecondary, size: 18),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

class _SettingItem {
  final IconData icon;
  final String label;
  const _SettingItem({required this.icon, required this.label});
}
