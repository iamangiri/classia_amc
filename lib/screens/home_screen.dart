import 'package:classia_amc/blocs/home/home_bloc.dart';
import 'package:classia_amc/themes/light_app_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/home/home_event.dart';
import '../blocs/home/home_state.dart';
import '../widgets/home_assets_graph.dart';
import '../widgets/home_overview.dart';
import '../widgets/home_recent_activity.dart';
import '../widgets/home_slider.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Classia AMC Dashboard',
          style: TextStyle(color: AppTheme.lightTheme.scaffoldBackgroundColor),
        ),
        backgroundColor: AppTheme.lightTheme.primaryColor,
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