import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/portfolio/portfolio_bloc.dart';
import '../blocs/portfolio/portfolio_event.dart';
import '../blocs/portfolio/portfolio_state.dart';
import '../themes/light_app_theme.dart';
import '../widgets/portfolio_company_list.dart';
import '../widgets/portfolio_nav_section.dart';
import '../widgets/portfolio_overview.dart';
import 'market_screen.dart'; // Import the MarketScreen

class PortfolioScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<PortfolioBloc>().add(LoadPortfolioData());

    return Scaffold(
      appBar: AppBar(
        title: Text("Portfolio", style: TextStyle(
            color: AppTheme.lightTheme.scaffoldBackgroundColor)),
        backgroundColor: AppTheme.lightTheme.primaryColor,
        actions: [
          IconButton(
            icon: Icon(
                Icons.add, color: AppTheme.lightTheme.scaffoldBackgroundColor),
            onPressed: () {
              // Navigate to the MarketScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MarketScreen()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<PortfolioBloc, PortfolioState>(
        builder: (context, state) {
          print("Current state: $state");
          if (state is PortfolioLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is PortfolioLoaded) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  buildPortfolioOverview(state),
                  buildNAVSection(state.currentNAV, 44444),
                  buildCompanyList(state.companies),
                ],
              ),
            );
          } else {
            return Center(child: Text("Something went wrong!"));
          }
        },
      ),
    );
  }

}





