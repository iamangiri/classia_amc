import 'package:equatable/equatable.dart';

abstract class PortfolioState extends Equatable {
  const PortfolioState();

  @override
  List<Object?> get props => [];
}

class PortfolioLoading extends PortfolioState {}

class PortfolioLoaded extends PortfolioState {
  final String accountName;
  final String accountManager;
  final String amcImage; // AMC Logo Image
  final String managerImage; // Manager Profile Image
  final double currentNAV;
  final List<Map<String, dynamic>> companies;
  final double joycePoint;
  final double predictedJockeyPoint;

  PortfolioLoaded({
    required this.accountName,
    required this.accountManager,
    required this.amcImage,
    required this.managerImage,
    required this.currentNAV,
    required this.companies,
    required this.joycePoint,
    required this.predictedJockeyPoint,
  });

  // Updated copyWith method to include new fields
  PortfolioLoaded copyWith({
    String? accountName,
    String? accountManager,
    String? amcImage,
    String? managerImage,
    double? currentNAV,
    List<Map<String, dynamic>>? companies,
    double? joycePoint,
    double? predictedJockeyPoint,
  }) {
    return PortfolioLoaded(
      accountName: accountName ?? this.accountName,
      accountManager: accountManager ?? this.accountManager,
      amcImage: amcImage ?? this.amcImage,
      managerImage: managerImage ?? this.managerImage,
      currentNAV: currentNAV ?? this.currentNAV,
      companies: companies ?? this.companies,
      joycePoint: joycePoint ?? this.joycePoint,
      predictedJockeyPoint: predictedJockeyPoint ?? this.predictedJockeyPoint,
    );
  }

  @override
  List<Object?> get props => [
    accountName,
    accountManager,
    amcImage,
    managerImage,
    currentNAV,
    companies,
    joycePoint,
    predictedJockeyPoint,
  ];
}
