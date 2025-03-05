import 'package:equatable/equatable.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final List<String> sliderImages;
  final String totalAssets;
  final String nav;
  final String unitValue;
  final List<String> recentActivities;

  const DashboardLoaded({
    required this.sliderImages,
    required this.totalAssets,
    required this.nav,
    required this.unitValue,
    required this.recentActivities,
  });

  @override
  List<Object> get props => [sliderImages, totalAssets, nav, recentActivities];
}