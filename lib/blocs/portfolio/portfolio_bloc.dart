import 'package:flutter_bloc/flutter_bloc.dart';

import 'portfolio_event.dart';
import 'portfolio_state.dart';

class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  PortfolioBloc() : super(PortfolioLoading()) {
    on<LoadPortfolioData>(_onLoadPortfolioData);
    on<AddCompanyToPortfolio>(_onAddCompanyToPortfolio);
    on<RemoveCompanyFromPortfolio>(_onRemoveCompanyFromPortfolio);
  }

  void _onLoadPortfolioData(LoadPortfolioData event, Emitter<PortfolioState> emit) async {
    // Simulate API call to fetch portfolio data
    await Future.delayed(Duration(seconds: 2));
    emit(PortfolioLoaded(
      accountName: "ICICI Prudential Mutual Fund",
      accountManager: "Aman Giri",
      currentNAV: 1500000.0,
      companies: [
        {"id": "1", "name": "Reliance Industries", "symbol": "RELIANCE", "navContribution": 500000.0},
        {"id": "2", "name": "Tata Motors", "symbol": "TATAMOTORS", "navContribution": 300000.0},
      ], joycePoint: 3.4,
    ));
  }

  void _onAddCompanyToPortfolio(AddCompanyToPortfolio event, Emitter<PortfolioState> emit) {
    final state = this.state as PortfolioLoaded;
    final updatedCompanies = List<Map<String, dynamic>>.from(state.companies)..add(event.company);
    emit(state.copyWith(companies: updatedCompanies));
  }

  void _onRemoveCompanyFromPortfolio(RemoveCompanyFromPortfolio event, Emitter<PortfolioState> emit) {
    final state = this.state as PortfolioLoaded;
    final updatedCompanies = state.companies.where((company) => company["id"] != event.companyId).toList();
    emit(state.copyWith(companies: updatedCompanies));
  }
}