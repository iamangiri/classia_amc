import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
        backgroundColor: AppTheme.lightTheme.primaryColor,
        centerTitle: true, // Centered for a modern layout
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(FontAwesomeIcons.store, color: Colors.white, size: 20), // Modern market icon
            SizedBox(width: 8), // Spacing between icon and text
            Text(
              "Market",
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
            icon: FaIcon(FontAwesomeIcons.filter, color: Colors.white, size: 18), // Modern filter icon
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)), // Smooth curve
                ),
                builder: (context) => FilterBottomSheet(),
              );
            },
          ),
        ],
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