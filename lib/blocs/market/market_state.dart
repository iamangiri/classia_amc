import 'package:equatable/equatable.dart';

abstract class MarketState extends Equatable {
  const MarketState();

  @override
  List<Object?> get props => [];
}

class MarketLoading extends MarketState {}

class MarketLoaded extends MarketState {
  final List<Map<String, dynamic>> companies;
  final List<Map<String, dynamic>> originalCompanies;
  final List<String> selectedCompanies;
  final String? searchQuery;
  final String? filterExchange;

  MarketLoaded({
    required this.companies,
    required this.originalCompanies,
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
      originalCompanies: originalCompanies,
      selectedCompanies: selectedCompanies ?? this.selectedCompanies,
      searchQuery: searchQuery ?? this.searchQuery,
      filterExchange: filterExchange ?? this.filterExchange,
    );
  }

  @override
  List<Object?> get props => [companies, originalCompanies, selectedCompanies, searchQuery, filterExchange];
}

class MarketError extends MarketState {
  final String message;

  MarketError(this.message);

  @override
  List<Object?> get props => [message];
}