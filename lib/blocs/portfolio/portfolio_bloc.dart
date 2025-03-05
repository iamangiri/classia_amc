import 'package:classia_amc/blocs/portfolio/portfolio_event.dart';
import 'package:classia_amc/blocs/portfolio/portfolio_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../service/alpha_vantage_service.dart';
import '../market/database_service.dart';

class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  final DatabaseService _databaseService = DatabaseService();
  final AlphaVantageService _alphaVantageService = AlphaVantageService();

  PortfolioBloc() : super(PortfolioLoading()) {
    on<LoadPortfolioData>(_onLoadPortfolioData);
    on<AddCompanyToPortfolio>(_onAddCompanyToPortfolio);
    on<RemoveCompanyFromPortfolio>(_onRemoveCompanyFromPortfolio);
    on<IncreaseCompanyQuantity>(_onIncreaseCompanyQuantity);
    on<DecreaseCompanyQuantity>(_onDecreaseCompanyQuantity);
  }

  // 📌 Load Portfolio Data
  void _onLoadPortfolioData(LoadPortfolioData event, Emitter<PortfolioState> emit) async {
    emit(PortfolioLoading());
    final companies = await _databaseService.getSelectedCompanies();

    // Fetch real-time prices for all companies
    final updatedCompanies = await _updateCompanyPrices(companies);

    double predictedJockeyPoint = _calculatePredictedJockeyPoint(companies.length);

    emit(PortfolioLoaded(
      accountName: "ICICI Prudential Mutual Fund",
      accountManager: "Aman Giri",
      amcImage: "https://sampleimageurl.com",
      managerImage: "https://sampleimageurl.com",
      currentNAV: _calculateNAV(updatedCompanies),
      unit : 123,
      companies: updatedCompanies,
      joycePoint: 3.4,
      predictedJockeyPoint: predictedJockeyPoint,

    ));
  }


  // 📌 Update company prices using Alpha Vantage
  Future<List<Map<String, dynamic>>> _updateCompanyPrices(List<Map<String, dynamic>> companies) async {
    final updatedCompanies = <Map<String, dynamic>>[];

    for (final company in companies) {
      final symbol = '${company['symbol']}.BSE'; // Append .BSE for Indian stocks
      final price = await _alphaVantageService.getStockPrice(symbol);
      updatedCompanies.add({...company, 'price': price});
    }

    return updatedCompanies;
  }

  // 📌 Calculate NAV
  double _calculateNAV(List<Map<String, dynamic>> companies) {
    return companies.fold(0, (sum, company) {
      return sum + (company['price'] * company['quantity']);
    });
  }

  // 📌 Add Company to Portfolio
  void _onAddCompanyToPortfolio(AddCompanyToPortfolio event, Emitter<PortfolioState> emit) async {
    final state = this.state as PortfolioLoaded;
    await _databaseService.insertOrUpdateCompany(event.company);

    final updatedCompanies = await _databaseService.getSelectedCompanies();
    final updatedCompaniesWithPrices = await _updateCompanyPrices(updatedCompanies);
    final newNAV = _calculateNAV(updatedCompaniesWithPrices);

    emit(state.copyWith(companies: updatedCompaniesWithPrices, currentNAV: newNAV));
  }

  void _onRemoveCompanyFromPortfolio(RemoveCompanyFromPortfolio event, Emitter<PortfolioState> emit) async {
    final state = this.state as PortfolioLoaded;
    await _databaseService.deleteCompany(event.companyId);

    final updatedCompanies = await _databaseService.getSelectedCompanies();
    final updatedCompaniesWithPrices = await _updateCompanyPrices(updatedCompanies);
    final newNAV = _calculateNAV(updatedCompaniesWithPrices);

    emit(state.copyWith(companies: updatedCompaniesWithPrices, currentNAV: newNAV));
  }

  // 📌 Increase Quantity
  void _onIncreaseCompanyQuantity(IncreaseCompanyQuantity event, Emitter<PortfolioState> emit) async {
    final state = this.state as PortfolioLoaded;
    print("🔺 Increasing quantity for company ID: ${event.companyId}");

    await _databaseService.updateCompanyQuantity(event.companyId, 1); // Increase quantity by 1

    final updatedCompanies = await _databaseService.getSelectedCompanies();
    final updatedCompaniesWithPrices = await _updateCompanyPrices(updatedCompanies);
    final newNAV = _calculateNAV(updatedCompaniesWithPrices);

    emit(state.copyWith(
      companies: updatedCompaniesWithPrices,
      currentNAV: newNAV,
      unit: _calculateUnitValue(newNAV), // Update unit value
      predictedJockeyPoint: _calculatePredictedJockeyPoint(updatedCompaniesWithPrices.length), // Update predicted value
    ));
    print("✅ Quantity increased successfully");
  }

  // 📌 Decrease Quantity (Removes if 0)
  void _onDecreaseCompanyQuantity(DecreaseCompanyQuantity event, Emitter<PortfolioState> emit) async {
    final state = this.state as PortfolioLoaded;
    print("🔻 Decreasing quantity for company ID: ${event.companyId}");

    await _databaseService.updateCompanyQuantity(event.companyId, -1); // Decrease quantity by 1

    final updatedCompanies = await _databaseService.getSelectedCompanies();
    final updatedCompaniesWithPrices = await _updateCompanyPrices(updatedCompanies);
    final newNAV = _calculateNAV(updatedCompaniesWithPrices);

    emit(state.copyWith(
      companies: updatedCompaniesWithPrices,
      currentNAV: newNAV,
      unit: _calculateUnitValue(newNAV), // Update unit value
      predictedJockeyPoint: _calculatePredictedJockeyPoint(updatedCompaniesWithPrices.length), // Update predicted value
    ));
    print("✅ Quantity decreased successfully");
  }


  // 📌 Predict Jockey Point based on number of selected companies
  double _calculatePredictedJockeyPoint(int companyCount) {
    return (companyCount * 0.5).clamp(0, 10); // Example calculation
  }


  // 📌 Calculate Unit Value (Example calculation)
  double _calculateUnitValue(double nav) {
    return nav / 100; // Replace with your actual calculation
  }

}
