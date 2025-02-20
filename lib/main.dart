import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/main_screen/main_screen_bloc.dart';
import 'blocs/market/market_bloc.dart';
import 'blocs/market/market_event.dart';
import 'routes/app_router.dart';
import 'themes/light_app_theme.dart';

void main() {
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
    )],
      child: MaterialApp.router(
        title: 'Classia AMCs',
        theme: AppTheme.lightTheme,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
