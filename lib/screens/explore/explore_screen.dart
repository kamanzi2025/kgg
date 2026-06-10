import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_strings.dart';
import '../../models/community_model.dart';
import '../../providers/app_provider.dart';
import '../../widgets/category_chip.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  String _filter = 'All';

  static const _filters = [
    AppStrings.catAll,
    AppStrings.catEvents,
    AppStrings.catOpportunities,
    AppStrings.catClubs,
    AppStrings.catAcademic,
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final user = provider.currentUser;

    final communities = provider.communities.where((c) {
      final matchQuery = _query.isEmpty ||
          c.name.toLowerCase().contains(_query.toLowerCase()) ||
          c.description.toLowerCase().contains(_query.toLowerCase());
      final matchFilter = _filter == 'All' || c.category == _filter;
      return matchQuery && matchFilter;
    }).toList();

    // Recommended: match user's campus
    final recommended = provider.communities
        .where((c) => c.campus == user?.campus && !c.isJoined)
        .take(4)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Explore',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(
                              context, AppRoutes.communities),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 7),
                            decoration: BoxDecoration(
                              color: AppColors.accentGold.withAlpha(20),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: AppColors.accentGold.withAlpha(60)),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.group_rounded,
                                    color: AppColors.accentGold, size: 15),
                                SizedBox(width: 5),
                                Text(
                                  'My Clubs',
                                  style: TextStyle(
                                    color: AppColors.accentGold,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Search bar
                    TextField(
                      controller: _searchCtrl,
                      style: const TextStyle(color: AppColors.textPrimary),
                      onChanged: (v) => setState(() => _query = v),
                      decoration: InputDecoration(
                        hintText: 'Search clubs, communities...',
                        hintStyle: const TextStyle(color: AppColors.textSecondary),
                        prefixIcon: const Icon(Icons.search,
                            color: AppColors.textSecondary),
                        suffixIcon: _query.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear,
                                    color: AppColors.textSecondary, size: 18),
                                onPressed: () {
                                  _searchCtrl.clear();
                                  setState(() => _query = '');
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: AppColors.cardBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Filter chips
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 0, 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filters.map((f) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: CategoryChip(
                          label: f,
                          isSelected: _filter == f,
                          onTap: () => setState(() => _filter = f),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            // Recommended section (only when no active search/filter)
            if (_query.isEmpty && _filter == 'All' && recommended.isNotEmpty)
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: Row(
                        children: [
                          const Icon(Icons.star_outline_rounded,
                              color: AppColors.accentGold, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            'Recommended for You · ${user?.campus ?? ''}',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 130,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                        itemCount: recommended.length,
                        itemBuilder: (_, i) =>
                            _RecommendedCard(community: recommended[i]),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: Text(
                        'All Communities',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Grid
            communities.isEmpty
                ? SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: const [
                          Icon(Icons.search_off_rounded,
                              color: AppColors.textSecondary, size: 48),
                          SizedBox(height: 12),
                          Text(
                            'No communities found',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) => _CommunityGridCard(community: communities[i]),
                        childCount: communities.length,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.85,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class _CommunityGridCard extends StatelessWidget {
  final CommunityModel community;
  const _CommunityGridCard({required this.community});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final joined = provider.isCommunityJoined(community.id);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover
          Expanded(
            child: CachedNetworkImage(
              imageUrl: community.coverImageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              placeholder: (_, _) =>
                  Container(color: AppColors.cardBackgroundLight),
              errorWidget: (_, _, _) => Container(
                color: AppColors.cardBackgroundLight,
                child: const Icon(Icons.image_outlined,
                    color: AppColors.textSecondary),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  community.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${community.memberCount} members',
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 11),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => provider.toggleJoin(community.id),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 6),
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
                      joined ? 'Joined ✓' : 'Join',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: joined ? AppColors.textSecondary : Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendedCard extends StatelessWidget {
  final CommunityModel community;
  const _RecommendedCard({required this.community});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AppProvider>();

    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.accentGold.withAlpha(60)),
        color: AppColors.cardBackground,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: community.coverImageUrl,
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (_, _) =>
                Container(color: AppColors.cardBackgroundLight),
            errorWidget: (_, _, _) =>
                Container(color: AppColors.cardBackgroundLight),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black87],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  community.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () => provider.toggleJoin(community.id),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accentGold,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Join',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
