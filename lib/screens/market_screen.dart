// import 'package:flutter/material.dart';

// class MarketPage extends StatelessWidget {
//   const MarketPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text(
//         'Market Page',
//         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//       ),

//       //FA0A14DZSEFPX6K9
//     );
//   }
// }

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
    // Ensure Market Data is loaded when the screen is built
    context.read<MarketBloc>().add(LoadMarketData());

    return Scaffold(
      appBar: AppBar(
        title: Text("Market",
            style:
                TextStyle(color: AppTheme.lightTheme.scaffoldBackgroundColor)),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list,
                color: AppTheme.lightTheme
                    .scaffoldBackgroundColor), // Set icon color to white
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
