import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../blocs/market/market_bloc.dart';
import '../../blocs/market/market_event.dart';
import '../../blocs/market/market_state.dart';

class FilterBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarketBloc, MarketState>(
      builder: (context, state) {
        if (state is MarketLoaded) {
          int allCount = state.companies.length;
          int nseCount = state.companies.where((c) => c["exchange"] == "NSE").length;
          int bseCount = state.companies.where((c) => c["exchange"] == "BSE").length;

          return Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, -2))],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text("Filter By Exchange", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                _buildFilterOption(context, "All", FontAwesomeIcons.list, allCount, Colors.grey),
                _buildFilterOption(context, "NSE", FontAwesomeIcons.chartLine, nseCount, Colors.blue),
                _buildFilterOption(context, "BSE", FontAwesomeIcons.chartBar, bseCount, Colors.green),
              ],
            ),
          );
        } else {
          return Container(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Widget _buildFilterOption(BuildContext context, String label, IconData icon, int count, Color iconColor) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      trailing: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          "$count",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: iconColor),
        ),
      ),
      onTap: () {
        context.read<MarketBloc>().add(FilterByExchange(label));
        Navigator.pop(context);
      },
    );
  }
}
