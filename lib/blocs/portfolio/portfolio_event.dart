import 'package:equatable/equatable.dart';

abstract class PortfolioEvent extends Equatable {
  const PortfolioEvent();

  @override
  List<Object> get props => [];
}

class LoadPortfolioData extends PortfolioEvent {}

class AddCompanyToPortfolio extends PortfolioEvent {
  final Map<String, dynamic> company;

  const AddCompanyToPortfolio(this.company);

  @override
  List<Object> get props => [company];
}

class RemoveCompanyFromPortfolio extends PortfolioEvent {
  final String companyId;

  const RemoveCompanyFromPortfolio(this.companyId);

  @override
  List<Object> get props => [companyId];
}