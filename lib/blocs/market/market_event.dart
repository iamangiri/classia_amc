import 'package:equatable/equatable.dart';

abstract class MarketEvent extends Equatable {
  const MarketEvent();

  @override
  List<Object> get props => [];
}

// market_event.dart
class LoadMarketData extends MarketEvent {
  final int page;
  final int limit;
  const LoadMarketData({required this.page, required this.limit});
  @override List<Object> get props => [page, limit];
}

class SearchCompany extends MarketEvent {
  final String query;

  const SearchCompany(this.query);

  @override
  List<Object> get props => [query];
}

class FilterByExchange extends MarketEvent {
  final String exchange;

  const FilterByExchange(this.exchange);

  @override
  List<Object> get props => [exchange];
}

class ToggleCompanySelection extends MarketEvent {
  final String companyId;

  const ToggleCompanySelection(this.companyId);

  @override
  List<Object> get props => [companyId];
}