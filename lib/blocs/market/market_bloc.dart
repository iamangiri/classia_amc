import 'package:flutter_bloc/flutter_bloc.dart';
import 'market_api_service.dart';
import 'market_event.dart';
import 'market_state.dart';

class MarketBloc extends Bloc<MarketEvent, MarketState> {
  final MarketApiService _apiService = MarketApiService();

  MarketBloc() : super(MarketLoading()) {
    on<LoadMarketData>(_onLoadMarketData);
    on<SearchCompany>(_onSearchCompany);
    on<FilterByExchange>(_onFilterByExchange);
    on<ToggleCompanySelection>(_onToggleCompanySelection);
  }

  void _onLoadMarketData(LoadMarketData event, Emitter<MarketState> emit) async {
    emit(MarketLoading());

    try {
      // Fetch stocks from API
      final stocks = await _apiService.fetchStockData(1, 500);
      // Map API response to match existing company structure
      final companies = stocks.map((stock) => {
        'id': stock['ID'].toString(),
        'name': stock['Name'].toString(),
        'symbol': stock['Symbol'].toString(),
        'exchange': stock['Exchange'].toString(),
      }).toList();

      emit(MarketLoaded(
        companies: companies,
        selectedCompanies: [], // No local storage, so start empty
        originalCompanies: companies,
      ));
    } catch (e) {
      emit(MarketError('Failed to load market data: ${e.toString()}'));
    }
  }

  void _onSearchCompany(SearchCompany event, Emitter<MarketState> emit) {
    final state = this.state as MarketLoaded;
    final filteredCompanies = state.originalCompanies.where((company) {
      return company['name'].toLowerCase().contains(event.query.toLowerCase());
    }).toList();

    emit(state.copyWith(companies: filteredCompanies, searchQuery: event.query));
  }

  void _onFilterByExchange(FilterByExchange event, Emitter<MarketState> emit) {
    final state = this.state as MarketLoaded;
    final filteredCompanies = event.exchange == 'All'
        ? state.originalCompanies
        : state.originalCompanies.where((company) => company['exchange'] == event.exchange).toList();

    emit(state.copyWith(companies: filteredCompanies, filterExchange: event.exchange));
  }

  void _onToggleCompanySelection(ToggleCompanySelection event, Emitter<MarketState> emit) async {
    final state = this.state as MarketLoaded;
    final selectedCompanies = List<String>.from(state.selectedCompanies);
    final isSelected = selectedCompanies.contains(event.companyId);

    try {
      // Call API to toggle selection
      await _apiService.toggleStockSelection(event.companyId, isSelected);

      // Update selected companies list
      if (isSelected) {
        selectedCompanies.remove(event.companyId);
      } else {
        selectedCompanies.add(event.companyId);
      }

      emit(state.copyWith(selectedCompanies: selectedCompanies));
    } catch (e) {
      emit(MarketError('Failed to toggle stock: ${e.toString()}'));
    }
  }
}