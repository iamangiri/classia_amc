import 'package:classia_amc/blocs/portfolio/portfolio_event.dart';
import 'package:classia_amc/blocs/portfolio/portfolio_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../market/database_service.dart';

class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  final DatabaseService _databaseService = DatabaseService();

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
    print("🔄 Loading portfolio data...");

    await Future.delayed(Duration(seconds: 2));

    final companies = await _databaseService.getSelectedCompanies();
    print("📊 Fetched ${companies.length} companies from the database");

    double predictedJockeyPoint = _calculatePredictedJockeyPoint(companies.length);

    emit(PortfolioLoaded(
      accountName: "ICICI Prudential Mutual Fund",
      accountManager: "Aman Giri",
      amcImage: "https://sampleimageurl.com",
      managerImage: "https://sampleimageurl.com",
      currentNAV: 1500000.0,
      companies: companies,
      joycePoint: 3.4,
      predictedJockeyPoint: predictedJockeyPoint,
    ));
    print("✅ Portfolio data loaded successfully");
  }

  // 📌 Add Company to Portfolio (Handles Quantity)
  void _onAddCompanyToPortfolio(AddCompanyToPortfolio event, Emitter<PortfolioState> emit) async {
    final state = this.state as PortfolioLoaded;
    print("➕ Adding company: ${event.company["name"]}");

    await _databaseService.insertOrUpdateCompany(event.company); // Update quantity instead of inserting duplicate

    final updatedCompanies = await _databaseService.getSelectedCompanies();
    double updatedPrediction = _calculatePredictedJockeyPoint(updatedCompanies.length);

    emit(state.copyWith(companies: updatedCompanies, predictedJockeyPoint: updatedPrediction));
    print("✅ Company added successfully");
  }

  // 📌 Remove Company (Only removes if quantity reaches 0)
  void _onRemoveCompanyFromPortfolio(RemoveCompanyFromPortfolio event, Emitter<PortfolioState> emit) async {
    final state = this.state as PortfolioLoaded;
    print("❌ Removing company with ID: ${event.companyId}");

    await _databaseService.deleteCompany(event.companyId);

    final updatedCompanies = await _databaseService.getSelectedCompanies();
    double updatedPrediction = _calculatePredictedJockeyPoint(updatedCompanies.length);

    emit(state.copyWith(companies: updatedCompanies, predictedJockeyPoint: updatedPrediction));
    print("✅ Company removed successfully");
  }

  // 📌 Increase Quantity
  void _onIncreaseCompanyQuantity(IncreaseCompanyQuantity event, Emitter<PortfolioState> emit) async {
    final state = this.state as PortfolioLoaded;
    print("🔺 Increasing quantity for company ID: ${event.companyId}");

    await _databaseService.updateCompanyQuantity(event.companyId, 1); // Increase quantity by 1

    final updatedCompanies = await _databaseService.getSelectedCompanies();
    emit(state.copyWith(companies: updatedCompanies));
    print("✅ Quantity increased successfully");
  }

  // 📌 Decrease Quantity (Removes if 0)
  void _onDecreaseCompanyQuantity(DecreaseCompanyQuantity event, Emitter<PortfolioState> emit) async {
    final state = this.state as PortfolioLoaded;
    print("🔻 Decreasing quantity for company ID: ${event.companyId}");

    await _databaseService.updateCompanyQuantity(event.companyId, -1); // Decrease quantity by 1

    final updatedCompanies = await _databaseService.getSelectedCompanies();
    emit(state.copyWith(companies: updatedCompanies));
    print("✅ Quantity decreased successfully");
  }

  // 📌 Predict Jockey Point based on number of selected companies
  double _calculatePredictedJockeyPoint(int companyCount) {
    return (companyCount * 0.5).clamp(0, 10); // Example calculation
  }
}
