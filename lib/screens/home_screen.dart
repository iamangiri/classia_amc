import 'package:classia_amc/blocs/home/home_bloc.dart';
import 'package:classia_amc/themes/light_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../blocs/home/home_event.dart';
import '../blocs/home/home_state.dart';
import '../widgets/home_overview.dart';
import '../widgets/home_recent_activity.dart';
import '../widgets/home_slider.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Classia AMC Dashboard'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
      body: BlocProvider(
        create: (context) => DashboardBloc()..add(LoadDashboardData()),
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is DashboardLoaded) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    buildSlider(state.sliderImages),
                    buildOverview(state.totalAssets, state.nav),
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