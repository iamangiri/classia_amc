import 'package:equatable/equatable.dart';

abstract class PortfolioEvent extends Equatable {
  const PortfolioEvent();

  @override
  List<Object> get props => [];
}

// Load Portfolio Data
class LoadPortfolioData extends PortfolioEvent {}

// Add Company (Handles Quantity)
class AddCompanyToPortfolio extends PortfolioEvent {
  final Map<String, dynamic> company;

  const AddCompanyToPortfolio(this.company);

  @override
  List<Object> get props => [company];
}

// 📌 Remove Company (Only removes if quantity reaches 0)
class RemoveCompanyFromPortfolio extends PortfolioEvent {
  final String companyId;

  const RemoveCompanyFromPortfolio(this.companyId);

  @override
  List<Object> get props => [companyId];
}

// 📌 Increase Quantity
class IncreaseCompanyQuantity extends PortfolioEvent {
  final String companyId;

  const IncreaseCompanyQuantity(this.companyId);

  @override
  List<Object> get props => [companyId];
}

// 📌 Decrease Quantity (Removes if 0)
class DecreaseCompanyQuantity extends PortfolioEvent {
  final String companyId;

  const DecreaseCompanyQuantity(this.companyId);

  @override
  List<Object> get props => [companyId];
}
