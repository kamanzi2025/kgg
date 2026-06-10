import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_strings.dart';
import '../../services/prefs_service.dart';
import '../../widgets/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_OnboardPage> _pages = [
    _OnboardPage(
      icon: Icons.event_available_rounded,
      title: AppStrings.onboard1Title,
      description: AppStrings.onboard1Desc,
      gradientColors: [const Color(0xFF6366F1), const Color(0xFF4F46E5)],
    ),
    _OnboardPage(
      icon: Icons.people_alt_rounded,
      title: AppStrings.onboard2Title,
      description: AppStrings.onboard2Desc,
      gradientColors: [const Color(0xFF0EA5E9), const Color(0xFF0284C7)],
    ),
    _OnboardPage(
      icon: Icons.rocket_launch_rounded,
      title: AppStrings.onboard3Title,
      description: AppStrings.onboard3Desc,
      gradientColors: [AppColors.accentGold, AppColors.accentAmber],
    ),
  ];

  Future<void> _finish() async {
    await PrefsService.setOnboarded();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _finish,
                child: const Text(
                  AppStrings.skip,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (_, i) => _OnboardPageView(page: _pages[i]),
              ),
            ),

            // Indicator + buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: _controller,
                    count: _pages.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: AppColors.accentGold,
                      dotColor: AppColors.borderColor,
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 3,
                    ),
                  ),
                  const SizedBox(height: 28),
                  CustomButton(
                    label: _currentPage == _pages.length - 1
                        ? AppStrings.getStarted
                        : AppStrings.next,
                    width: double.infinity,
                    onTap: () {
                      if (_currentPage == _pages.length - 1) {
                        _finish();
                      } else {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
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

class _OnboardPage {
  final IconData icon;
  final String title;
  final String description;
  final List<Color> gradientColors;

  const _OnboardPage({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradientColors,
  });
}

class _OnboardPageView extends StatelessWidget {
  final _OnboardPage page;

  const _OnboardPageView({required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: page.gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: page.gradientColors[0].withAlpha(80),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Icon(page.icon, size: 64, color: Colors.white),
          )
              .animate()
              .scale(
                begin: const Offset(0.5, 0.5),
                duration: 500.ms,
                curve: Curves.elasticOut,
              )
              .fadeIn(),
          const SizedBox(height: 40),
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              height: 1.3,
            ),
          ).animate(delay: 150.ms).slideY(begin: 0.3).fadeIn(),
          const SizedBox(height: 16),
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
              height: 1.6,
            ),
          ).animate(delay: 250.ms).slideY(begin: 0.3).fadeIn(),
        ],
      ),
    );
  }
}
