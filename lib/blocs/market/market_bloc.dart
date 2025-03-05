import 'package:flutter_bloc/flutter_bloc.dart';
import 'market_company_list.dart';
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


    final selectedCompanies = await _databaseService.getSelectedCompanies();
    final selectedIds = selectedCompanies.map((c) => c["id"] as String).toList();

    emit(MarketLoaded(
      companies: MarketCompany.companies,
      selectedCompanies: selectedIds,
      originalCompanies: MarketCompany.companies,
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
      // Ensure the company map has the correct types
      Map<String, dynamic> companyToInsert = {
        'id': company['id'].toString(),
        'name': company['name'].toString(),
        'symbol': company['symbol'].toString(),
        'exchange': company['exchange'].toString(),
      };
      await _databaseService.insertOrUpdateCompany(companyToInsert);
    }

    emit(state.copyWith(selectedCompanies: selectedCompanies));
  }
}