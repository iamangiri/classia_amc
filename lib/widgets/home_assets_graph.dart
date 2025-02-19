import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../themes/light_app_theme.dart';

class AssetGraph extends StatefulWidget {
  final Map<String, List<FlSpot>> data; // Data for totalAssets, nav, and lotValue
  final String selectedFilter; // Selected filter (e.g., '1 Week', '1 Month')

  const AssetGraph({
    Key? key,
    required this.data,
    required this.selectedFilter,
  }) : super(key: key);

  @override
  _AssetGraphState createState() => _AssetGraphState();
}

class _AssetGraphState extends State<AssetGraph> {
  String _selectedFilter = '1 Month'; // Default filter
  bool _isFullScreen = false; // Track if graph is in full-screen mode

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.selectedFilter;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Graph
        GestureDetector(
          onDoubleTap: _toggleFullScreen, // Double-tap to expand the graph
          child: Container(
            height: _isFullScreen ? MediaQuery.of(context).size.height : 300, // Toggle between full-screen and normal size
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Enable horizontal scrolling
              child: Container(
                width: _isFullScreen
                    ? MediaQuery.of(context).size.width * 2 // Expand width for full screen
                    : 600, // Set the width for normal view
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false), // Disable grid lines
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toStringAsFixed(2), // Show values on the left side
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return _getDayLabel(value); // Custom day label logic
                          },
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false), // Hide right titles
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false), // Hide top titles
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        bottom: BorderSide(color: Colors.black, width: 1),
                        left: BorderSide(color: Colors.black, width: 1),
                        top: BorderSide.none,
                        right: BorderSide.none,
                      ),
                    ),
                    lineBarsData: [
                      // Total Assets Line
                      LineChartBarData(
                        spots: widget.data['totalAssets']!,
                        isCurved: true,
                        color: Colors.blue,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                      // NAV Line
                      LineChartBarData(
                        spots: widget.data['nav']!,
                        isCurved: true,
                        color: Colors.green,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                      // Lot Value Line
                      LineChartBarData(
                        spots: widget.data['lotValue']!,
                        isCurved: true,
                        color: Colors.orange,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildFilterButton('1 Week'),
            _buildFilterButton('1 Month'),
            _buildFilterButton('3 Months'),
            _buildFilterButton('6 Months'),
            _buildFilterButton('1 Year'),
          ],
        ),
      ],
    );
  }

  Widget _getDayLabel(double value) {
    int totalDays = 0;
    int step = 1;
    if (_selectedFilter == '1 Week') {
      totalDays = 7;
      step = 2;
    } else if (_selectedFilter == '1 Month') {
      totalDays = 30;
      step = 5;
    } else if (_selectedFilter == '3 Months') {
      totalDays = 90;
      step = 15;
    } else if (_selectedFilter == '6 Months') {
      totalDays = 180;
      step = 30;
    } else if (_selectedFilter == '1 Year') {
      totalDays = 365;
      step = 60;
    }

    // Display the labels based on the selected filter
    int day = (value * step).toInt();
    if (day <= totalDays) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0), // Padding for better spacing
        child: Text(
          'Day $day',
          style: TextStyle(
            fontSize: 10,
            color: Colors.black,
            // Rotate text if necessary
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5, // Add some space between letters
          ),
        ),
      );
    }
    return Text('');
  }

  Widget _buildFilterButton(String filter) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0), // Smaller padding
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedFilter = filter;
          });
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6), // Smaller size
          backgroundColor: _selectedFilter == filter
              ? AppTheme.lightTheme.primaryColor
              : Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Slightly rounded
          ),
        ),
        child: Text(
          filter,
          style: TextStyle(
            fontSize: 12, // Smaller font size
            color: _selectedFilter == filter ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  // Toggle full-screen mode for the graph
  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
  }
}
