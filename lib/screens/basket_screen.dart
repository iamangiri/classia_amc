import 'package:classia_amc/screens/profile_screen.dart';
import 'package:classia_amc/screens/userprofile/customer_support_screen.dart'
    show CustomerSupportScreen;
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

  // Filter states
  String _selectedType = 'ALL';
  String _selectedSubscriptionType = 'ALL';
  String _selectedVolatility = 'ALL';
  String _selectedStatus = 'ACTIVE';

  @override
  void initState() {
    super.initState();
    _loadBaskets();
  }

  Future<void> _loadBaskets() async {
    setState(() => _isLoading = true);
    try {
      final response = await _api.fetchBaskets(
        type: _selectedType == 'ALL' ? null : _selectedType,
        subscriptionType: _selectedSubscriptionType == 'ALL'
            ? null
            : _selectedSubscriptionType,
        volatility: _selectedVolatility == 'ALL' ? null : _selectedVolatility,
        status: _selectedStatus,
      );
      setState(() {
        _baskets = response['data']['basketList'] ?? [];
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
        backgroundColor:
            isError ? Colors.red : AppTheme.lightTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      ),
    );
  }

  void _navigateToMarketWithBasket(int basketId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => MarketScreen(preSelectedBasketId: basketId)),
    );
    if (mounted) _loadBaskets();
  }

  // Show filter bottom sheet
  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Filters',
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.lightTheme.primaryColor)),
                  TextButton(
                    onPressed: () {
                      setSheetState(() {
                        _selectedType = 'ALL';
                        _selectedSubscriptionType = 'ALL';
                        _selectedVolatility = 'ALL';
                        _selectedStatus = 'ACTIVE';
                      });
                    },
                    child: const Text('Reset'),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              _buildFilterDropdown(
                'Basket Type',
                _selectedType,
                ['ALL', 'INTRADAY', 'INTRAHOUR', 'DELIVERY'],
                (v) => setSheetState(() => _selectedType = v!),
              ),
              SizedBox(height: 12.h),
              _buildFilterDropdown(
                'Subscription Type',
                _selectedSubscriptionType,
                ['ALL', 'FREE', 'FEE-BASED'],
                (v) => setSheetState(() => _selectedSubscriptionType = v!),
              ),
              SizedBox(height: 12.h),
              _buildFilterDropdown(
                'Volatility',
                _selectedVolatility,
                ['ALL', 'LOW', 'MID', 'HIGH'],
                (v) => setSheetState(() => _selectedVolatility = v!),
              ),
              SizedBox(height: 12.h),
              _buildFilterDropdown(
                'Status',
                _selectedStatus,
                ['ACTIVE', 'INACTIVE'],
                (v) => setSheetState(() => _selectedStatus = v!),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _loadBaskets();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightTheme.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r)),
                  ),
                  child: const Text('Apply Filters',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterDropdown(String label, String value, List<String> items,
      void Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      ),
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
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
          icon: const FaIcon(FontAwesomeIcons.userCircle,
              color: Colors.white, size: 22),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => ProfileScreen())),
        ),
        title: Text("Baskets",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18.sp)),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white, size: 22),
            onPressed: _showFilterSheet,
            tooltip: 'Filter Baskets',
          ),
          IconButton(
              icon: const Icon(Icons.support_agent,
                  color: Colors.white, size: 22),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => CustomerSupportScreen()))),
          IconButton(
              icon: const FaIcon(FontAwesomeIcons.bell,
                  color: Colors.white, size: 22),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => NotificationScreen()))),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showBasketForm(),
        icon: const Icon(Icons.add, color: Colors.white),
        label:
            const Text('Create Basket', style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.lightTheme.primaryColor,
        elevation: 4,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: AppTheme.lightTheme.primaryColor))
          : _baskets.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: _loadBaskets,
                  color: AppTheme.lightTheme.primaryColor,
                  child: ListView.builder(
                    padding: EdgeInsets.all(16.w),
                    itemCount: _baskets.length,
                    itemBuilder: (_, i) => _buildBasketCard(_baskets[i]),
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
                    shape: BoxShape.circle),
                child: Icon(Icons.shopping_basket_outlined,
                    size: 80.w,
                    color: AppTheme.lightTheme.primaryColor.withOpacity(0.3)),
              ),
              SizedBox(height: 24.h),
              Text('No baskets found',
                  style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.lightTheme.primaryColor)),
              SizedBox(height: 12.h),
              Text('Try adjusting your filters or create a new basket',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600])),
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
              gradient: LinearGradient(colors: [
                AppTheme.lightTheme.primaryColor,
                AppTheme.lightTheme.primaryColor.withOpacity(0.8)
              ]),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10.r)),
                  child: const Icon(Icons.shopping_basket_rounded,
                      color: Colors.white, size: 24),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(basket['basketName'],
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      SizedBox(height: 4.h),
                      Text('by ${basket['raName']}',
                          style: TextStyle(
                              fontSize: 12.sp, color: Colors.white70)),
                    ],
                  ),
                ),
                IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                    onPressed: () => _showBasketForm(basket: basket)),
                IconButton(
                  icon: const Icon(Icons.rate_review_outlined,
                      color: Colors.white, size: 20),
                  onPressed: () => _showReviewsDialog(basket['id']),
                  tooltip: 'View Reviews',
                ),
                IconButton(
                  icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Colors.white),
                  onPressed: () => setState(() =>
                      _expandedBasketId = isExpanded ? null : basket['id']),
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
                            Icons.payment_rounded)),
                    Expanded(
                        child: _buildInfoItem(
                            'Expected Return',
                            '${basket['expectedReturn']}%',
                            Icons.trending_up_rounded)),
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
                            : AppTheme.lightTheme.hintColor),
                    _buildChip(basket['volatility'],
                        _getVolatilityColor(basket['volatility'])),
                    _buildChip(
                        basket['status'],
                        basket['status'] == 'ACTIVE'
                            ? Colors.blue
                            : Colors.grey),
                    if (basket['type'] != null)
                      _buildChip(basket['type'], _getTypeColor(basket['type'])),
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

  Color _getTypeColor(String type) {
    switch (type) {
      case 'INTRADAY':
        return Colors.deepPurple;
      case 'INTRAHOUR':
        return Colors.teal;
      case 'DELIVERY':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  Widget _buildInfoItem(String label, String value, IconData icon) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon,
                size: 16,
                color: AppTheme.lightTheme.primaryColor.withOpacity(0.6)),
            SizedBox(width: 6.w),
            Text(label,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]))
          ]),
          SizedBox(height: 4.h),
          Text(value,
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.lightTheme.primaryColor)),
        ],
      );

  Widget _buildChip(String label, Color color) => Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: color.withOpacity(0.3))),
        child: Text(label,
            style: TextStyle(
                fontSize: 11.sp, color: color, fontWeight: FontWeight.w600)),
      );

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
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Icon(Icons.pie_chart_rounded,
                    color: AppTheme.lightTheme.primaryColor, size: 20),
                SizedBox(width: 8.w),
                Text('Holdings (${holdings.length})',
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.lightTheme.primaryColor))
              ]),
              ElevatedButton.icon(
                onPressed: () => _navigateToMarketWithBasket(basket['id']),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Stocks'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightTheme.primaryColor,
                    foregroundColor: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          holdings.isEmpty
              ? Center(
                  child: Text('No stocks in this basket',
                      style:
                          TextStyle(color: Colors.grey[500], fontSize: 14.sp)))
              : Column(
                  children: holdings
                      .map((h) => _buildHoldingItem(basket['id'], h))
                      .toList()),
        ],
      ),
    );
  }

  // Updated to show stock NAME instead of ID
  Widget _buildHoldingItem(int basketId, dynamic holding) {
    final stockName = holding['name'] ?? holding['symbol'] ?? 'Unknown Stock';
    final symbol = holding['symbol'] ?? '';

    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r)),
          child: Icon(Icons.show_chart,
              color: AppTheme.lightTheme.primaryColor, size: 24),
        ),
        title: Text(stockName,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
                color: AppTheme.lightTheme.primaryColor)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (symbol.isNotEmpty)
              Text('Symbol: $symbol',
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey[600])),
            SizedBox(height: 4.h),
            Text(
                'Holding: ${holding['holdinPercentage']}% | ${holding['orderType']} | Qty: ${holding['qantity'] ?? 'N/A'}',
                style: TextStyle(fontSize: 12.sp)),
            if (holding['slPrice'] != '0' || holding['tgtPrice'] != '0')
              Text('SL: ${holding['slPrice']} | Target: ${holding['tgtPrice']}',
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey[700])),
          ],
        ),
        trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _removeStock(basketId, holding['stockId'])),
      ),
    );
  }

  // Basket form with type dropdown
  void _showBasketForm({dynamic basket}) {
    final isEdit = basket != null;
    final formKey = GlobalKey<FormState>();

    final controllers = {
      'basketName': TextEditingController(text: basket?['basketName'] ?? ''),
      'subscriptionAmount': TextEditingController(
          text: basket?['subscriptionAmount']?.toString() ?? ''),
      'raName': TextEditingController(text: basket?['raName'] ?? ''),
      'expectedReturn': TextEditingController(
          text: basket?['expectedReturn']?.toString() ?? ''),
    };

    String subscriptionType = basket?['subscryptionType'] ?? 'FREE';
    String volatility = basket?['volatility'] ?? 'LOW';
    String status = basket?['status'] ?? 'ACTIVE';
    String type = basket?['type'] ?? 'INTRADAY';

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          title: Text(isEdit ? 'Update Basket' : 'Create Basket',
              style: TextStyle(color: AppTheme.lightTheme.primaryColor)),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextFormField(
                    controller: controllers['basketName'],
                    decoration: _inputDec('Basket Name'),
                    validator: (v) => v!.isEmpty ? 'Required' : null),
                SizedBox(height: 12.h),
                TextFormField(
                    controller: controllers['subscriptionAmount'],
                    decoration: _inputDec('Subscription Amount'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? 'Required' : null),
                SizedBox(height: 12.h),
                TextFormField(
                    controller: controllers['raName'],
                    decoration: _inputDec('RA Name'),
                    validator: (v) => v!.isEmpty ? 'Required' : null),
                SizedBox(height: 12.h),
                TextFormField(
                    controller: controllers['expectedReturn'],
                    decoration: _inputDec('Expected Return (%)'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? 'Required' : null),
                SizedBox(height: 12.h),
                DropdownButtonFormField<String>(
                    value: subscriptionType,
                    decoration: _inputDec('Subscription Type'),
                    items: ['FREE', 'FEE-BASED']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) =>
                        setDialogState(() => subscriptionType = v!)),
                SizedBox(height: 12.h),
                DropdownButtonFormField<String>(
                    value: volatility,
                    decoration: _inputDec('Volatility'),
                    items: ['LOW', 'MID', 'HIGH']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setDialogState(() => volatility = v!)),
                SizedBox(height: 12.h),
                DropdownButtonFormField<String>(
                    value: status,
                    decoration: _inputDec('Status'),
                    items: ['ACTIVE', 'INACTIVE']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setDialogState(() => status = v!)),
                SizedBox(height: 12.h),
                DropdownButtonFormField<String>(
                  value: type,
                  decoration: _inputDec('Basket Type'),
                  items: ['INTRADAY', 'INTRAHOUR', 'DELIVERY']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setDialogState(() => type = v!),
                ),
              ]),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')),
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
                    type: type,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.primaryColor),
              child: Text(isEdit ? 'Update' : 'Create'),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDec(String label) => InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: AppTheme.lightTheme.primaryColor)),
      );

  Future<void> _saveBasket({
    int? basketId,
    required String basketName,
    required String subscriptionAmount,
    required String raName,
    required String expectedReturn,
    required String subscriptionType,
    required String volatility,
    required String status,
    required String type,
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
          type: type,
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
          type: type,
        );
        _showSnackBar('Basket updated successfully');
      }
      _loadBaskets();
    } catch (e) {
      _showSnackBar('Error: $e', isError: true);
    }
  }

  // Updated Reviews Dialog
  void _showReviewsDialog(int basketId) async {
    setState(() => _isLoading = true);
    try {
      final reviews = await _api.fetchReviews(basketId: basketId);
      setState(() => _isLoading = false);

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          title: Row(
            children: [
              Icon(Icons.star, color: Colors.amber, size: 24),
              SizedBox(width: 8.w),
              Text('Reviews (${reviews.length})',
                  style: TextStyle(color: AppTheme.lightTheme.primaryColor)),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 400.h,
            child: reviews.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.rate_review_outlined,
                            size: 60, color: Colors.grey[400]),
                        SizedBox(height: 16.h),
                        Text('No reviews yet',
                            style: TextStyle(
                                fontSize: 16.sp, color: Colors.grey[600])),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: reviews.length,
                    itemBuilder: (_, i) {
                      final r = reviews[i];
                      final rating = (r['review'] as num?)?.toInt() ?? 0;
                      final userName = r['userName'] ?? 'User #${r['userId']}';

                      return Card(
                        margin: EdgeInsets.only(bottom: 12.h),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppTheme.lightTheme.primaryColor,
                            child: Text(
                              userName[0].toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 6.h),
                              Row(
                                children: List.generate(
                                  5,
                                  (j) => Icon(
                                    Icons.star,
                                    size: 16,
                                    color: j < rating
                                        ? Colors.amber
                                        : Colors.grey[400]!,
                                  ),
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Text(r['comment'] ?? 'No comment',
                                  style: TextStyle(fontSize: 13.sp)),
                              SizedBox(height: 4.h),
                              Text(
                                _formatDate(r['createdAt']),
                                style: TextStyle(
                                    fontSize: 11.sp, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'))
          ],
        ),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Failed to load reviews: $e', isError: true);
    }
  }

  String _formatDate(dynamic dateStr) {
    if (dateStr == null) return 'N/A';
    try {
      final date = DateTime.parse(dateStr.toString());
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inDays == 0) {
        if (diff.inHours == 0) {
          return '${diff.inMinutes} minutes ago';
        }
        return '${diff.inHours} hours ago';
      } else if (diff.inDays < 7) {
        return '${diff.inDays} days ago';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return 'N/A';
    }
  }

  Future<void> _removeStock(int basketId, int stockId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text('Confirm',
            style: TextStyle(color: AppTheme.lightTheme.primaryColor)),
        content: const Text('Remove this stock from basket?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Remove')),
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
