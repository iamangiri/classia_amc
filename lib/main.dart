import 'package:classia_amc/blocs/portfolio/portfolio_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/main_screen/main_screen_bloc.dart';
import 'blocs/market/database_service.dart';
import 'blocs/market/market_bloc.dart';
import 'blocs/market/market_event.dart';
import 'blocs/portfolio/portfolio_bloc.dart';
import 'blocs/transaction/transaction_bloc.dart';
import 'blocs/transaction/transaction_event.dart';
import 'routes/app_router.dart';
import 'themes/light_app_theme.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final DatabaseService databaseService = DatabaseService();
  await databaseService.database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MainScreenBloc()),
        BlocProvider(create: (context) => MarketBloc()),
        BlocProvider(
          create: (context) => MarketBloc()..add(LoadMarketData()),
        ),
        BlocProvider(
          create: (context) => TransactionBloc()..add(LoadTransactions()),
        ),
        BlocProvider(
          create: (context) => PortfolioBloc()..add(LoadPortfolioData()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Classia AMCs',
        theme: AppTheme.lightTheme,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
