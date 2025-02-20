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

  PortfolioLoaded({
    required this.accountName,
    required this.accountManager,
    required this.currentNAV,
    required this.companies,
  });

  // Add the copyWith method
  PortfolioLoaded copyWith({
    String? accountName,
    String? accountManager,
    double? currentNAV,
    List<Map<String, dynamic>>? companies,
  }) {
    return PortfolioLoaded(
      accountName: accountName ?? this.accountName,
      accountManager: accountManager ?? this.accountManager,
      currentNAV: currentNAV ?? this.currentNAV,
      companies: companies ?? this.companies,
    );
  }

  @override
  List<Object?> get props => [accountName, accountManager, currentNAV, companies];
}
