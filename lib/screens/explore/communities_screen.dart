import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants/app_colors.dart';
import '../../models/community_model.dart';
import '../../providers/app_provider.dart';
import '../../widgets/avatar_widget.dart';

class CommunitiesScreen extends StatefulWidget {
  const CommunitiesScreen({super.key});

  @override
  State<CommunitiesScreen> createState() => _CommunitiesScreenState();
}

class _CommunitiesScreenState extends State<CommunitiesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final all = provider.communities;
    final joined = provider.joinedCommunities;

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Communities',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        elevation: 0,
        bottom: TabBar(
          controller: _tabCtrl,
          indicatorColor: AppColors.accentGold,
          labelColor: AppColors.accentGold,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w700),
          tabs: [
            Tab(text: 'All Clubs (${all.length})'),
            Tab(text: 'My Clubs (${joined.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          _CommunityList(communities: all),
          joined.isEmpty
              ? const _EmptyJoined()
              : _CommunityList(communities: joined),
        ],
      ),
    );
  }
}

class _CommunityList extends StatelessWidget {
  final List<CommunityModel> communities;
  const _CommunityList({required this.communities});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemCount: communities.length,
      itemBuilder: (_, i) => _CommunityListTile(community: communities[i]),
    );
  }
}

class _CommunityListTile extends StatelessWidget {
  final CommunityModel community;
  const _CommunityListTile({required this.community});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final joined = provider.isCommunityJoined(community.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: joined
              ? AppColors.accentGold.withAlpha(60)
              : AppColors.borderColor,
        ),
      ),
      child: Row(
        children: [
          // Cover thumbnail
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: CachedNetworkImage(
              imageUrl: community.coverImageUrl,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              placeholder: (_, _) =>
                  Container(width: 90, height: 90, color: AppColors.cardBackgroundLight),
              errorWidget: (_, _, _) => Container(
                width: 90,
                height: 90,
                color: AppColors.cardBackgroundLight,
                child: const Icon(Icons.group_rounded,
                    color: AppColors.textSecondary),
              ),
            ),
          ),
          // Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          community.name,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (joined)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.accentGold.withAlpha(30),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Member',
                            style: TextStyle(
                              color: AppColors.accentGold,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    community.description,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      AvatarWidget(
                        imageUrl: community.iconUrl,
                        size: 20,
                        fallbackInitial: community.leaderName[0],
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${community.memberCount} members · ${community.campus}',
                          style: const TextStyle(
                            color: AppColors.textTertiary,
                            fontSize: 11,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => provider.toggleJoin(community.id),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: joined
                                ? AppColors.cardBackgroundLight
                                : AppColors.accentGold,
                            borderRadius: BorderRadius.circular(8),
                            border: joined
                                ? Border.all(color: AppColors.borderColor)
                                : null,
                          ),
                          child: Text(
                            joined ? 'Leave' : 'Join',
                            style: TextStyle(
                              color: joined
                                  ? AppColors.textSecondary
                                  : Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyJoined extends StatelessWidget {
  const _EmptyJoined();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.group_add_outlined,
              color: AppColors.textSecondary, size: 56),
          const SizedBox(height: 16),
          const Text(
            'You haven\'t joined any clubs yet',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Explore communities and tap Join',
            style: TextStyle(
                color: AppColors.textTertiary, fontSize: 13),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                gradient: AppColors.goldGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Browse All Clubs',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
