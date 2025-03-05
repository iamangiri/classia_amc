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
import '../widgets/home_show_prediction_dilog.dart';
import '../widgets/home_slider.dart';
import 'profile_screen.dart';
import 'userprofile/notification_screen.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.primaryColor,
        centerTitle: true,
        leading: IconButton(
          icon: FaIcon(FontAwesomeIcons.userCircle, color: Colors.white, size: 22),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          },
        ),
        title: Text(
          "Dashboard",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: FaIcon(FontAwesomeIcons.bell, color: Colors.white, size: 22),
            onPressed: () {
              // Handle notification button press
              Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen()));
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
                'unitValue': [
                  FlSpot(0, 1500),
                  FlSpot(1, 1400),
                  FlSpot(2, 1450),
                  FlSpot(3, 1600),
                ],
              };

              // Mock data for recent predictions
              final predictions = [
                {
                  'date': '2024-01-01',
                  'predictedPoints': '100',
                  'achievedPoints': '95',
                },
                {
                  'date': '2024-01-02',
                  'predictedPoints': '120',
                  'achievedPoints': '110',
                },
                {
                  'date': '2024-01-03',
                  'predictedPoints': '90',
                  'achievedPoints': '85',
                },
              ];

              return SingleChildScrollView(
                child: Column(
                  children: [
                    buildSlider(state.sliderImages),
                    buildOverview(state.totalAssets, state.nav, state.unitValue),
                    AssetGraph(
                      data: graphData,
                      selectedFilter: '1 Month', // Default filter
                    ),
                    buildRecentPredictions(predictions), // Updated section
                  ],
                ),
              );
            } else {
              return Center(child: Text('Something went wrong!'));
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddPredictionDialog(context); // Show the popup form
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: AppTheme.lightTheme.primaryColor, // Use theme color
      ),
    );
  }
}