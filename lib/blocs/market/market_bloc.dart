import 'package:flutter_bloc/flutter_bloc.dart';
import 'market_event.dart';
import 'market_state.dart';
import 'database_service.dart';

class MarketBloc extends Bloc<MarketEvent, MarketState> {
  final DatabaseService _databaseService = DatabaseService();

  MarketBloc() : super(MarketLoading()) {
    on<LoadMarketData>(_onLoadMarketData);
    on<SearchCompany>(_onSearchCompany);
    on<FilterByExchange>(_onFilterByExchange);
    on<ToggleCompanySelection>(_onToggleCompanySelection);
  }

  void _onLoadMarketData(LoadMarketData event, Emitter<MarketState> emit) async {
    emit(MarketLoading());

    await Future.delayed(Duration(seconds: 2)); // Simulate API delay
    final companies = [
      {"id": "1", "name": "Reliance Industries", "symbol": "RELIANCE", "exchange": "NSE"},
      {"id": "2", "name": "Tata Motors", "symbol": "TATAMOTORS", "exchange": "NSE"},
      {"id": "3", "name": "Infosys", "symbol": "INFY", "exchange": "BSE"},
      {"id": "4", "name": "HDFC Bank", "symbol": "HDFCBANK", "exchange": "NSE"},
      {"id": "5", "name": "ICICI Bank", "symbol": "ICICIBANK", "exchange": "BSE"},
      {"id": "6", "name": "Larsen & Toubro", "symbol": "LT", "exchange": "NSE"},
      {"id": "7", "name": "State Bank of India", "symbol": "SBIN", "exchange": "BSE"},
      {"id": "8", "name": "Bharti Airtel", "symbol": "BHARTIARTL", "exchange": "NSE"},
      {"id": "9", "name": "Maruti Suzuki", "symbol": "MARUTI", "exchange": "BSE"},
      {"id": "10", "name": "Wipro", "symbol": "WIPRO", "exchange": "NSE"},
    ];

    final selectedCompanies = await _databaseService.getSelectedCompanies();
    final selectedIds = selectedCompanies.map((c) => c["id"] as String).toList();

    emit(MarketLoaded(
      companies: companies,
      selectedCompanies: selectedIds,
      originalCompanies: companies,
    ));
  }

  void _onSearchCompany(SearchCompany event, Emitter<MarketState> emit) {
    final state = this.state as MarketLoaded;
    final filteredCompanies = state.originalCompanies.where((company) {
      return company["name"].toLowerCase().contains(event.query.toLowerCase());
    }).toList();

    emit(state.copyWith(companies: filteredCompanies, searchQuery: event.query));
  }

  void _onFilterByExchange(FilterByExchange event, Emitter<MarketState> emit) {
    final state = this.state as MarketLoaded;
    final filteredCompanies = event.exchange == "All"
        ? state.originalCompanies
        : state.originalCompanies.where((company) => company["exchange"] == event.exchange).toList();

    emit(state.copyWith(companies: filteredCompanies, filterExchange: event.exchange));
  }

  void _onToggleCompanySelection(ToggleCompanySelection event, Emitter<MarketState> emit) async {
    final state = this.state as MarketLoaded;
    final selectedCompanies = List<String>.from(state.selectedCompanies);
    final company = state.originalCompanies.firstWhere((c) => c["id"] == event.companyId);

    if (selectedCompanies.contains(event.companyId)) {
      selectedCompanies.remove(event.companyId);
      await _databaseService.deleteCompany(event.companyId);
    } else {
      selectedCompanies.add(event.companyId);
      await _databaseService.insertOrUpdateCompany(company);
    }

    emit(state.copyWith(selectedCompanies: selectedCompanies));
  }
}