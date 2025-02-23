import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/market/market_bloc.dart';
import '../blocs/market/market_event.dart';
import '../themes/light_app_theme.dart';
import '../widgets/market/market_company_list.dart';
import '../widgets/market/market_filtter.dart';
import '../widgets/market/market_search.dart';

class MarketScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<MarketBloc>().add(LoadMarketData());

    return Scaffold(
      appBar: AppBar(
        title: Text("Market", style: TextStyle(color: AppTheme.lightTheme.scaffoldBackgroundColor)),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: AppTheme.lightTheme.scaffoldBackgroundColor),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => FilterBottomSheet(),
              );
            },
          ),
        ],
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: MarketSearchBar(),
          ),
          Expanded(
            child: CompanyList(),
          ),
        ],
      ),
    );
  }
}