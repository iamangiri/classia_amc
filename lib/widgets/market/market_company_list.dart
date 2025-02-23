import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                color: isSelected ? Colors.amber.withOpacity(0.2) : Colors.transparent,
                child: ListTile(
                  title: Text(company["name"]),
                  subtitle: Text("${company["symbol"]} (${company["exchange"]})"),
                  trailing: IconButton(
                    icon: Icon(isSelected ? Icons.remove : Icons.add),
                    onPressed: () {
                      context.read<MarketBloc>().add(ToggleCompanySelection(company["id"]));
                    },
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