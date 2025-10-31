import 'package:classia_amc/screens/profile_screen.dart';
import 'package:classia_amc/screens/userprofile/customer_support_screen.dart' show CustomerSupportScreen;
import 'package:classia_amc/screens/userprofile/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../service/apiservice/basket_api_service.dart';
import '../themes/light_app_theme.dart';
import 'market_screen.dart';

class BasketScreen extends StatefulWidget {
  const BasketScreen({Key? key}) : super(key: key);

  @override
  State<BasketScreen> createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> {
  final BasketApiService _api = BasketApiService();
  List<dynamic> _baskets = [];
  bool _isLoading = false;
  int? _expandedBasketId;

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
      _showSnackBar('Error: $e', isError: true);
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

  void _navigateToMarketWithBasket(int basketId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MarketScreen(preSelectedBasketId: basketId),
      ),
    );
    
    if (mounted) {
      _loadBaskets();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar:
AppBar(
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
          "Baskets",
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showBasketForm(),
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('Create Basket', style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.lightTheme.primaryColor,
        elevation: 4,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppTheme.lightTheme.primaryColor,
              ),
            )
          : _baskets.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadBaskets,
                  color: AppTheme.lightTheme.primaryColor,
                  child: ListView.builder(
                    padding: EdgeInsets.all(16.w),
                    itemCount: _baskets.length,
                    itemBuilder: (context, index) {
                      return _buildBasketCard(_baskets[index]);
                    },
                  ),
                ),
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
                'No baskets yet',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.lightTheme.primaryColor,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Create your first basket to get started',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasketCard(dynamic basket) {
    final isExpanded = _expandedBasketId == basket['id'];
    final holdings = basket['holdings'] as List? ?? [];

    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      elevation: 2,
      shadowColor: AppTheme.lightTheme.primaryColor.withOpacity(0.1),
      child: Column(
        children: [
          // Header
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
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10.r),
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
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                  onPressed: () => _showBasketForm(basket: basket),
                ),
                IconButton(
                  icon: Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _expandedBasketId = isExpanded ? null : basket['id'];
                    });
                  },
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        'Subscription',
                        '₹${basket['subscriptionAmount']}',
                        Icons.payment_rounded,
                      ),
                    ),
                    Expanded(
                      child: _buildInfoItem(
                        'Expected Return',
                        '${basket['expectedReturn']}%',
                        Icons.trending_up_rounded,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    _buildChip(
                      basket['subscryptionType'],
                      basket['subscryptionType'] == 'FREE'
                          ? Colors.green
                          : AppTheme.lightTheme.hintColor,
                    ),
                    _buildChip(
                      basket['volatility'],
                      _getVolatilityColor(basket['volatility']),
                    ),
                    _buildChip(
                      basket['status'],
                      basket['status'] == 'ACTIVE' ? Colors.blue : Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (isExpanded) _buildHoldingsSection(basket, holdings),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: AppTheme.lightTheme.primaryColor.withOpacity(0.6),
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
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

  Widget _buildHoldingsSection(dynamic basket, List holdings) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16.r),
          bottomRight: Radius.circular(16.r),
        ),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.pie_chart_rounded,
                    color: AppTheme.lightTheme.primaryColor,
                    size: 20,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Holdings (${holdings.length})',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.lightTheme.primaryColor,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _navigateToMarketWithBasket(basket['id']),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Stocks'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          if (holdings.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(20.h),
                child: Column(
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'No stocks in this basket',
                      style: TextStyle(color: Colors.grey[500], fontSize: 14.sp),
                    ),
                    SizedBox(height: 8.h),
                    TextButton.icon(
                      onPressed: () => _navigateToMarketWithBasket(basket['id']),
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: AppTheme.lightTheme.primaryColor,
                      ),
                      label: Text(
                        'Browse Market',
                        style: TextStyle(color: AppTheme.lightTheme.primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...holdings.map((holding) => _buildHoldingItem(basket['id'], holding)),
        ],
      ),
    );
  }

  Widget _buildHoldingItem(int basketId, dynamic holding) {
    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            Icons.show_chart,
            color: AppTheme.lightTheme.primaryColor,
            size: 24,
          ),
        ),
        title: Text(
          'Stock ID: ${holding['stockId']}',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Text('Holding: ${holding['holdinPercentage']}% | ${holding['orderType']}'),
            if (holding['slPrice'] != '0' || holding['tgtPrice'] != '0')
              Text('SL: ${holding['slPrice']} | Target: ${holding['tgtPrice']}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _removeStock(basketId, holding['stockId']),
        ),
      ),
    );
  }

  void _showBasketForm({dynamic basket}) {
    final isEdit = basket != null;
    final formKey = GlobalKey<FormState>();
    
    final controllers = {
      'basketName': TextEditingController(text: basket?['basketName'] ?? ''),
      'subscriptionAmount': TextEditingController(text: basket?['subscriptionAmount'] ?? ''),
      'raName': TextEditingController(text: basket?['raName'] ?? ''),
      'expectedReturn': TextEditingController(text: basket?['expectedReturn'] ?? ''),
    };

    String subscriptionType = basket?['subscryptionType'] ?? 'FREE';
    String volatility = basket?['volatility'] ?? 'LOW';
    String status = basket?['status'] ?? 'ACTIVE';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          title: Text(
            isEdit ? 'Update Basket' : 'Create Basket',
            style: TextStyle(color: AppTheme.lightTheme.primaryColor),
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: controllers['basketName'],
                    decoration: InputDecoration(
                      labelText: 'Basket Name',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(color: AppTheme.lightTheme.primaryColor),
                      ),
                    ),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  SizedBox(height: 12.h),
                  TextFormField(
                    controller: controllers['subscriptionAmount'],
                    decoration: InputDecoration(
                      labelText: 'Subscription Amount',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(color: AppTheme.lightTheme.primaryColor),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  SizedBox(height: 12.h),
                  TextFormField(
                    controller: controllers['raName'],
                    decoration: InputDecoration(
                      labelText: 'RA Name',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(color: AppTheme.lightTheme.primaryColor),
                      ),
                    ),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  SizedBox(height: 12.h),
                  TextFormField(
                    controller: controllers['expectedReturn'],
                    decoration: InputDecoration(
                      labelText: 'Expected Return (%)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(color: AppTheme.lightTheme.primaryColor),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  SizedBox(height: 12.h),
                  DropdownButtonFormField<String>(
                    value: subscriptionType,
                    decoration: InputDecoration(
                      labelText: 'Subscription Type',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(color: AppTheme.lightTheme.primaryColor),
                      ),
                    ),
                    items: ['FREE', 'PAID'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (v) => setDialogState(() => subscriptionType = v!),
                  ),
                  SizedBox(height: 12.h),
                  DropdownButtonFormField<String>(
                    value: volatility,
                    decoration: InputDecoration(
                      labelText: 'Volatility',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(color: AppTheme.lightTheme.primaryColor),
                      ),
                    ),
                    items: ['LOW', 'MID', 'HIGH'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (v) => setDialogState(() => volatility = v!),
                  ),
                  SizedBox(height: 12.h),
                  DropdownButtonFormField<String>(
                    value: status,
                    decoration: InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(color: AppTheme.lightTheme.primaryColor),
                      ),
                    ),
                    items: ['ACTIVE', 'INACTIVE'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (v) => setDialogState(() => status = v!),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(context);
                  await _saveBasket(
                    basketId: basket?['id'],
                    basketName: controllers['basketName']!.text,
                    subscriptionAmount: controllers['subscriptionAmount']!.text,
                    raName: controllers['raName']!.text,
                    expectedReturn: controllers['expectedReturn']!.text,
                    subscriptionType: subscriptionType,
                    volatility: volatility,
                    status: status,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              ),
              child: Text(isEdit ? 'Update' : 'Create'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveBasket({
    int? basketId,
    required String basketName,
    required String subscriptionAmount,
    required String raName,
    required String expectedReturn,
    required String subscriptionType,
    required String volatility,
    required String status,
  }) async {
    try {
      if (basketId == null) {
        await _api.createBasket(
          basketName: basketName,
          subscriptionAmount: subscriptionAmount,
          raName: raName,
          expectedReturn: expectedReturn,
          subscriptionType: subscriptionType,
          volatility: volatility,
          status: status,
        );
        _showSnackBar('Basket created successfully');
      } else {
        await _api.updateBasket(
          basketId: basketId,
          basketName: basketName,
          subscriptionAmount: subscriptionAmount,
          raName: raName,
          expectedReturn: expectedReturn,
          subscriptionType: subscriptionType,
          volatility: volatility,
          status: status,
        );
        _showSnackBar('Basket updated successfully');
      }
      _loadBaskets();
    } catch (e) {
      _showSnackBar('Error: $e', isError: true);
    }
  }

  Future<void> _removeStock(int basketId, int stockId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text(
          'Confirm',
          style: TextStyle(color: AppTheme.lightTheme.primaryColor),
        ),
        content: const Text('Remove this stock from basket?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _api.removeStock(basketId: basketId, stockId: stockId);
        _showSnackBar('Stock removed successfully');
        _loadBaskets();
      } catch (e) {
        _showSnackBar('Error: $e', isError: true);
      }
    }
  }
}