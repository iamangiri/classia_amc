import 'package:classia_amc/blocs/home/home_bloc.dart';
import 'package:classia_amc/themes/light_app_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../blocs/home/home_event.dart';
import '../blocs/home/home_state.dart';
import '../widgets/home_assets_graph.dart';
import '../widgets/home_overview.dart';
import '../widgets/home_recent_activity.dart';
import '../widgets/home_slider.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.lightTheme.primaryColor,
          centerTitle: true, // Centers the title for a modern look
          leading: IconButton(
            icon: FaIcon(FontAwesomeIcons.userCircle, color: Colors.white, size: 22), // Profile Icon on the left
            onPressed: () {
              // Navigate to Profile Screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()), // Replace with actual profile screen
              );
            },
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [

              Text(
                "Dashboard",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: FaIcon(FontAwesomeIcons.bell, color: Colors.white, size: 22), // Notification Icon on the right
              onPressed: () {
                // // Navigate to Notifications Screen
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => NotificationScreen()), // Replace with actual notifications screen
                // );
              },
            ),
          ],
        ),
      body: BlocProvider(
        create: (context) => DashboardBloc()..add(LoadDashboardData()),
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is DashboardLoaded) {
              // Mock data for the graph
              final graphData = {
                'totalAssets': [
                  FlSpot(0, 1000),
                  FlSpot(1, 1200),
                  FlSpot(2, 1100),
                  FlSpot(3, 1300),
                ],
                'nav': [
                  FlSpot(0, 1500),
                  FlSpot(1, 1600),
                  FlSpot(2, 1550),
                  FlSpot(3, 1700),
                ],
                'lotValue': [
                  FlSpot(0, 1500),
                  FlSpot(1, 1400),
                  FlSpot(2, 1450),
                  FlSpot(3, 1600),
                ],
              };

              return SingleChildScrollView(
                child: Column(
                  children: [
                    buildSlider(state.sliderImages),
                    buildOverview(state.totalAssets, state.nav, state.lotValue),
                    AssetGraph(
                      data: graphData,
                      selectedFilter: '1 Month', // Default filter
                    ),
                    buildRecentActivities(state.recentActivities),
                  ],
                ),
              );
            } else {
              return Center(child: Text('Something went wrong!'));
            }
          },
        ),
      ),
    );
  }
}