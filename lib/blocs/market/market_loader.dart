import 'package:equatable/equatable.dart';
import 'market_state.dart';

class MarketLoaded extends MarketState {
  final List<Map<String, dynamic>> companies;
  final List<Map<String, dynamic>> originalCompanies; // Store full list
  final List<String> selectedCompanies;
  final String? searchQuery;
  final String? filterExchange;

  MarketLoaded({
    required this.companies,
    required this.originalCompanies, // Initialize full list
    required this.selectedCompanies,
    this.searchQuery,
    this.filterExchange,
  });

  MarketLoaded copyWith({
    List<Map<String, dynamic>>? companies,
    List<String>? selectedCompanies,
    String? searchQuery,
    String? filterExchange,
  }) {
    return MarketLoaded(
      companies: companies ?? this.companies,
      originalCompanies: originalCompanies, // Ensure full list persists
      selectedCompanies: selectedCompanies ?? this.selectedCompanies,
      searchQuery: searchQuery ?? this.searchQuery,
      filterExchange: filterExchange ?? this.filterExchange,
    );
  }

  @override
  List<Object?> get props => [companies, originalCompanies, selectedCompanies, searchQuery, filterExchange];
}
