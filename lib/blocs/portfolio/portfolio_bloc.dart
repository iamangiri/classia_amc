import 'package:flutter_bloc/flutter_bloc.dart';
import '../market/database_service.dart';
import 'portfolio_event.dart';
import 'portfolio_state.dart';


class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  final DatabaseService _databaseService = DatabaseService();

  PortfolioBloc() : super(PortfolioLoading()) {
    on<LoadPortfolioData>(_onLoadPortfolioData);
    on<AddCompanyToPortfolio>(_onAddCompanyToPortfolio);
    on<RemoveCompanyFromPortfolio>(_onRemoveCompanyFromPortfolio);
  }

  void _onLoadPortfolioData(LoadPortfolioData event, Emitter<PortfolioState> emit) async {
    emit(PortfolioLoading());

    // Simulate fetching account details
    await Future.delayed(Duration(seconds: 2));

    // Fetch companies from the database
    final companies = await _databaseService.getSelectedCompanies();

    emit(PortfolioLoaded(
      accountName: "ICICI Prudential Mutual Fund",
      accountManager: "Aman Giri",
      currentNAV: 1500000.0,
      companies: companies,
      joycePoint: 3.4,
    ));
  }

  void _onAddCompanyToPortfolio(AddCompanyToPortfolio event, Emitter<PortfolioState> emit) async {
    final state = this.state as PortfolioLoaded;
    await _databaseService.insertCompany(event.company);

    // Fetch updated list from the database
    final updatedCompanies = await _databaseService.getSelectedCompanies();

    emit(state.copyWith(companies: updatedCompanies));
  }

  void _onRemoveCompanyFromPortfolio(RemoveCompanyFromPortfolio event, Emitter<PortfolioState> emit) async {
    final state = this.state as PortfolioLoaded;
    await _databaseService.deleteCompany(event.companyId);

    // Fetch updated list from the database
    final updatedCompanies = await _databaseService.getSelectedCompanies();

    emit(state.copyWith(companies: updatedCompanies));
  }
}