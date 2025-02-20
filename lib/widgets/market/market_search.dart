import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/market/market_bloc.dart';
import '../../blocs/market/market_event.dart';

class MarketSearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search companies...",
        hintStyle: TextStyle(color: Colors.black),
        prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0), // Rounded corners
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0), // 1px border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.blue, width: 1.0), // Highlight when focused
        ),
      ),
      onChanged: (query) {
        context.read<MarketBloc>().add(SearchCompany(query));
      },
    );
  }
}
