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
      final int quantity = company["quantity"] ?? 1; // Default to 1 if null

      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 1),
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
              "${company["symbol"]} - Exchange: ${company["exchange"]}",
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),

            // ✅ Add increment & decrement buttons
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔻 Decrease Button
                GestureDetector(
                  onTap: () {
                    context.read<PortfolioBloc>().add(DecreaseCompanyQuantity(company["id"]));
                  },
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.redAccent, width: 1),
                    ),
                    child: Icon(Icons.remove, color: Colors.redAccent, size: 20),
                  ),
                ),
                SizedBox(width: 10),

                // 🔹 Quantity Display
                Text(
                  quantity.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                ),
                SizedBox(width: 10),

                // 🔺 Increase Button
                GestureDetector(
                  onTap: () {
                    context.read<PortfolioBloc>().add(IncreaseCompanyQuantity(company["id"]));
                  },
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.green, width: 1),
                    ),
                    child: Icon(Icons.add, color: Colors.green, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
