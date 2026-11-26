// ignore_for_file: file_names, camel_case_types, unnecessary_string_interpolations, unnecessary_non_null_assertion, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/drawer/home/dashbord_Controller.dart';
import 'package:rukmini/controller/api/controllers/metal/metal_Controller.dart';
import 'package:rukmini/controller/api/controllers/drawer/all_master/locker_master/lockerList_Controller.dart';
import 'package:rukmini/controller/api/controllers/product/product_Controller.dart';
import 'package:rukmini/controller/ui/widget/drawerControllerUI.dart';
import 'package:rukmini/modal/product/productList_Modal.dart';
import 'package:rukmini/view/utils/app_color.dart';
import 'package:rukmini/view/utils/app_icon.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/app_string.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/drawer.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';

// Shader-safe Native Skeleton Loader (WebGL & CanvasKit compatible)
class SkeletonLoader extends StatefulWidget {
  final double height;
  final double width;
  final double borderRadius;

  const SkeletonLoader({
    super.key,
    required this.height,
    this.width = double.infinity,
    this.borderRadius = 8.0,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.35,
      end: 0.85,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: AppColor.grey300.withOpacity(_animation.value),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        );
      },
    );
  }
}

class productDetail extends StatefulWidget {
  const productDetail({super.key});

  @override
  State<productDetail> createState() => _productDetailState();
}

class _productDetailState extends State<productDetail> {
  final ProductController productController =
      Get.isRegistered<ProductController>()
          ? Get.find<ProductController>()
          : Get.put(ProductController(), permanent: true);
  final DashbordController dashbordController =
      Get.isRegistered<DashbordController>()
          ? Get.find<DashbordController>()
          : Get.put(DashbordController(), permanent: true);
  final MetalController metalController = Get.isRegistered<MetalController>()
      ? Get.find<MetalController>()
      : Get.put(MetalController(), permanent: true);
  final LockerListController lockerController =
      Get.isRegistered<LockerListController>()
          ? Get.find<LockerListController>()
          : Get.put(LockerListController(), permanent: true);

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  // Filters State
  String _selectedMetal = AppString.allMetal;
  String _selectedStatus = AppString.allStatus;
  String _selectedLocker = AppString.allLocker;
  DateTimeRange? _selectedDateRange;

  // View mode
  bool _isGridView = false;

  // Pagination & Selection
  int _currentPage = 1;
  int _itemsPerPage = 10;
  bool _selectAll = false;
  final Set<String> _selectedItemIds = {};
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final args = NavDrawerController.getRouteArguments(context);
      if (args != null && args is int) {
        if (args == 0) _selectedStatus = "Pending";
        if (args == 1) _selectedStatus = "In Stock";
        if (args == 2) _selectedStatus = "Sold";
        if (args == 3) _selectedStatus = "Karkit";
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchData(isRefresh: true);
      });
      _isInitialized = true;
    }
  }

  Future<void> _fetchData({bool isRefresh = false}) async {
    String? apiFilter;
    if (_selectedStatus == "Pending") apiFilter = "Pending";
    if (_selectedStatus == "In Stock" || _selectedStatus == "Return") {
      apiFilter = "Return";
    }
    if (_selectedStatus == "Sold") apiFilter = "Sold";
    if (_selectedStatus == "Karkit") apiFilter = "Karkit";
    if (_selectedStatus == AppString.allStatus) apiFilter = "All";

    if (productController.products.isEmpty) {
      productController.isLoading.value = true;
    }

    // Parallel background fetching for maximum performance
    await Future.wait([
      CallApi.callProductList(
        isRefresh: isRefresh,
        search: _searchController.text.trim(),
        filterType: apiFilter,
      ),
      dashbordController.dashbord(),
      metalController.getMetalList(),
      CallApi.callLockerList(),
    ]);

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Helper formatting methods
  String _formatCurrency(String? amountStr) {
    if (amountStr == null || amountStr.isEmpty) return "0.00";
    final double? val = double.tryParse(amountStr.replaceAll(',', ''));
    if (val == null) return amountStr;
    final formatter = NumberFormat("#,##,##0.00", "en_IN");
    return formatter.format(val);
  }

  String _getProductName(ProductListData item) {
    if (item.custName != null && item.custName!.trim().isNotEmpty) {
      if (item.prodType != null &&
          item.prodType!.trim().isNotEmpty &&
          !item.custName!.toLowerCase().contains(
            item.prodType!.toLowerCase(),
          )) {
        return "${item.custName} ${item.prodType}";
      }
      return item.custName!;
    }
    if (item.catName != null && item.catName!.trim().isNotEmpty) {
      return "${item.catName} ${item.prodType ?? ''}".trim();
    }
    return "Product #${item.productId ?? item.uniqueId ?? ''}";
  }

  String _getStatusText(ProductListData item) {
    if (item.badDept == "1") return "Sold";
    if (item.isReturn == "1") return "In Stock";
    if (item.prodType?.toLowerCase() == "karkit") return "Karkit";
    return "Pending";
  }

  List<ProductListData> _getFilteredProducts(
    List<ProductListData> rawProducts,
  ) {
    List<ProductListData> list = List.from(rawProducts);

    // Search filter
    if (_searchController.text.trim().isNotEmpty) {
      final query = _searchController.text.trim().toLowerCase();
      list = list.where((item) {
        final name = _getProductName(item).toLowerCase();
        final code = (item.uniqueId ?? item.productId ?? '').toLowerCase();
        final locker = (item.lockerCode ?? '').toLowerCase();
        final metal = (item.metalName ?? '').toLowerCase();
        return name.contains(query) ||
            code.contains(query) ||
            locker.contains(query) ||
            metal.contains(query);
      }).toList();
    }

    // Metal filter
    if (_selectedMetal != AppString.allMetal) {
      list = list
          .where(
            (item) =>
                item.metalName?.toLowerCase() == _selectedMetal.toLowerCase(),
          )
          .toList();
    }

    // Status filter
    if (_selectedStatus != AppString.allStatus) {
      list = list.where((item) {
        final st = _getStatusText(item).toLowerCase();
        return st == _selectedStatus.toLowerCase();
      }).toList();
    }

    // Locker filter
    if (_selectedLocker != AppString.allLocker) {
      list = list
          .where(
            (item) =>
                item.lockerCode?.toLowerCase() == _selectedLocker.toLowerCase(),
          )
          .toList();
    }

    // Date Range filter
    if (_selectedDateRange != null) {
      list = list.where((item) {
        if (item.givenDate == null) return false;
        try {
          final parsedDate = DateTime.parse(item.givenDate!);
          return parsedDate.isAfter(
                _selectedDateRange!.start.subtract(const Duration(days: 1)),
              ) &&
              parsedDate.isBefore(
                _selectedDateRange!.end.add(const Duration(days: 1)),
              );
        } catch (_) {
          return true;
        }
      }).toList();
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktopOrTablet = AppSize.isDesktop || AppSize.isTablet;

    return Obx(() {
      final isLoading = productController.isLoading.value;
      final rawProducts = productController.products.toList();
      final filteredList = _getFilteredProducts(rawProducts);

      final totalItems = filteredList.length;
      final totalPages = (totalItems / _itemsPerPage).ceil().clamp(1, 9999);
      if (_currentPage > totalPages) _currentPage = totalPages;

      final startIndex = (_currentPage - 1) * _itemsPerPage;
      final endIndex = (startIndex + _itemsPerPage).clamp(0, totalItems);
      final currentPageItems = (startIndex < totalItems)
          ? filteredList.sublist(startIndex, endIndex)
          : <ProductListData>[];

      return Fullscreen(
        drawer: homeDrawer(),
        isPadding: false,
        backGroundcolor: AppColor.tableBg,
        appBar: appBar(back: true, title: AppString.products),
        child: RefreshIndicator(
          onRefresh: () => _fetchData(isRefresh: true),
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(isDesktopOrTablet ? 24.0 : 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Breadcrumb & Header Title Area
                _buildHeader(isDesktopOrTablet),
                const SizedBox(height: 20),

                // 2. Metric Summary Cards (Total Products, In Stock, Pending, Sold)
                _buildStatCardsRow(isDesktopOrTablet),
                const SizedBox(height: 20),

                // 3. Search and Filters Card
                _buildSearchAndFiltersCard(isDesktopOrTablet),
                const SizedBox(height: 20),

                // 4. Content Area Container (Controls Bar + Table/Grid + Pagination)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColor.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColor.border),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.black.withOpacity(AppColor.isDark ? 0.3 : 0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Controls Row (Showing X-Y of Z, View Switcher, Export, Add Product)
                      _buildControlsRow(
                        isDesktopOrTablet,
                        totalItems,
                        startIndex,
                        endIndex,
                      ),

                      // Main Content (Table or Grid)
                      isLoading && rawProducts.isEmpty
                          ? _shimmerLoading()
                          : filteredList.isEmpty
                          ? _buildEmptyState()
                          : _isGridView
                          ? _buildGridView(currentPageItems, isDesktopOrTablet)
                          : _buildTableView(
                              currentPageItems,
                              isDesktopOrTablet,
                            ),

                      // Pagination Footer Bar
                      if (filteredList.isNotEmpty)
                        _buildPaginationFooter(
                          isDesktopOrTablet,
                          totalItems,
                          totalPages,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      );
    });
  }

  // 1. Header with Breadcrumb & Decorative Banner
  Widget _buildHeader(bool isDesktopOrTablet) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isDesktopOrTablet ? 24 : 16),
      decoration: BoxDecoration(
        color: AppColor.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.border),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(AppColor.isDark ? 0.3 : 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb
          Row(
            children: [
              Icon(AppIcon.home, size: 16, color: AppColor.textMuted),
              SizedBox(width: 6),
              Text(
                AppString.home,
                style: TextStyle(
                  color: AppColor.textMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 6),
              Icon(AppIcon.chevronRight, size: 16, color: AppColor.textLight),
              SizedBox(width: 6),
              Text(
                AppString.products,
                style: TextStyle(
                  color: AppColor.textDark,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColor.goldColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  AppIcon.inventory,
                  color: AppColor.goldColor,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.products,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColor.mainText,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppString.manageProductsSubtitle,
                      style: TextStyle(fontSize: 14, color: AppColor.subText),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 2. Metric Cards Row
  Widget _buildStatCardsRow(bool isDesktopOrTablet) {
    final dashData = dashbordController.dashboardData.value.data;

    final String totalProductsCount =
        productController.productListData.value.totalCount?.toString() ??
        dashData?.totalPendingProduct ??
        "${productController.products.length}";
    final String inStockCount = dashData?.totalReturnProduct ?? "982";
    final String pendingCount = dashData?.totalPendingProduct ?? "136";
    final String soldCount = dashData?.totalSold?.toString() ?? "130";

    final cards = [
      _statCard(
        title: AppString.totalProducts,
        count: totalProductsCount,
        icon: AppIcon.inventory,
        iconBg: AppColor.orangeLightBg,
        iconColor: AppColor.orangeText,
      ),
      _statCard(
        title: AppString.returnProduct,
        count: inStockCount,
        icon: AppIcon.checkCircleOutline,
        iconBg: AppColor.greenLightBg,
        iconColor: AppColor.greenText,
      ),
      _statCard(
        title: AppString.pending,
        count: pendingCount,
        icon: AppIcon.accessTime,
        iconBg: AppColor.yellowLightBg,
        iconColor: AppColor.yellowText,
      ),
      _statCard(
        title: AppString.soldProduct,
        count: soldCount,
        icon: AppIcon.taskAlt,
        iconBg: AppColor.purpleLightBg,
        iconColor: AppColor.purpleText,
      ),
    ];

    if (isDesktopOrTablet) {
      return Row(
        children: cards
            .map(
              (c) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: c,
                ),
              ),
            )
            .toList(),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: cards
            .map(
              (c) => Container(
                width: 220,
                margin: const EdgeInsets.only(right: 12),
                child: c,
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _statCard({
    required String title,
    required String count,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.border),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(AppColor.isDark ? 0.3 : 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColor.textMuted,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  count,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textDark,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 3. Search and Filters Row Card
  Widget _buildSearchAndFiltersCard(bool isDesktopOrTablet) {
    // Generate Metal Options
    final metalOptions = [AppString.allMetal];
    for (var p in productController.products) {
      if (p.metalName != null &&
          p.metalName!.trim().isNotEmpty &&
          !metalOptions.contains(p.metalName!.trim())) {
        metalOptions.add(p.metalName!.trim());
      }
    }
    if (metalOptions.length == 1) {
      metalOptions.addAll(["Gold", "Silver", "Diamond"]);
    }

    // Generate Locker Options
    final lockerOptions = [AppString.allLocker];
    if (lockerController.lockerList.isNotEmpty) {
      for (var l in lockerController.lockerList) {
        if (l.lockerCode != null && !lockerOptions.contains(l.lockerCode)) {
          lockerOptions.add(l.lockerCode!);
        }
      }
    }
    for (var p in productController.products) {
      if (p.lockerCode != null &&
          p.lockerCode!.trim().isNotEmpty &&
          !lockerOptions.contains(p.lockerCode!.trim())) {
        lockerOptions.add(p.lockerCode!.trim());
      }
    }
    if (lockerOptions.length == 1) {
      lockerOptions.addAll([
        "M-9",
        "D-9",
        "N-128",
        "M-6",
        "M-10",
        "D-4",
        "M-5",
        "M-8",
      ]);
    }

    final statusOptions = [
      AppString.allStatus,
      "Pending",
      "In Stock",
      "Sold",
      "Karkit",
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.border),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(AppColor.isDark ? 0.3 : 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          // Search Input
          SizedBox(
            width: isDesktopOrTablet ? 360 : double.infinity,
            child: TextField(
              controller: _searchController,
              onChanged: (_) {
                setState(() {});
                _fetchData(isRefresh: true);
              },
              decoration: InputDecoration(
                hintText: AppString.searchPlaceholderProduct,
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: AppColor.textLight,
                ),
                prefixIcon: Icon(
                  AppIcon.searchOutline,
                  color: AppColor.textMuted,
                  size: 20,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(AppIcon.clearIcon, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                          _fetchData(isRefresh: true);
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColor.tableBg,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColor.tableBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColor.goldColor,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),

          // Dropdown: All Metal
          _buildDropdownFilter(
            icon: AppIcon.layers,
            value: _selectedMetal,
            items: metalOptions,
            onChanged: (val) =>
                setState(() => _selectedMetal = val ?? AppString.allMetal),
          ),

          // Dropdown: All Status
          _buildDropdownFilter(
            icon: AppIcon.sellOutline,
            value: _selectedStatus,
            items: statusOptions,
            onChanged: (val) {
              if (val != null) {
                setState(() => _selectedStatus = val);
                _fetchData(isRefresh: true);
              }
            },
          ),

          // Dropdown: All Locker
          _buildDropdownFilter(
            icon: AppIcon.lockOutline,
            value: _selectedLocker,
            items: lockerOptions,
            onChanged: (val) =>
                setState(() => _selectedLocker = val ?? AppString.allLocker),
          ),

          // Date Range Selector Button
          OutlinedButton.icon(
            onPressed: () async {
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                initialDateRange: _selectedDateRange,
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: AppColor.goldColor,
                        onPrimary: AppColor.white,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                setState(() => _selectedDateRange = picked);
              }
            },
            icon: Icon(
              AppIcon.calendarOutline,
              size: 16,
              color: AppColor.textMedium,
            ),
            label: Text(
              _selectedDateRange == null
                  ? AppString.dateRange
                  : "${DateFormat('dd MMM').format(_selectedDateRange!.start)} - ${DateFormat('dd MMM').format(_selectedDateRange!.end)}",
              style: TextStyle(
                fontSize: 13,
                color: _selectedDateRange == null
                    ? AppColor.textMedium
                    : AppColor.goldColor,
                fontWeight: _selectedDateRange == null
                    ? FontWeight.normal
                    : FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              side: BorderSide(
                color: _selectedDateRange == null
                    ? AppColor.tableBorder
                    : AppColor.goldColor,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: AppColor.tableBg,
            ),
          ),

          // Filter Reset Button
          IconButton(
            tooltip: AppString.reset,
            onPressed: () {
              setState(() {
                _searchController.clear();
                _selectedMetal = AppString.allMetal;
                _selectedStatus = AppString.allStatus;
                _selectedLocker = AppString.allLocker;
                _selectedDateRange = null;
              });
              _fetchData(isRefresh: true);
            },
            icon: Icon(AppIcon.tune, color: AppColor.textMuted),
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: AppColor.tableBorder),
              ),
              backgroundColor: AppColor.tableBg,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownFilter({
    required IconData icon,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: AppColor.tableBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.tableBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : items.first,
          icon: Icon(
            AppIcon.arrowDownRounded,
            size: 18,
            color: AppColor.textMuted,
          ),
          style: TextStyle(
            fontSize: 13,
            color: AppColor.textSecondary,
            fontWeight: FontWeight.w500,
          ),
          onChanged: onChanged,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 16, color: AppColor.textMuted),
                  const SizedBox(width: 8),
                  Text(item),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // 4. Controls Row Above Table
  Widget _buildControlsRow(
    bool isDesktopOrTablet,
    int totalItems,
    int startIndex,
    int endIndex,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColor.tableDivider)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Showing X - Y of Z products
          Text(
            totalItems == 0
                ? "${AppString.showingProducts} 0 ${AppString.products.toLowerCase()}"
                : "${AppString.showingProducts} ${startIndex + 1} – $endIndex of $totalItems ${AppString.products.toLowerCase()}",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColor.textMedium,
            ),
          ),

          // Actions Right: View Switcher, Export, Add Product
          Row(
            children: [
              // List / Grid View Switcher
              Container(
                decoration: BoxDecoration(
                  color: AppColor.tableDivider,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(3),
                child: Row(
                  children: [
                    _viewToggleButton(
                      icon: AppIcon.listBulleted,
                      label: AppString.list,
                      isSelected: !_isGridView,
                      onTap: () => setState(() => _isGridView = false),
                    ),
                    _viewToggleButton(
                      icon: AppIcon.gridView,
                      label: AppString.grid,
                      isSelected: _isGridView,
                      onTap: () => setState(() => _isGridView = true),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Export Button
              OutlinedButton.icon(
                onPressed: () {
                  Get.snackbar(
                    AppString.export,
                    AppString.exportingProductsCsv,
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColor.goldColor,
                    colorText: AppColor.white,
                    margin: const EdgeInsets.all(16),
                  );
                },
                icon: Icon(
                  AppIcon.fileDownload,
                  size: 18,
                  color: AppColor.textMedium,
                ),
                label: isDesktopOrTablet
                    ? Text(
                        AppString.export,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColor.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : const SizedBox.shrink(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  side: BorderSide(color: AppColor.tableBorder),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Add Product Button
              ElevatedButton.icon(
                onPressed: () {
                  NavDrawerController.toNamed('/AddProduct');
                },
                icon: const Icon(
                  AppIcon.addRounded,
                  size: 20,
                  color: AppColor.white,
                ),
                label: const Text(
                  AppString.addProduct,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColor.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.goldColor,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _viewToggleButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.goldColor : AppColor.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppColor.white : AppColor.textMuted,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColor.white : AppColor.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 5. Data Table View
  Widget _buildTableView(List<ProductListData> items, bool isDesktopOrTablet) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: Theme(
              data: Theme.of(context)
                  .copyWith(dividerColor: AppColor.tableDivider),
              child: DataTable(
                showCheckboxColumn: false,
                headingRowColor:
                    WidgetStateProperty.all(AppColor.tableHeaderBg),
                headingRowHeight: 48,
                dataRowHeight: 64,
                horizontalMargin: 20,
                columnSpacing: 24,
                columns: [
                  DataColumn(
                    label: Checkbox(
                      value: _selectAll,
                      activeColor: AppColor.goldColor,
                      onChanged: (val) {
                        setState(() {
                          _selectAll = val ?? false;
                          if (_selectAll) {
                            _selectedItemIds.addAll(
                              items.map(
                                  (e) => e.productId ?? e.uniqueId ?? ''),
                            );
                          } else {
                            _selectedItemIds.clear();
                          }
                        });
                      },
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "#",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColor.mainText,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      AppString.products,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColor.mainText,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      AppString.productCode,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColor.mainText,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      AppString.metal,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColor.mainText,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      AppString.weightGm,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColor.mainText,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      AppString.rateRs,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColor.mainText,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      AppString.locker,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColor.mainText,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      AppString.status,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColor.mainText,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      AppString.date,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColor.mainText,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      AppString.actions,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColor.mainText,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
                rows: List.generate(items.length, (index) {
                  final item = items[index];
                  final id = item.productId ?? item.uniqueId ?? '$index';
                  final isChecked = _selectedItemIds.contains(id);
                  final rowIndex =
                      (_currentPage - 1) * _itemsPerPage + index + 1;

                  return DataRow(
                    selected: isChecked,
                    cells: [
                      // Single Checkbox
                      DataCell(
                        Checkbox(
                          value: isChecked,
                          activeColor: AppColor.goldColor,
                          onChanged: (val) {
                            setState(() {
                              if (val == true) {
                                _selectedItemIds.add(id);
                              } else {
                                _selectedItemIds.remove(id);
                              }
                            });
                          },
                        ),
                      ),

                      // Index
                      DataCell(
                        Text(
                          "$rowIndex",
                          style: TextStyle(
                            color: AppColor.subText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      // Product (Image + Name)
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColor.orangeLightBg,
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: AppColor.orangeBorder),
                              ),
                              child: const Icon(
                                AppIcon.inventory,
                                color: AppColor.goldColor,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _getProductName(item),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColor.mainText,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Product Code
                      DataCell(
                        Text(
                          item.uniqueId ?? item.productId ?? AppString.na,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w600,
                            color: AppColor.subText,
                            fontSize: 13,
                          ),
                        ),
                      ),

                      // Metal Pill
                      DataCell(_metalPillTag(item.metalName ?? "Gold")),

                      // Weight (gm)
                      DataCell(
                        Text(
                          item.weight ?? "0.00",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColor.mainText,
                            fontSize: 13,
                          ),
                        ),
                      ),

                      // Rate (₹)
                      DataCell(
                        Text(
                          "${_formatCurrency(item.todayRate ?? item.origAmount ?? item.givenAmount)}.00",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColor.mainText,
                            fontSize: 13,
                          ),
                        ),
                      ),

                      // Locker Code
                      DataCell(
                        Text(
                          item.lockerCode ?? AppString.na,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColor.subText,
                            fontSize: 13,
                          ),
                        ),
                      ),

                      // Status Pill
                      DataCell(_statusPillTag(_getStatusText(item))),

                      // Date
                      DataCell(
                        Text(
                          item.givenDate ?? item.returnDate ?? AppString.na,
                          style: TextStyle(
                            color: AppColor.subText,
                            fontSize: 13,
                          ),
                        ),
                      ),

                      // Actions
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                AppIcon.eyeOutline,
                                size: 18,
                                color: AppColor.mainText,
                              ),
                              tooltip: AppString.viewDetails,
                              onPressed: () =>
                                  _showProductDetailsDialog(item),
                            ),
                            IconButton(
                              icon: Icon(
                                AppIcon.editOutline,
                                size: 18,
                                color: AppColor.mainText,
                              ),
                              tooltip: AppString.editProduct,
                              onPressed: () {
                                NavDrawerController.toNamed('/AddProduct');
                              },
                            ),
                            PopupMenuButton<String>(
                              icon: Icon(
                                AppIcon.moreVert,
                                size: 18,
                                color: AppColor.mainText,
                              ),
                              onSelected: (val) {
                                if (val == 'view') {
                                  _showProductDetailsDialog(item);
                                }
                                if (val == 'edit') {
                                  NavDrawerController.toNamed('/AddProduct');
                                }
                                if (val == 'locker') {
                                  NavDrawerController.toNamed(
                                      '/changeTheLocker');
                                }
                              },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'view',
                            child: Text(AppString.viewDetails),
                          ),
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text(AppString.editProduct),
                          ),
                          const PopupMenuItem(
                            value: 'locker',
                            child: Text(AppString.changeLocker),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    ),
  );
},
);
}

  // Metal Pill Tag Widget
  Widget _metalPillTag(String metalName) {
    final bool isGold = metalName.toLowerCase().contains("gold");
    final Color tagBg = isGold ? AppColor.goldTagBg : AppColor.tableDivider;
    final Color tagDot = isGold ? AppColor.goldTagDot : AppColor.textMuted;
    final Color tagText = isGold
        ? AppColor.goldTagText
        : AppColor.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: tagBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: tagDot, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            metalName,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: tagText,
            ),
          ),
        ],
      ),
    );
  }

  // Status Pill Tag Widget
  Widget _statusPillTag(String status) {
    Color bg;
    Color text;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'sold':
        bg = AppColor.greenTagBg;
        text = AppColor.greenTagText;
        icon = AppIcon.checkCircleFilled;
        break;
      case 'pending':
        bg = AppColor.goldTagBg;
        text = AppColor.goldTagText;
        icon = AppIcon.accessTime;
        break;
      case 'karkit':
        bg = AppColor.purpleLightBg;
        text = AppColor.purpleText;
        icon = AppIcon.inventoryRounded;
        break;
      case 'in stock':
      case 'return':
      default:
        bg = AppColor.blueTagBg;
        text = AppColor.blueTagText;
        icon = AppIcon.inventory;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: text),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: text,
            ),
          ),
        ],
      ),
    );
  }

  // 6. Grid View
  Widget _buildGridView(List<ProductListData> items, bool isDesktopOrTablet) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isDesktopOrTablet ? 3 : 1,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          mainAxisExtent: 270,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColor.tableBorder),
              boxShadow: [
                BoxShadow(
                  color: AppColor.black.withOpacity(0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Metal tag & Status Tag
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _metalPillTag(item.metalName ?? "Gold"),
                    _statusPillTag(_getStatusText(item)),
                  ],
                ),
                const SizedBox(height: 12),

                // Main Info: Image + Product Name & Code
                Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppColor.orangeLightBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        AppIcon.inventory,
                        color: AppColor.goldColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getProductName(item),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: AppColor.textDark,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "${AppString.codeColon}${item.uniqueId ?? item.productId ?? AppString.na}",
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColor.textMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Divider(height: 1, color: AppColor.tableDivider),
                const SizedBox(height: 8),

                // Key Info: Weight, Rate, Locker
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppString.weight,
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColor.textLight,
                          ),
                        ),
                        Text(
                          "${item.weight ?? '0.00'} gm",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppString.rate,
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColor.textLight,
                          ),
                        ),
                        Text(
                          "₹${_formatCurrency(item.todayRate ?? item.origAmount)}.00",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColor.goldColor,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppString.locker,
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColor.textLight,
                          ),
                        ),
                        Text(
                          item.lockerCode ?? AppString.na,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Bottom Row Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.givenDate ?? AppString.na,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColor.textLight,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            AppIcon.eyeOutline,
                            size: 18,
                            color: AppColor.textMuted,
                          ),
                          onPressed: () => _showProductDetailsDialog(item),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          icon: Icon(
                            AppIcon.editOutline,
                            size: 18,
                            color: AppColor.textMuted,
                          ),
                          onPressed: () =>
                              NavDrawerController.toNamed('/AddProduct'),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 7. Pagination Footer Bar
  Widget _buildPaginationFooter(
    bool isDesktopOrTablet,
    int totalItems,
    int totalPages,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColor.tableDivider)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous / Page Numbers / Next
          Row(
            children: [
              // Previous Button
              IconButton(
                icon: const Icon(AppIcon.chevronLeft, size: 20),
                onPressed: _currentPage > 1
                    ? () => setState(() => _currentPage--)
                    : null,
                style: IconButton.styleFrom(
                  backgroundColor: AppColor.tableBg,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: AppColor.tableBorder),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Page Numbers
              ...List.generate(totalPages > 5 ? 5 : totalPages, (index) {
                final pageNum = index + 1;
                final isCurrent = pageNum == _currentPage;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: InkWell(
                    onTap: () => setState(() => _currentPage = pageNum),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 34,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? AppColor.goldColor
                            : AppColor.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "$pageNum",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isCurrent
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: isCurrent
                              ? AppColor.white
                              : AppColor.textMedium,
                        ),
                      ),
                    ),
                  ),
                );
              }),

              if (totalPages > 5) ...[
                Text(
                  "...",
                  style: TextStyle(color: AppColor.textLight),
                ),
                InkWell(
                  onTap: () => setState(() => _currentPage = totalPages),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 34,
                    height: 34,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _currentPage == totalPages
                          ? AppColor.goldColor
                          : AppColor.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "$totalPages",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: _currentPage == totalPages
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: _currentPage == totalPages
                            ? AppColor.white
                            : AppColor.textMedium,
                      ),
                    ),
                  ),
                ),
              ],

              const SizedBox(width: 8),

              // Next Button
              IconButton(
                icon: const Icon(AppIcon.chevronRightRounded, size: 20),
                onPressed: _currentPage < totalPages
                    ? () => setState(() => _currentPage++)
                    : null,
                style: IconButton.styleFrom(
                  backgroundColor: AppColor.tableBg,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: AppColor.tableBorder),
                  ),
                ),
              ),
            ],
          ),

          // Items Per Page Selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: AppColor.tableBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColor.tableBorder),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: _itemsPerPage,
                icon: Icon(
                  AppIcon.arrowDownRounded,
                  size: 18,
                  color: AppColor.textMuted,
                ),
                style: TextStyle(
                  fontSize: 13,
                  color: AppColor.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _itemsPerPage = val;
                      _currentPage = 1;
                    });
                  }
                },
                items: [10, 25, 50, 100].map((int count) {
                  return DropdownMenuItem<int>(
                    value: count,
                    child: Text("$count / page"),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Details Dialog
  void _showProductDetailsDialog(ProductListData item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColor.goldColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(AppIcon.inventory, color: AppColor.goldColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getProductName(item),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${AppString.codeColon}${item.uniqueId ?? item.productId ?? AppString.na}",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColor.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(),
                _detailRow(AppString.productName, _getProductName(item)),
                _detailRow(
                  AppString.productCode,
                  item.uniqueId ?? item.productId ?? AppString.na,
                ),
                _detailRow(AppString.metalName, item.metalName ?? "Gold"),
                _detailRow(
                  AppString.productType,
                  item.prodType ?? AppString.na,
                ),
                _detailRow(AppString.weightGm, "${item.weight ?? '0.00'} gm"),
                _detailRow(
                  AppString.todaysRate,
                  "₹${_formatCurrency(item.todayRate ?? item.origAmount)}.00",
                ),
                _detailRow(
                  AppString.lockerCode,
                  item.lockerCode ?? AppString.na,
                ),
                _detailRow(AppString.status, _getStatusText(item)),
                _detailRow(
                  AppString.date,
                  item.givenDate ?? item.returnDate ?? AppString.na,
                ),
                _detailRow(AppString.pcs, item.pieces ?? "1"),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                AppString.close,
                style: TextStyle(
                  color: AppColor.goldColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: AppColor.textMuted, fontSize: 13),
          ),
          Text(
            value,
            style:  TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: AppColor.textDark,
            ),
          ),
        ],
      ),
    );
  }

  // Empty State Widget
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(48),
      child: Center(
        child: Column(
          children: [
            Icon(AppIcon.searchOff, size: 56, color: AppColor.textLight),
            SizedBox(height: 16),
            Text(
              AppString.noProductsFound,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColor.textSecondary,
              ),
            ),
            SizedBox(height: 4),
            Text(
              AppString.tryAdjustingSearch,
              style: TextStyle(fontSize: 13, color: AppColor.textLight),
            ),
          ],
        ),
      ),
    );
  }

  // Shimmer Loading Widget
  Widget _shimmerLoading() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: List.generate(
          6,
          (i) => const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: SkeletonLoader(height: 52, borderRadius: 10),
          ),
        ),
      ),
    );
  }
}
