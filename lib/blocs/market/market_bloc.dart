import 'package:flutter_bloc/flutter_bloc.dart';
import 'market_event.dart';
import 'market_state.dart';

class MarketBloc extends Bloc<MarketEvent, MarketState> {
  MarketBloc() : super(MarketLoading()) {
    on<LoadMarketData>(_onLoadMarketData);
    on<SearchCompany>(_onSearchCompany);
    on<FilterByExchange>(_onFilterByExchange);
    on<ToggleCompanySelection>(_onToggleCompanySelection);
  }

  void _onLoadMarketData(LoadMarketData event, Emitter<MarketState> emit) async {
    emit(MarketLoading()); // Show loading indicator before fetching data

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


    emit(MarketLoaded(companies: companies, selectedCompanies: []));
  }

  void _onSearchCompany(SearchCompany event, Emitter<MarketState> emit) {
    final state = this.state as MarketLoaded;
    final filteredCompanies = state.companies.where((company) {
      return company["name"].toLowerCase().contains(event.query.toLowerCase());
    }).toList();

    emit(state.copyWith(
      companies: filteredCompanies, // Update the companies list with search results
      searchQuery: event.query,
    ));
  }

  void _onFilterByExchange(FilterByExchange event, Emitter<MarketState> emit) {
  final state = this.state as MarketLoaded;

  // Check if "All" is selected; if so, show the full list
  final filteredCompanies = event.exchange == "All"
      ? state.companies // Show all companies
      : state.companies.where((company) => company["exchange"] == event.exchange).toList();

  emit(state.copyWith(
    companies: filteredCompanies, // Update the companies list
    filterExchange: event.exchange,
  ));
}


  void _onToggleCompanySelection(ToggleCompanySelection event, Emitter<MarketState> emit) {
    final state = this.state as MarketLoaded;
    final selectedCompanies = List<String>.from(state.selectedCompanies);
    if (selectedCompanies.contains(event.companyId)) {
      selectedCompanies.remove(event.companyId);
    } else {
      selectedCompanies.add(event.companyId);
    }
    emit(state.copyWith(selectedCompanies: selectedCompanies));
  }
}