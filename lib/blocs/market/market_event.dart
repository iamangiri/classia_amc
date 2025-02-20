import 'package:equatable/equatable.dart';

abstract class MarketEvent extends Equatable {
  const MarketEvent();

  @override
  List<Object> get props => [];
}

class LoadMarketData extends MarketEvent {}

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