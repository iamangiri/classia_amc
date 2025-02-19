import 'package:classia_amc/blocs/home/home_event.dart';
import 'package:classia_amc/blocs/home/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<LoadDashboardData>((event, emit) async {
      emit(DashboardLoading());
      // Simulate API call
      await Future.delayed(Duration(seconds: 2));
      emit(DashboardLoaded(
        sliderImages: [
          'https://via.placeholder.com/800x400',
          'https://via.placeholder.com/800x400',
        ],
        totalAssets: '\$10,000,000',
        nav: '\$1,500',
        recentActivities: [
          'Asset A updated',
          'Asset B added',
          'NAV increased by 2%',
        ],
      ));
    });
  }
}