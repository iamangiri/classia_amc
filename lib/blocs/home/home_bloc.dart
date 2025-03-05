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
          'https://static.investindia.gov.in/s3fs-public/2020-07/shutterstock_513452020.jpg',
          'https://thumbor.forbes.com/thumbor/fit-in/900x510/https://www.forbes.com/advisor/in/wp-content/uploads/2024/06/shutterstock_2090719507.png',
          'https://akm-img-a-in.tosshub.com/indiatoday/images/story/202412/stock-market--------5-ipo-190424863-16x9.jpg?VersionId=OMlP0Y0SoSGm1tHa1NBA47qo8_NXOKNJ&size=690:388',
          'https://blogassets.leverageedu.com/media/uploads/2023/06/29111936/stock-market.jpg',
        ],
        totalAssets: '\$10,000,000',
        nav: '\$1,500',
        unitValue: '\$1,500',
        recentActivities: [
          'Asset A updated',
          'Asset B added',
          'NAV increased by 2%',
        ],
      ));
    });
  }
}