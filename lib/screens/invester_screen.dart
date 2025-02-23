import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/transaction/transaction_bloc.dart';
import '../blocs/transaction/transaction_event.dart';
import '../blocs/transaction/transaction_state.dart';
import '../themes/light_app_theme.dart';
import '../widgets/transaction_items.dart';

class InvestorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Investor Hub',
          style: TextStyle(color: AppTheme.lightTheme.scaffoldBackgroundColor),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: AppTheme.lightTheme.scaffoldBackgroundColor),
            onSelected: (value) {
              context.read<TransactionBloc>().add(FilterTransactions(filterType: value));
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'all', child: Text('All')),
              PopupMenuItem(value: 'investment', child: Text('Investments')),
              PopupMenuItem(value: 'withdrawal', child: Text('Withdrawals')),
            ],
          ),
        ],
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
      body: Column(
        children: [
          // Summary Section
          _buildSummarySection(),

          // Filter Buttons
          _buildFilterButtons(context),

          // Transactions List
          Expanded(
            child: BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
                if (state is TransactionLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is TransactionLoaded) {
                  final transactions = state.transactions;
                  return ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      return TransactionItem(transaction: transactions[index]);
                    },
                  );
                } else {
                  return Center(child: Text('Something went wrong!'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Summary Section: Total Deposit & Withdrawal
  Widget _buildSummarySection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSummaryCard('Total Deposit', '\$5000', Colors.green),
          _buildSummaryCard('Total Withdraw', '\$2000', Colors.red),
        ],
      ),
    );
  }

  // Helper function to build summary cards
  Widget _buildSummaryCard(String title, String amount, Color color) {
    return Card(
      color: color.withOpacity(0.2),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              amount,
              style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // Filter Buttons Section
  Widget _buildFilterButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildFilterButton(context, 'All', 'all'),
          _buildFilterButton(context, '1 Month', '1m'),
          _buildFilterButton(context, '1 Week', '1w'),
          _buildFilterButton(context, '1 Day', '1d'),


        ],
      ),
    );
  }

  // Filter Button Widget
  Widget _buildFilterButton(BuildContext context, String label, String filter) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.lightTheme.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      onPressed: () {
        context.read<TransactionBloc>().add(FilterTransactions(filterType: filter));
      },
      child: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}