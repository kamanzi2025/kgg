import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_routes.dart';
import '../../services/prefs_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    // Let animation play before checking session
    await Future.delayed(const Duration(milliseconds: 2800));
    if (!mounted) return;

    if (PrefsService.isLoggedIn) {
      Navigator.pushReplacementNamed(context, AppRoutes.main);
    } else if (PrefsService.hasOnboarded) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.splashGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo circle
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.goldGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentGold.withAlpha(100),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'ALU',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              )
                  .animate()
                  .scale(
                    begin: const Offset(0.3, 0.3),
                    end: const Offset(1, 1),
                    duration: 700.ms,
                    curve: Curves.elasticOut,
                  )
                  .fadeIn(duration: 400.ms),
              const SizedBox(height: 24),
              const Text(
                'ALU Connect',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              )
                  .animate(delay: 400.ms)
                  .slideY(begin: 0.3, end: 0, duration: 500.ms)
                  .fadeIn(),
              const SizedBox(height: 8),
              const Text(
                'Where ALU Leaders Connect',
                style: TextStyle(
                  color: AppColors.accentGold,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              )
                  .animate(delay: 700.ms)
                  .fadeIn(duration: 500.ms),
              const SizedBox(height: 60),
              const SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  color: AppColors.accentGold,
                  strokeWidth: 2,
                ),
              ).animate(delay: 1200.ms).fadeIn(),
            ],
          ),
        ),
      ),
    );
  }
}
