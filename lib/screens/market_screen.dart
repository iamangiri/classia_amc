import 'package:classia_amc/screens/userprofile/customer_support_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../blocs/market/market_api_service.dart';
import '../blocs/market/market_chart_screen.dart';
import '../themes/light_app_theme.dart';
import 'basket_screen.dart';
import 'profile_screen.dart';
import 'userprofile/notification_screen.dart';

class MarketScreen extends StatefulWidget {
  final int? preSelectedBasketId;

  const MarketScreen({Key? key, this.preSelectedBasketId}) : super(key: key);

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  final MarketApiService _api = MarketApiService();
  final TextEditingController _searchCtrl = TextEditingController();

  List<Map<String, dynamic>> _stocks = [];
  List<Map<String, dynamic>> _filteredStocks = [];
  List<Map<String, dynamic>> _baskets = [];
  int? _selectedBasketId;
  Set<int> _basketStockIds = {};

  bool _isLoadingStocks = false;
  bool _isLoadingBaskets = false;
  int _currentPage = 1;
  final quantityCtrl = TextEditingController(text: '1');

  @override
  void initState() {
    super.initState();
    _selectedBasketId = widget.preSelectedBasketId;
    _loadData();
    _searchCtrl.addListener(_filterStocks);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadStocks(),
      _loadBaskets(),
    ]);
  }

  Future<void> _loadStocks() async {
    setState(() => _isLoadingStocks = true);
    try {
      final stocks = await _api.fetchStocks(page: _currentPage, limit: 50);
      setState(() {
        _stocks = stocks;
        _filteredStocks = stocks;
        _isLoadingStocks = false;
      });
    } catch (e) {
      setState(() => _isLoadingStocks = false);
      _showSnackBar('Error loading stocks: $e', isError: true);
    }
  }

  Future<void> _loadBaskets() async {
    setState(() => _isLoadingBaskets = true);
    try {
      final response = await _api.fetchBaskets();
      final basketList =
          List<Map<String, dynamic>>.from(response['data']['basketList']);

      setState(() {
        _baskets = basketList;
        _isLoadingBaskets = false;

        if (_selectedBasketId == null && _baskets.isNotEmpty) {
          _selectedBasketId = _baskets[0]['id'] as int;
          _updateBasketStockIds(_selectedBasketId!);
        } else if (_selectedBasketId != null) {
          _updateBasketStockIds(_selectedBasketId!);
        }
      });
    } catch (e) {
      setState(() => _isLoadingBaskets = false);
      _showSnackBar('Error loading baskets: $e', isError: true);
    }
  }

  void _updateBasketStockIds(int basketId) {
    _basketStockIds.clear();
    final basket = _baskets.firstWhere(
      (b) => b['id'] == basketId,
      orElse: () => {},
    );

    if (basket.isNotEmpty) {
      final holdings = basket['holdings'] as List<dynamic>? ?? [];
      for (var holding in holdings) {
        _basketStockIds.add(holding['stockId'] as int);
      }
    }
  }

  void _filterStocks() {
    final query = _searchCtrl.text.toLowerCase();
    setState(() {
      _filteredStocks = _stocks.where((stock) {
        final name = stock['name']?.toString().toLowerCase() ?? '';
        final symbol = stock['symbol']?.toString().toLowerCase() ?? '';
        return name.contains(query) || symbol.contains(query);
      }).toList();
    });
  }

  void _onBasketSelected(int? basketId) {
    setState(() {
      _selectedBasketId = basketId;
      if (basketId != null) {
        _updateBasketStockIds(basketId);
      } else {
        _basketStockIds.clear();
      }
    });
  }

  // Show basket selection dialog
  Future<void> _showBasketSelectionDialog() async {
    final selectedId = await showDialog<int>(
      context: context,
      builder: (context) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Container(
          constraints: BoxConstraints(maxHeight: 600.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Dialog Header
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.lightTheme.primaryColor,
                      AppTheme.lightTheme.primaryColor.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.shopping_basket_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        'Select Basket',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),

              // Baskets List
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(16.w),
                  itemCount: _baskets.length,
                  itemBuilder: (context, index) {
                    final basket = _baskets[index];
                    final basketId = basket['id'] as int;
                    final basketName = basket['basketName'] as String;
                    final holdingsCount =
                        (basket['holdings'] as List?)?.length ?? 0;
                    final isSelected = _selectedBasketId == basketId;

                    return Card(
                      margin: EdgeInsets.only(bottom: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        side: BorderSide(
                          color: isSelected
                              ? AppTheme.lightTheme.primaryColor
                              : Colors.grey[300]!,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: InkWell(
                        onTap: () => Navigator.pop(context, basketId),
                        borderRadius: BorderRadius.circular(12.r),
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10.w),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppTheme.lightTheme.primaryColor
                                          .withOpacity(0.1)
                                      : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Icon(
                                  Icons.shopping_basket_rounded,
                                  color: isSelected
                                      ? AppTheme.lightTheme.primaryColor
                                      : Colors.grey[600],
                                  size: 24,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      basketName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.sp,
                                        color: AppTheme.lightTheme.primaryColor,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4.h),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.pie_chart_rounded,
                                          size: 14,
                                          color: Colors.grey[600],
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          '$holdingsCount stocks',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.w,
                                            vertical: 2.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _getStatusColor(
                                                    basket['status'])
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                          ),
                                          child: Text(
                                            basket['status'],
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              color: _getStatusColor(
                                                  basket['status']),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  color: AppTheme.lightTheme.primaryColor,
                                  size: 24,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Create New Basket Button
              Padding(
                padding: EdgeInsets.all(16.w),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _navigateToCreateBasket();
                    },
                    icon: Icon(Icons.add_circle_outline),
                    label: Text('Create New Basket'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.lightTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (selectedId != null) {
      _onBasketSelected(selectedId);
    }
  }

  Color _getStatusColor(String status) {
    return status == 'ACTIVE' ? Colors.green : Colors.grey;
  }

  Future<void> _addStockToBasket(Map<String, dynamic> stock) async {
    if (_selectedBasketId == null) {
      _showSnackBar('Please select a basket first', isError: true);
      return;
    }

    final stockId = stock['id'] as int;
    final result = await _showAddStockDialog();
    if (result == null) return;

    try {
      // ← UPDATED CALL: Now includes qantity parameter
      await _api.addStockToBasket(
        basketId: _selectedBasketId!,
        stockId: stockId,
        holdinPercentage: result['percentage']!,
        slPrice: result['slPrice']!,
        tgtPrice: result['tgtPrice']!,
        orderType: result['orderType']!,
        qantity: result['qantity']!, // ← This matches your curl: qantity=5
      );

      setState(() => _basketStockIds.add(stockId));
      _showSnackBar('Stock added successfully');
      _loadBaskets(); // Refresh basket holdings
    } catch (e) {
      _showSnackBar('Error adding stock: $e', isError: true);
    }
  }

  Future<void> _removeStockFromBasket(int stockId) async {
    if (_selectedBasketId == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r)),
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _api.removeStockFromBasket(
        basketId: _selectedBasketId!,
        stockId: stockId,
      );
      setState(() => _basketStockIds.remove(stockId));
      _showSnackBar('Stock removed from basket successfully');
      _loadBaskets();
    } catch (e) {
      _showSnackBar('Error removing stock: $e', isError: true);
    }
  }

  Future<Map<String, String>?> _showAddStockDialog() async {
    final formKey = GlobalKey<FormState>();
    final percentageCtrl = TextEditingController(text: '10');
    final slPriceCtrl = TextEditingController(text: '0');
    final tgtPriceCtrl = TextEditingController(text: '0');
    String orderType = 'MARKET';

    return showDialog<Map<String, String>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          title: Text(
            'Add Stock Details',
            style: TextStyle(color: AppTheme.lightTheme.primaryColor),
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: percentageCtrl,
                    decoration: InputDecoration(
                      labelText: 'Holding Percentage',
                      suffixText: '%',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide:
                            BorderSide(color: AppTheme.lightTheme.primaryColor),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      final num = double.tryParse(v);
                      if (num == null || num <= 0 || num > 100) {
                        return 'Enter 1-100';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12.h),
                  TextFormField(
                    controller: quantityCtrl,
                    decoration: InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide:
                            BorderSide(color: AppTheme.lightTheme.primaryColor),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      if (int.tryParse(v) == null || int.parse(v) <= 0)
                        return 'Enter valid quantity';
                      return null;
                    },
                  ),
                  SizedBox(height: 12.h),
                  TextFormField(
                    controller: slPriceCtrl,
                    decoration: InputDecoration(
                      labelText: 'Stop Loss Price',
                      prefixText: '₹ ',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide:
                            BorderSide(color: AppTheme.lightTheme.primaryColor),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 12.h),
                  TextFormField(
                    controller: tgtPriceCtrl,
                    decoration: InputDecoration(
                      labelText: 'Target Price',
                      prefixText: '₹ ',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide:
                            BorderSide(color: AppTheme.lightTheme.primaryColor),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 12.h),
                  DropdownButtonFormField<String>(
                    value: orderType,
                    decoration: InputDecoration(
                      labelText: 'Order Type',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide:
                            BorderSide(color: AppTheme.lightTheme.primaryColor),
                      ),
                    ),
                    items: ['MARKET', 'LIMIT']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setDialogState(() => orderType = v!),
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
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(context, {
                    'percentage': percentageCtrl.text,
                    'slPrice': slPriceCtrl.text,
                    'tgtPrice': tgtPriceCtrl.text,
                    'orderType': orderType,
                    'qantity':
                        quantityCtrl.text, // ← THIS WAS MISSING! ADD THIS LINE
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r)),
              ),
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
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

  void _navigateToCreateBasket() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BasketScreen()),
    );

    if (result == true || mounted) {
      _loadBaskets();
    }
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
          icon: FaIcon(FontAwesomeIcons.userCircle,
              color: Colors.white, size: 22),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          },
        ),
        title: Text(
          "Market Stocks",
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
                MaterialPageRoute(
                    builder: (context) => CustomerSupportScreen()),
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
      body: Column(
        children: [
          // Basket Selector - NEW DESIGN WITH DIALOG
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.shopping_basket_rounded,
                      color: AppTheme.lightTheme.primaryColor,
                      size: 20,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Selected Basket',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                _isLoadingBaskets
                    ? LinearProgressIndicator(
                        color: AppTheme.lightTheme.primaryColor,
                        backgroundColor:
                            AppTheme.lightTheme.primaryColor.withOpacity(0.2),
                      )
                    : _baskets.isEmpty
                        ? _buildCreateBasketPrompt()
                        : _buildBasketSelector(),
              ],
            ),
          ),

          // Search Bar
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Search by name or symbol',
                prefixIcon:
                    Icon(Icons.search, color: AppTheme.lightTheme.primaryColor),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchCtrl.clear();
                          _filterStocks();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide:
                      BorderSide(color: AppTheme.lightTheme.primaryColor),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
          ),

          // Stock List
          Expanded(
            child: _isLoadingStocks
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.lightTheme.primaryColor,
                    ),
                  )
                : _filteredStocks.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _loadData,
                        color: AppTheme.lightTheme.primaryColor,
                        child: ListView.builder(
                          padding: EdgeInsets.all(16.w),
                          itemCount: _filteredStocks.length,
                          itemBuilder: (context, index) {
                            return _buildStockCard(_filteredStocks[index]);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateBasketPrompt() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.lightTheme.primaryColor.withOpacity(0.05),
            AppTheme.lightTheme.primaryColor.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
            color: AppTheme.lightTheme.primaryColor.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'No baskets available. Create one to start adding stocks.',
                  style: TextStyle(
                    color: AppTheme.lightTheme.primaryColor,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _navigateToCreateBasket,
              icon: const Icon(Icons.add),
              label: const Text('Create Basket'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasketSelector() {
    final selectedBasket = _baskets.firstWhere(
      (b) => b['id'] == _selectedBasketId,
      orElse: () => _baskets.first,
    );
    final basketName = selectedBasket['basketName'] as String;
    final holdingsCount = (selectedBasket['holdings'] as List?)?.length ?? 0;

    return InkWell(
      onTap: _showBasketSelectionDialog,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppTheme.lightTheme.primaryColor.withOpacity(0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.primaryColor.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.shopping_basket_rounded,
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    basketName,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                      color: AppTheme.lightTheme.primaryColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.pie_chart_rounded,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '$holdingsCount stocks',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.arrow_drop_down,
                color: AppTheme.lightTheme.primaryColor,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80.w,
            color: AppTheme.lightTheme.primaryColor.withOpacity(0.3),
          ),
          SizedBox(height: 16.h),
          Text(
            'No stocks found',
            style: TextStyle(
              fontSize: 18.sp,
              color: AppTheme.lightTheme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (_searchCtrl.text.isNotEmpty) ...[
            SizedBox(height: 8.h),
            TextButton(
              onPressed: () {
                _searchCtrl.clear();
                _filterStocks();
              },
              child: Text(
                'Clear search',
                style: TextStyle(color: AppTheme.lightTheme.primaryColor),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStockCard(Map<String, dynamic> stock) {
    final stockId = stock['id'] as int;
    final isInBasket = _basketStockIds.contains(stockId);
    final name = stock['name'] ?? 'Unknown';
    final symbol = stock['symbol'] ?? '';
    final exchange = stock['exchange'] ?? 'NSE';

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      elevation: 2,
      shadowColor: AppTheme.lightTheme.primaryColor.withOpacity(0.1),
      child: InkWell(
        onTap: () {
          // Navigate to TradeChartScreen when stock card is tapped
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TradeChartScreen(
                exchange: exchange,
                symbol: symbol,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              // Leading Icon
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: isInBasket
                      ? Colors.green.withOpacity(0.1)
                      : AppTheme.lightTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  isInBasket ? Icons.check_circle : Icons.show_chart,
                  color: isInBasket
                      ? Colors.green
                      : AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
              ),
              SizedBox(width: 12.w),

              // Stock Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp,
                        color: AppTheme.lightTheme.primaryColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Text(
                          symbol,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13.sp,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            exchange,
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Trailing Actions
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isInBasket)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                        border:
                            Border.all(color: Colors.green.withOpacity(0.3)),
                      ),
                      child: Text(
                        'Added',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  SizedBox(width: 8.w),

                  // Add/Remove Button
                  GestureDetector(
                    onTap: _selectedBasketId == null
                        ? null
                        : () {
                            if (isInBasket) {
                              _removeStockFromBasket(stockId);
                            } else {
                              _addStockToBasket(stock);
                            }
                          },
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: isInBasket
                            ? Colors.red.withOpacity(0.1)
                            : Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        isInBasket ? Icons.remove_circle : Icons.add_circle,
                        color: isInBasket ? Colors.red : Colors.green,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
