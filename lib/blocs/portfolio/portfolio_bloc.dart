import 'package:classia_amc/blocs/portfolio/portfolio_event.dart';
import 'package:classia_amc/blocs/portfolio/portfolio_state.dart';
import 'package:classia_amc/utils/constant/user_constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../service/alpha_vantage_service.dart';
import '../market/database_service.dart';
import 'api_service.dart';

class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  final DatabaseService _databaseService = DatabaseService();
  final AlphaVantageService _alphaVantageService = AlphaVantageService();
  final ClassiaApiService _classiaApiService = ClassiaApiService();

  PortfolioBloc() : super(PortfolioLoading()) {
    on<LoadPortfolioData>(_onLoadPortfolioData);
    on<AddCompanyToPortfolio>(_onAddCompanyToPortfolio);
    on<RemoveCompanyFromPortfolio>(_onRemoveCompanyFromPortfolio);
    on<IncreaseCompanyQuantity>(_onIncreaseCompanyQuantity);
    on<DecreaseCompanyQuantity>(_onDecreaseCompanyQuantity);
  }

  // 📌 Load Portfolio Data - Now uses API instead of database
  void _onLoadPortfolioData(LoadPortfolioData event, Emitter<PortfolioState> emit) async {
    emit(PortfolioLoading());

    try {
      // Get picked stocks from API
      final companies = await _classiaApiService.getPickedStockList(limit: 50, page: 1);

      // Fetch real-time prices for all companies
      final updatedCompanies = await _updateCompanyPrices(companies);

      // Calculate NAV
      double currentNAV = _calculateNAV(updatedCompanies);

      // Calculate Unit Price
      double unitPrice = _calculateUnitValue(currentNAV);

      // Calculate Predicted Jockey Point
      double predictedJockeyPoint = _calculatePredictedJockeyPoint(updatedCompanies.length);

      emit(PortfolioLoaded(
        accountName: "${UserConstants.NAME}",
        accountManager: "${UserConstants.CONTACT_PERSON_NAME}",
        amcImage: "https://upload.wikimedia.org/wikipedia/en/thumb/4/44/ICICI_Prudential_Mutual_Fund_Logo.svg/2560px-ICICI_Prudential_Mutual_Fund_Logo.svg.png",
        managerImage: "https://www.icicipruamc.com/content/dam/icici-prudential-website/about-us/leadership/Amit_Ganatra.jpg",
        currentNAV: currentNAV,
        unit: unitPrice,
        companies: updatedCompanies,
        joycePoint: 3.4,
        predictedJockeyPoint: predictedJockeyPoint,
      ));
    } catch (e) {
      print('Error loading portfolio data: $e');
      emit(PortfolioLoaded(
        accountName: "${UserConstants.NAME}",
        accountManager: "${UserConstants.CONTACT_PERSON_NAME}",
        amcImage: "https://upload.wikimedia.org/wikipedia/en/thumb/4/44/ICICI_Prudential_Mutual_Fund_Logo.svg/2560px-ICICI_Prudential_Mutual_Fund_Logo.svg.png",
        managerImage: "https://www.icicipruamc.com/content/dam/icici-prudential-website/about-us/leadership/Amit_Ganatra.jpg",
        currentNAV: 0.0,
        unit: 0.0,
        companies: [],
        joycePoint: 3.4,
        predictedJockeyPoint: 0.0,
      ));
    }
  }

  // 📌 Update company prices using Alpha Vantage
  Future<List<Map<String, dynamic>>> _updateCompanyPrices(List<Map<String, dynamic>> companies) async {
    final updatedCompanies = <Map<String, dynamic>>[];

    for (final company in companies) {
      final symbol = '${company['symbol']}.NSE'; // Use .NSE for Indian stocks from NSE
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

  // 📌 Add Company to Portfolio - Now uses API
  void _onAddCompanyToPortfolio(AddCompanyToPortfolio event, Emitter<PortfolioState> emit) async {
    final state = this.state as PortfolioLoaded;

    // Pick the stock using API
    final success = await _classiaApiService.pickStock(event.company['id']);

    if (success) {
      // Reload the portfolio data from API
      final updatedCompanies = await _classiaApiService.getPickedStockList(limit: 50, page: 1);
      final updatedCompaniesWithPrices = await _updateCompanyPrices(updatedCompanies);
      final newNAV = _calculateNAV(updatedCompaniesWithPrices);

      emit(state.copyWith(
        companies: updatedCompaniesWithPrices,
        currentNAV: newNAV,
        unit: _calculateUnitValue(newNAV),
        predictedJockeyPoint: _calculatePredictedJockeyPoint(updatedCompaniesWithPrices.length),
      ));
    }
  }

  void _onRemoveCompanyFromPortfolio(RemoveCompanyFromPortfolio event, Emitter<PortfolioState> emit) async {
    final state = this.state as PortfolioLoaded;

    // Unpick the stock using API
    final success = await _classiaApiService.unpickStock(event.companyId);

    if (success) {
      // Reload the portfolio data from API
      final updatedCompanies = await _classiaApiService.getPickedStockList(limit: 50, page: 1);
      final updatedCompaniesWithPrices = await _updateCompanyPrices(updatedCompanies);
      final newNAV = _calculateNAV(updatedCompaniesWithPrices);

      emit(state.copyWith(
        companies: updatedCompaniesWithPrices,
        currentNAV: newNAV,
        unit: _calculateUnitValue(newNAV),
        predictedJockeyPoint: _calculatePredictedJockeyPoint(updatedCompaniesWithPrices.length),
      ));
    }
  }

  // 📌 Increase Quantity - Now updates in memory only
  void _onIncreaseCompanyQuantity(IncreaseCompanyQuantity event, Emitter<PortfolioState> emit) async {
    final state = this.state as PortfolioLoaded;
    print("🔺 Increasing quantity for company ID: ${event.companyId}");

    // Update quantity in memory
    final updatedCompanies = state.companies.map((company) {
      if (company['id'] == event.companyId) {
        return {...company, 'quantity': company['quantity'] + 1};
      }
      return company;
    }).toList();

    final newNAV = _calculateNAV(updatedCompanies);

    emit(state.copyWith(
      companies: updatedCompanies,
      currentNAV: newNAV,
      unit: _calculateUnitValue(newNAV),
      predictedJockeyPoint: _calculatePredictedJockeyPoint(updatedCompanies.length),
    ));
    print("✅ Quantity increased successfully");
  }

  // 📌 Decrease Quantity - Now updates in memory only
  // 📌 Decrease Quantity - Now unpicks stock if quantity is 1
  void _onDecreaseCompanyQuantity(DecreaseCompanyQuantity event, Emitter<PortfolioState> emit) async {
    final state = this.state as PortfolioLoaded;
    print("🔻 Decreasing quantity for company ID: ${event.companyId}");

    // Find the company to check its current quantity
    final company = state.companies.firstWhere(
          (company) => company['id'] == event.companyId,
      orElse: () => {},
    );

    if (company.isEmpty) {
      print("❌ Company not found with ID: ${event.companyId}");
      return;
    }

    final currentQuantity = company['quantity'] as int;

    // If quantity is 1, unpick the stock using API
    if (currentQuantity <= 1) {
      print("🚫 Unpicking stock as quantity is 1");

      // Unpick the stock using API
      final success = await _classiaApiService.unpickStock(event.companyId);

      if (success) {
        // Reload the portfolio data from API
        final updatedCompanies = await _classiaApiService.getPickedStockList(limit: 50, page: 1);
        final updatedCompaniesWithPrices = await _updateCompanyPrices(updatedCompanies);
        final newNAV = _calculateNAV(updatedCompaniesWithPrices);

        emit(state.copyWith(
          companies: updatedCompaniesWithPrices,
          currentNAV: newNAV,
          unit: _calculateUnitValue(newNAV),
          predictedJockeyPoint: _calculatePredictedJockeyPoint(updatedCompaniesWithPrices.length),
        ));
        print("✅ Stock unpicked successfully");
      } else {
        print("❌ Failed to unpick stock");
      }
    } else {
      // If quantity > 1, just decrease the quantity in memory
      final updatedCompanies = state.companies.map((company) {
        if (company['id'] == event.companyId) {
          return {...company, 'quantity': company['quantity'] - 1};
        }
        return company;
      }).toList();

      final newNAV = _calculateNAV(updatedCompanies);

      emit(state.copyWith(
        companies: updatedCompanies,
        currentNAV: newNAV,
        unit: _calculateUnitValue(newNAV),
        predictedJockeyPoint: _calculatePredictedJockeyPoint(updatedCompanies.length),
      ));
      print("✅ Quantity decreased successfully");
    }
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