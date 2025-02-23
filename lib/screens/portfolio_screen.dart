import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/portfolio/portfolio_bloc.dart';
import '../blocs/portfolio/portfolio_event.dart';
import '../blocs/portfolio/portfolio_state.dart';
import '../themes/light_app_theme.dart';

class PortfolioScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Portfolio", style: TextStyle(color: AppTheme.lightTheme.scaffoldBackgroundColor)),
        backgroundColor: AppTheme.lightTheme.primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: AppTheme.lightTheme.scaffoldBackgroundColor),
            onPressed: () {
              // Navigate to a screen to add companies
            },
          ),
        ],
      ),
      body: BlocBuilder<PortfolioBloc, PortfolioState>(
        builder: (context, state) {
          if (state is PortfolioLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is PortfolioLoaded) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildPortfolioOverview(state),
                  _buildNAVCard(state.currentNAV),
                  _buildCompanyList(state.companies),
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

  Widget _buildPortfolioOverview(PortfolioLoaded state) {
    return Card(
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(" ${state.accountName}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("Managed by: ${state.accountManager}",
                style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Jockey Point: ${state.joycePoint.toStringAsFixed(1)}/10",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.blueAccent)),
                Icon(Icons.star, color: Colors.orangeAccent, size: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNAVCard(double currentNAV) {
    return Card(
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Current NAV", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("\$${currentNAV.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyList(List<Map<String, dynamic>> companies) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: companies.length,
      itemBuilder: (context, index) {
        final company = companies[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: ListTile(
            title: Text(company["name"], style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("${company["symbol"]} - Exchange: ${company["exchange"]}"),
            trailing: IconButton(
              icon: Icon(Icons.remove, color: Colors.redAccent),
              onPressed: () {
                context.read<PortfolioBloc>().add(RemoveCompanyFromPortfolio(company["id"]));
              },
            ),
          ),
        );
      },
    );
  }
}