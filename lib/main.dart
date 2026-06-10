import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants/app_colors.dart';
import 'constants/app_routes.dart';
import 'models/post_model.dart';
import 'providers/app_provider.dart';
import 'services/prefs_service.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/main_shell.dart';
import 'screens/event_detail/event_detail_screen.dart';
import 'screens/post/post_create_screen.dart';
import 'screens/chat/chat_room_screen.dart';
import 'screens/explore/communities_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefsService.init();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  // Prevent crash when emulator/device has no internet for font CDN
  GoogleFonts.config.allowRuntimeFetching = false;

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider()..loadUser(),
      child: const ALUConnectApp(),
    ),
  );
}

class ALUConnectApp extends StatelessWidget {
  const ALUConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ALU Connect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: AppColors.accentGold,
          surface: AppColors.cardBackground,
        ),
        scaffoldBackgroundColor: AppColors.primaryDark,
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.dark().textTheme,
        ),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.splash,
      onGenerateRoute: _generateRoute,
    );
  }

  Route<dynamic>? _generateRoute(RouteSettings settings) {
    Widget page;

    switch (settings.name) {
      case AppRoutes.splash:
        page = const SplashScreen();
      case AppRoutes.onboarding:
        page = const OnboardingScreen();
      case AppRoutes.login:
        page = const LoginScreen();
      case AppRoutes.signup:
        page = const SignupScreen();
      case AppRoutes.main:
        page = const MainShell();
      case AppRoutes.postCreate:
        page = const PostCreateScreen();
      case AppRoutes.eventDetail:
        final post = settings.arguments as PostModel;
        page = EventDetailScreen(post: post);
      case AppRoutes.chatRoom:
        final roomId = settings.arguments as String;
        page = ChatRoomScreen(roomId: roomId);
      case AppRoutes.communities:
        page = const CommunitiesScreen();
      default:
        page = const SplashScreen();
    }

    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, animation, _, child) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      transitionDuration: const Duration(milliseconds: 250),
    );
  }
}
