import 'package:go_router/go_router.dart';
import '../screens/auth/login_screen.dart';
import '../screens/main_screen.dart';
import '../screens/market_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/portfolio_screen.dart';
import '../screens/splash_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => OnBoardingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/main',
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      path: '/market',
      builder: (context, state) => MarketScreen(),
    ),
    GoRoute(
      path: '/portfolio',
      builder: (context, state) => PortfolioScreen(),
    ),
  ],
);