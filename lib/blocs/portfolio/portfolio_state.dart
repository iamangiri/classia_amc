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
  final double currentNAV;
  final List<Map<String, dynamic>> companies;
  final double joycePoint;

  PortfolioLoaded({
    required this.accountName,
    required this.accountManager,
    required this.currentNAV,
    required this.companies,
    required this.joycePoint,
  });

  // Add the copyWith method
  PortfolioLoaded copyWith({
    String? accountName,
    String? accountManager,
    double? currentNAV,
    List<Map<String, dynamic>>? companies,
    double? joycePoint,
  }) {
    return PortfolioLoaded(
      accountName: accountName ?? this.accountName,
      accountManager: accountManager ?? this.accountManager,
      currentNAV: currentNAV ?? this.currentNAV,
      companies: companies ?? this.companies,
      joycePoint: joycePoint ?? this.joycePoint,
    );
  }

  @override
  List<Object?> get props => [accountName, accountManager, currentNAV, companies, joycePoint];
}
