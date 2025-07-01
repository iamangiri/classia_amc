import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';
import '../blocs/main_screen/main_screen_bloc.dart';
import '../blocs/main_screen/main_screen_event.dart';
import '../blocs/main_screen/main_screen_state.dart';
import '../service/local_auth_service.dart';
import '../themes/light_app_theme.dart';
import 'home_screen.dart';
import 'invester_screen.dart';
import 'market_screen.dart';
import 'portfolio_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late MotionTabBarController _motionTabBarController;
  final LocalAuthService _localAuthService = LocalAuthService();
  bool isAuthenticating = true;
  bool authenticationFailed = false;
  String authMessage = "Authenticating...";

  @override
  void initState() {
    super.initState();
    _motionTabBarController = MotionTabBarController(
      initialIndex: 0,
      length: 4,
      vsync: this,
    );
    _authenticateUser();
  }

  @override
  void dispose() {
    _motionTabBarController.dispose();
    super.dispose();
  }

  Future<void> _authenticateUser() async {
    try {
      setState(() {
        isAuthenticating = true;
        authenticationFailed = false;
        authMessage = "Checking authentication...";
      });

      // Add a small delay to show the loading screen
      await Future.delayed(const Duration(milliseconds: 500));

      // Check if biometric is available first
      bool isBiometricAvailable = await _localAuthService.isBiometricAvailable();

      if (!isBiometricAvailable) {
        setState(() {
          authMessage = "Biometric not available. Proceeding...";
        });
        await Future.delayed(const Duration(milliseconds: 1000));
        setState(() {
          isAuthenticating = false;
        });
        return;
      }

      setState(() {
        authMessage = "Authenticating...";
      });

      bool isAuthenticated = await _localAuthService.authenticate();

      if (!isAuthenticated) {
        // Check if locked out
        if (_localAuthService.isLockedOut()) {
          setState(() {
            authenticationFailed = true;
            authMessage = "Too many failed attempts. Try again in ${_localAuthService.getRemainingLockTime()} seconds.";
          });

          // Auto retry after lockout period
          Future.delayed(Duration(seconds: _localAuthService.getRemainingLockTime() + 1), () {
            if (mounted) {
              _authenticateUser();
            }
          });
          return;
        } else {
          setState(() {
            authenticationFailed = true;
            authMessage = "Authentication failed. Tap to retry.";
          });
          return;
        }
      }

      setState(() {
        isAuthenticating = false;
        authenticationFailed = false;
      });

    } catch (e) {
      print("Error during authentication: $e");
      // On any error, proceed to main screen to prevent blank screen
      setState(() {
        authMessage = "Authentication error. Proceeding...";
      });
      await Future.delayed(const Duration(milliseconds: 1000));
      setState(() {
        isAuthenticating = false;
        authenticationFailed = false;
      });
    }
  }

  void _retryAuthentication() {
    _localAuthService.resetAuthState();
    _authenticateUser();
  }

  void _skipAuthentication() {
    setState(() {
      isAuthenticating = false;
      authenticationFailed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isAuthenticating || authenticationFailed) {
      return _buildAuthLoadingScreen();
    }

    return BlocBuilder<MainScreenBloc, MainScreenState>(
      builder: (context, state) {
        int selectedIndex = state is TabChangedState ? state.tabIndex : 0;

        return Scaffold(
          bottomNavigationBar: MotionTabBar(
            controller: _motionTabBarController,
            initialSelectedTab: ["Home", "Market", "Portfolio", "Investors"][selectedIndex],
            labels: const ["Home", "Market", "Portfolio", "Investors"],
            icons: const [
              Icons.home,
              Icons.trending_up,
              Icons.work,
              Icons.account_balance_wallet,
            ],
            tabSize: 50,
            tabBarHeight: 55,
            textStyle: const TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            tabIconColor: AppTheme.lightTheme.primaryColor,
            tabIconSize: 28.0,
            tabIconSelectedSize: 26.0,
            tabSelectedColor: AppTheme.lightTheme.primaryColor,
            tabIconSelectedColor: Colors.white,
            tabBarColor: Colors.white,
            onTabItemSelected: (int value) {
              context.read<MainScreenBloc>().add(TabChangeEvent(value));
              setState(() {
                _motionTabBarController.index = value;
              });
            },
          ),
          body: _buildPageContent(selectedIndex),
        );
      },
    );
  }

  Widget _buildAuthLoadingScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!authenticationFailed) ...[
              // Loading animation
              Icon(Icons.fingerprint, size: 100, color: Colors.black54),
              const SizedBox(height: 20),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.lightTheme.primaryColor),
              ),
              const SizedBox(height: 20),
            ] else ...[
              // Error state
              Icon(Icons.error_outline, size: 100, color: Colors.red),
              const SizedBox(height: 20),
            ],
            Text(
              authMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: authenticationFailed ? Colors.red : Colors.black54,
              ),
            ),
            if (authenticationFailed) ...[
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _retryAuthentication,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.lightTheme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Retry"),
                  ),
                  ElevatedButton(
                    onPressed: _skipAuthentication,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Skip"),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return DashboardScreen();
      case 1:
        return MarketScreen();
      case 2:
        return PortfolioScreen();
      case 3:
        return InvestorScreen();
      default:
        return DashboardScreen();
    }
  }
}