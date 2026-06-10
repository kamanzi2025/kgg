import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../providers/app_provider.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/post_card.dart';
import '../../widgets/avatar_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _categories = [
    AppStrings.catAll,
    AppStrings.catEvents,
    AppStrings.catOpportunities,
    AppStrings.catClubs,
    AppStrings.catAcademic,
  ];

  static const _campuses = ['All', 'Kigali', 'Mauritius', 'Remote'];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final user = provider.currentUser;
    final featured = provider.featuredPosts;
    final posts = provider.filteredPosts;

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, ${user?.name.split(' ').first ?? 'Leader'} 👋',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Text(
                            'What\'s happening on campus?',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AvatarWidget(
                      imageUrl: user?.avatarUrl ?? '',
                      size: 44,
                      fallbackInitial: user?.name[0],
                      showBorder: true,
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),
            ),

            // ── Campus filter toggle ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 0, 0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _campuses.map((c) {
                      final selected = provider.selectedCampusFilter == c;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(c),
                          selected: selected,
                          onSelected: (_) => provider.setCampusFilter(c),
                          selectedColor: AppColors.accentGold.withAlpha(40),
                          checkmarkColor: AppColors.accentGold,
                          labelStyle: TextStyle(
                            color: selected
                                ? AppColors.accentGold
                                : AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w400,
                          ),
                          backgroundColor: AppColors.cardBackground,
                          side: BorderSide(
                            color: selected
                                ? AppColors.accentGold
                                : AppColors.borderColor,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            // ── Trending / Featured carousel ──
            if (featured.isNotEmpty)
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
                      child: Row(
                        children: [
                          Icon(Icons.local_fire_department_rounded,
                              color: AppColors.accentGold, size: 18),
                          SizedBox(width: 6),
                          Text(
                            'Trending This Week',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CarouselSlider.builder(
                      itemCount: featured.length,
                      options: CarouselOptions(
                        height: 200,
                        viewportFraction: 0.88,
                        enableInfiniteScroll: featured.length > 1,
                        autoPlay: featured.length > 1,
                        autoPlayInterval: const Duration(seconds: 4),
                        enlargeCenterPage: true,
                      ),
                      itemBuilder: (_, i, _) {
                        final p = featured[i];
                        return _FeaturedCard(post: p);
                      },
                    ),
                  ],
                ),
              ),

            // ── Category chips ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 0, 4),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((c) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: CategoryChip(
                          label: c,
                          isSelected: provider.selectedCategory == c,
                          onTap: () => provider.setCategory(c),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            // ── Section header ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${posts.length} Post${posts.length == 1 ? '' : 's'}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    const Icon(Icons.tune_rounded,
                        color: AppColors.textSecondary, size: 18),
                  ],
                ),
              ),
            ),

            // ── Feed ──
            posts.isEmpty
                ? SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: const [
                          Icon(Icons.inbox_outlined,
                              color: AppColors.textSecondary, size: 48),
                          SizedBox(height: 12),
                          Text(
                            'No posts found',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => PostCard(post: posts[i])
                          .animate(delay: (i * 60).ms)
                          .slideY(begin: 0.2, end: 0, duration: 300.ms)
                          .fadeIn(),
                      childCount: posts.length,
                    ),
                  ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final dynamic post;
  const _FeaturedCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/event/detail', arguments: post),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: NetworkImage(post.coverImageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Colors.transparent, Colors.black87],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.accentGold,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  post.category,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                post.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.people_alt_outlined,
                      size: 13, color: Colors.white70),
                  const SizedBox(width: 4),
                  Text(
                    '${post.rsvpCount} attending',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
