import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/market/market_bloc.dart';
import '../../blocs/market/market_event.dart';

class FilterBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text("All"),
            onTap: () {
              context.read<MarketBloc>().add(FilterByExchange("All"));
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text("NSE"),
            onTap: () {
              context.read<MarketBloc>().add(FilterByExchange("NSE"));
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text("BSE"),
            onTap: () {
              context.read<MarketBloc>().add(FilterByExchange("BSE"));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}