import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../service/apiservice/basket_api_service.dart';
import '../themes/light_app_theme.dart';
import 'basket_screen.dart';
import 'market_screen.dart';
import 'profile_screen.dart';
import 'userprofile/customer_support_screen.dart';
import 'userprofile/notification_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final BasketApiService _api = BasketApiService();
  List<dynamic> _baskets = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadBaskets();
  }

  Future<void> _loadBaskets() async {
    setState(() => _isLoading = true);
    try {
      final response = await _api.fetchBaskets();
      setState(() {
        _baskets = response['data']['basketList'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Error loading baskets: $e', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : AppTheme.lightTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      ),
    );
  }

  void _navigateToBasketDetails(int basketId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MarketScreen(preSelectedBasketId: basketId),
      ),
    ).then((_) => _loadBaskets());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.primaryColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: FaIcon(FontAwesomeIcons.userCircle, color: Colors.white, size: 22),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          },
        ),
        title: Text(
          "Dashboard",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.support_agent, color: Colors.white, size: 22),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CustomerSupportScreen()),
              );
            },
          ),
          IconButton(
            icon: FaIcon(FontAwesomeIcons.bell, color: Colors.white, size: 22),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadBaskets,
        color: AppTheme.lightTheme.primaryColor,
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: AppTheme.lightTheme.primaryColor,
                ),
              )
            : _baskets.isEmpty
                ? _buildEmptyState()
                : CustomScrollView(
                    slivers: [
                      // Header Section
                      SliverToBoxAdapter(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.primaryColor,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30.r),
                              bottomRight: Radius.circular(30.r),
                            ),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 30.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Welcome Back',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'Classia RTA Partner',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 20.h),
                                    _buildStatsCard(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Baskets Section Header
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 16.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'My Baskets',
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.lightTheme.primaryColor,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    '${_baskets.length} Active Baskets',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: _loadBaskets,
                                icon: Icon(
                                  Icons.refresh_rounded,
                                  color: AppTheme.lightTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Baskets Grid
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => _buildBasketCard(_baskets[index]),
                            childCount: _baskets.length,
                          ),
                        ),
                      ),

                      SliverToBoxAdapter(child: SizedBox(height: 100.h)),
                    ],
                  ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BasketScreen()),
          ).then((_) => _loadBaskets());
        },
        icon: Icon(Icons.add, color: Colors.white),
        label: Text('Create Basket', style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.lightTheme.primaryColor,
        elevation: 4,
      ),
    );
  }

  Widget _buildStatsCard() {
    final totalStocks = _baskets.fold<int>(
      0,
      (sum, basket) => sum + ((basket['holdings'] as List?)?.length ?? 0),
    );

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.shopping_basket_rounded,
            label: 'Baskets',
            value: '${_baskets.length}',
            color: AppTheme.lightTheme.primaryColor,
          ),
          Container(width: 1, height: 40.h, color: Colors.grey[300]),
          _buildStatItem(
            icon: Icons.show_chart_rounded,
            label: 'Total Stocks',
            value: '$totalStocks',
            color: AppTheme.lightTheme.hintColor,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(40.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(40.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.primaryColor.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.shopping_basket_outlined,
                  size: 80.w,
                  color: AppTheme.lightTheme.primaryColor.withOpacity(0.3),
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'No Baskets Yet',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.lightTheme.primaryColor,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Create your first basket to start\nmanaging your portfolio',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              SizedBox(height: 32.h),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BasketScreen()),
                  ).then((_) => _loadBaskets());
                },
                icon: Icon(Icons.add_circle_outline),
                label: Text('Create Your First Basket'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasketCard(dynamic basket) {
    final holdings = basket['holdings'] as List? ?? [];
    final holdingsCount = holdings.length;

    return GestureDetector(
      onTap: () => _navigateToBasketDetails(basket['id']),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with gradient
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.lightTheme.primaryColor,
                    AppTheme.lightTheme.primaryColor.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.shopping_basket_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          basket['basketName'],
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'by ${basket['raName']}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoColumn(
                          'Subscription',
                          '₹${basket['subscriptionAmount']}',
                          Icons.payment_rounded,
                        ),
                      ),
                      Expanded(
                        child: _buildInfoColumn(
                          'Expected Return',
                          '${basket['expectedReturn']}%',
                          Icons.trending_up_rounded,
                        ),
                      ),
                      Expanded(
                        child: _buildInfoColumn(
                          'Holdings',
                          '$holdingsCount',
                          Icons.pie_chart_rounded,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      _buildChip(
                        basket['subscryptionType'],
                        basket['subscryptionType'] == 'FREE'
                            ? Colors.green
                            : AppTheme.lightTheme.hintColor,
                      ),
                      SizedBox(width: 8.w),
                      _buildChip(
                        basket['volatility'],
                        _getVolatilityColor(basket['volatility']),
                      ),
                      SizedBox(width: 8.w),
                      _buildChip(
                        basket['status'],
                        basket['status'] == 'ACTIVE' ? Colors.blue : Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppTheme.lightTheme.primaryColor.withOpacity(0.6),
          size: 20,
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.sp,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getVolatilityColor(String volatility) {
    switch (volatility) {
      case 'LOW':
        return Colors.green;
      case 'MID':
        return Colors.orange;
      case 'HIGH':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}