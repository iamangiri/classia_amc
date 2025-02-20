import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/portfolio/portfolio_bloc.dart';
import '../blocs/portfolio/portfolio_event.dart';
import '../blocs/portfolio/portfolio_state.dart';

class PortfolioScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Portfolio"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
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
                  _buildAccountDetails(state),
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

  Widget _buildAccountDetails(PortfolioLoaded state) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Account Name: ${state.accountName}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text("Account Manager: ${state.accountManager}", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildNAVCard(double currentNAV) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Current NAV", style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text("\$${currentNAV.toStringAsFixed(2)}", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
        return ListTile(
          title: Text(company["name"]),
          subtitle: Text("${company["symbol"]} - NAV Contribution: \$${company["navContribution"].toStringAsFixed(2)}"),
          trailing: IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              context.read<PortfolioBloc>().add(RemoveCompanyFromPortfolio(company["id"]));
            },
          ),
        );
      },
    );
  }
}