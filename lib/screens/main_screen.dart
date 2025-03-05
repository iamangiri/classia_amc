import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';
import '../blocs/main_screen/main_screen_bloc.dart';
import '../blocs/main_screen/main_screen_event.dart';
import '../blocs/main_screen/main_screen_state.dart';
import '../service/local_auth_service.dart';
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
    bool isAuthenticated = await _localAuthService.authenticate();

    if (!isAuthenticated) {
      Navigator.pop(context);
      return;
    }

    setState(() {
      isAuthenticating = false;
    });

  }



  @override
  Widget build(BuildContext context) {
    if (isAuthenticating) {
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
            tabIconColor: Colors.blue[600],
            tabIconSize: 28.0,
            tabIconSelectedSize: 26.0,
            tabSelectedColor: Colors.blue[900],
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
            Icon(Icons.fingerprint, size: 100, color:Colors.black54),
            SizedBox(height: 10),
            Text("Authenticating...", style: TextStyle(fontSize: 18, color: Colors.white70)),
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