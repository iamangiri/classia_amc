import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    backgroundColor: AppTheme.lightTheme.primaryColor,
      centerTitle: true, // Centering title for modern alignment
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(FontAwesomeIcons.chartLine, color: Colors.white, size: 22), // Modern portfolio icon
          SizedBox(width: 8), // Spacing between icon and text
          Text(
            "Portfolio",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: FaIcon(FontAwesomeIcons.plus, color: Colors.white, size: 20), // Modern add icon
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
                  buildNAVSection(state.currentNAV, state.unit),
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





