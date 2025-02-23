import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../blocs/portfolio/portfolio_bloc.dart';
import '../blocs/portfolio/portfolio_event.dart';

Widget buildCompanyList(List<Map<String, dynamic>> companies) {
  return ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: companies.length,
    itemBuilder: (context, index) {
      final company = companies[index];
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 1), // 1px border outside
          borderRadius: BorderRadius.circular(12),
        ),
        child: Card(
          elevation: 3, // Light elevation for a modern look
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
              "${company["symbol"]} - Exchange: ${company["exchange"]}",
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            trailing: GestureDetector(
              onTap: () {
                context.read<PortfolioBloc>().add(RemoveCompanyFromPortfolio(company["id"]));
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.redAccent, width: 1),
                ),
                child: Icon(Icons.remove, color: Colors.redAccent, size: 20),
              ),
            ),
          ),
        ),
      );
    },
  );
}
