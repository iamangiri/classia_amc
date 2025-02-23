import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../blocs/market/market_bloc.dart';
import '../../blocs/market/market_event.dart';
import '../../blocs/market/market_state.dart';

class CompanyList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarketBloc, MarketState>(
      builder: (context, state) {
        if (state is MarketLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is MarketLoaded) {
          return ListView.builder(
            itemCount: state.companies.length,
            itemBuilder: (context, index) {
              final company = state.companies[index];
              final isSelected = state.selectedCompanies.contains(company["id"]);
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? Colors.grey.shade300 : Colors.grey.shade400,
                    width: isSelected ? 2 : 1, // 2px for selected, 1px for normal
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Card(
                  elevation: 3,
                  shadowColor: Colors.black12,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: Icon(FontAwesomeIcons.building, color: Colors.blue.shade700, size: 18),
                    ),
                    title: Text(
                      company["name"],
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                    ),
                    subtitle: Text(
                      "${company["symbol"]} (${company["exchange"]})",
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    trailing: GestureDetector(
                      onTap: () {
                        context.read<MarketBloc>().add(ToggleCompanySelection(company["id"]));
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? Colors.red.shade50 : Colors.green.shade50,
                          border: Border.all(color: isSelected ? Colors.redAccent : Colors.green, width: 1),
                        ),
                        child: Icon(
                          isSelected ? Icons.remove : Icons.add,
                          color: isSelected ? Colors.redAccent : Colors.green,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Center(child: Text("Something went wrong!"));
        }
      },
    );
  }
}
