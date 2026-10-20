// ignore_for_file: file_names, camel_case_types, unnecessary_string_interpolations, unnecessary_non_null_assertion, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/ui/widget/drawerControllerUI.dart';
import 'package:rukmini/controller/api/controllers/product/product_Controller.dart';
import 'package:rukmini/modal/product/productList_Modal.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/drawer.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:shimmer/shimmer.dart';

class productDetail extends StatefulWidget {
  const productDetail({super.key});

  @override
  State<productDetail> createState() => _productDetailState();
}

class _productDetailState extends State<productDetail>
    with TickerProviderStateMixin {
  final productController = Get.put(ProductController());
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  final List<String> _tabs = ["Pending", "Return", "Sold", "Karkit"];
  final TextEditingController _searchController = TextEditingController();
  final RxBool _isSearching = false.obs;

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: 0,
    );
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        fetchData(isRefresh: true);
        if (mounted) setState(() {});
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!productController.isMoreLoading.value &&
            productController.hasMoreData.value) {
          fetchData(isLoadMore: true);
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final args = NavDrawerController.getRouteArguments(context);
      int initialIndex = (args != null && args is int) ? args : 0;
      if (initialIndex >= 0 && initialIndex < _tabs.length) {
        _tabController.index = initialIndex;
      }
      fetchData(index: initialIndex);
      _isInitialized = true;
    }
  }

  Future<void> fetchData({
    int? index,
    bool isRefresh = false,
    bool isLoadMore = false,
  }) async {
    int targetIndex = index ?? _tabController.index;
    await CallApi.callProductList(
      isRefresh: isRefresh,
      search: _searchController.text,
      filterType: _tabs[targetIndex],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktopOrTablet = AppSize.isDesktop || AppSize.isTablet;

    return Obx(() {
      return Fullscreen(
        drawer: homeDrawer(),
        isPadding: false,
        backGroundcolor: AppColor.backgroundColor,
        appBar: appBar(
          title: _isSearching.value
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: TextStyle(
                    color: AppColor.black,
                    fontSize: isDesktopOrTablet ? 15.0 : AppSize.commonText,
                  ),
                  cursorColor: AppColor.goldColor,
                  decoration: InputDecoration(
                    hintText: AppString.searchProduct,
                    hintStyle: TextStyle(
                      color: AppColor.textColor.withOpacity(0.5),
                      fontSize: isDesktopOrTablet ? 14.0 : AppSize.commonText,
                    ),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    fetchData(isRefresh: true);
                  },
                )
              : AppString.products,
          searchIcon: true,
          searchOnPressed: () {
            _isSearching.value = !_isSearching.value;
            if (!_isSearching.value) {
              _searchController.clear();
              fetchData(isRefresh: true);
            }
          },
          bottom: isDesktopOrTablet
              ? null
              : PreferredSize(
                  preferredSize: Size.fromHeight(AppSize.width * 0.15),
                  child: Container(
                    color: AppColor.fullScreenColor,
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: AppColor.goldColor,
                      indicatorWeight: AppSize.p4 * 0.75,
                      labelColor: AppColor.goldColor,
                      unselectedLabelColor: AppColor.textColor,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelPadding: EdgeInsets.zero,
                      tabs: [
                        _buildTab(AppString.pending, AppIcon.product),
                        _buildTab(AppString.returnProduct, AppIcon.refresh),
                        _buildTab(AppString.soldProduct, AppIcon.checkCircle),
                        _buildTab(AppString.karkitProduct, AppIcon.inventory),
                      ],
                    ),
                  ),
                ),
        ),
        child: isDesktopOrTablet
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Side: Product Grid Content
                  Expanded(
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children: List.generate(_tabs.length, (index) {
                        return _buildTabContent(index);
                      }),
                    ),
                  ),

                  // Right Side: Filter Selector Panel for Desktop
                  Container(
                    width: 240,
                    margin: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            AppString.products,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: AppColor.goldColor,
                            ),
                          ),
                        ),
                        const Divider(),
                        const SizedBox(height: 8),
                        ...List.generate(_tabs.length, (index) {
                          bool isSelected = _tabController.index == index;
                          IconData icon;
                          String label;
                          switch (index) {
                            case 0:
                              icon = AppIcon.product;
                              label = AppString.pending;
                              break;
                            case 1:
                              icon = AppIcon.refresh;
                              label = AppString.returnProduct;
                              break;
                            case 2:
                              icon = AppIcon.checkCircle;
                              label = AppString.soldProduct;
                              break;
                            default:
                              icon = AppIcon.inventory;
                              label = AppString.karkitProduct;
                          }

                          return GestureDetector(
                            onTap: () {
                              _tabController.animateTo(index);
                              setState(() {});
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColor.goldColor.withOpacity(0.12)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                border: isSelected
                                    ? Border.all(
                                        color: AppColor.goldColor,
                                        width: 1.5,
                                      )
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    icon,
                                    color: isSelected
                                        ? AppColor.goldColor
                                        : AppColor.textColor,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    label,
                                    style: TextStyle(
                                      color: isSelected
                                          ? AppColor.goldColor
                                          : AppColor.black,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              )
            : TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: List.generate(_tabs.length, (index) {
                  return _buildTabContent(index);
                }),
              ),
      );
    });
  }

  Widget _buildTabContent(int index) {
    return Obx(() {
      if (productController.isLoading.value &&
          productController.products.isEmpty) {
        return _shimmerLoading();
      }
      final data = productController.products;
      if (data.isEmpty) {
        return const Center(child: Text(AppString.noDataFound));
      }
      return RefreshIndicator(
        onRefresh: () => fetchData(isRefresh: true),
        child: _productList(data),
      );
    });
  }

  Widget _buildTab(String text, IconData icon) {
    return Tab(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: AppSize.p20 + AppSize.p4),
          SizedBox(height: AppSize.p4 / 2),
          Text(
            text,
            style: TextStyle(
              fontSize: AppSize.size12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _productList(List<ProductListData> data) {
    if (AppSize.isDesktop || AppSize.isTablet) {
      return GridView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(AppSize.p16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: AppSize.isDesktop ? 3 : 2,
          crossAxisSpacing: AppSize.p12,
          mainAxisSpacing: AppSize.p12,
          mainAxisExtent: 260,
        ),
        itemCount: data.length + (productController.isMoreLoading.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < data.length) {
            return _productCard(data[index], isGrid: true);
          } else {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(color: AppColor.goldColor),
              ),
            );
          }
        },
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: data.length + (productController.isMoreLoading.value ? 1 : 0),
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.p16,
        vertical: AppSize.p8,
      ),
      itemBuilder: (context, index) {
        if (index < data.length) {
          return _productCard(data[index], isGrid: false);
        } else {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(AppSize.p8),
              child: const CircularProgressIndicator(color: AppColor.goldColor),
            ),
          );
        }
      },
    );
  }

  Widget _productCard(ProductListData item, {bool isGrid = false}) {
    return Container(
      margin: isGrid ? EdgeInsets.zero : EdgeInsets.only(bottom: AppSize.p16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(AppSize.p12),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.05),
            blurRadius: AppSize.p10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSize.p12),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Far left indicator bar
              Container(width: AppSize.p4, color: AppColor.goldColor),
              _buildProductDetails(item),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductDetails(ProductListData item) {
    final bool isDesktopOrTablet = AppSize.isDesktop || AppSize.isTablet;

    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(AppSize.p12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Placeholder
                Container(
                  width: isDesktopOrTablet ? 55 : AppSize.width * 0.18,
                  height: isDesktopOrTablet ? 55 : AppSize.width * 0.18,
                  decoration: BoxDecoration(
                    color: AppColor.whiteOrang.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(AppSize.p8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        AppIcon.camera_alt,
                        color: AppColor.textColor.withOpacity(0.6),
                        size: isDesktopOrTablet ? 18 : AppSize.p24,
                      ),
                      SizedBox(height: isDesktopOrTablet ? 2 : AppSize.p4),
                      Text(
                        AppString.image,
                        style: TextStyle(
                          fontSize: isDesktopOrTablet ? 10 : AppSize.smallText,
                          color: AppColor.textColor.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: AppSize.p12),
                // Top Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isDesktopOrTablet)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.custName ?? "N/A",
                              style: const TextStyle(
                                color: AppColor.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.uniqueId ?? "",
                              style: const TextStyle(
                                color: AppColor.activeColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 13.0,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        )
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item.custName ?? "N/A",
                                style: TextStyle(
                                  color: AppColor.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppSize.size14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              item.uniqueId ?? "",
                              style: TextStyle(
                                color: AppColor.activeColor,
                                fontWeight: FontWeight.w500,
                                fontSize: AppSize.mediumText,
                              ),
                            ),
                            SizedBox(width: AppSize.p4),
                          ],
                        ),
                      SizedBox(height: AppSize.p8),
                      // Metal Chip
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSize.p10,
                          vertical: AppSize.p4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.whiteOrang,
                          borderRadius: BorderRadius.circular(AppSize.p20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              item.metalName?.toLowerCase().contains("gold") ==
                                      true
                                  ? Icons.radio_button_checked
                                  : AppIcon.product,
                              size: isDesktopOrTablet ? 13.0 : AppSize.size14,
                              color: AppColor.goldColor,
                            ),
                            SizedBox(width: AppSize.p4),
                            Text(
                              "${item.metalName} ${item.prodType}",
                              style: TextStyle(
                                color: AppColor.goldColor,
                                fontSize: isDesktopOrTablet ? 12.0 : AppSize.smallText,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: isDesktopOrTablet ? 6 : AppSize.p12),
            const Divider(height: 1),
            SizedBox(height: isDesktopOrTablet ? 6 : AppSize.p12),
            // Vertical Single Column Info Layout
            Column(
              children: [
                _infoItem(
                  AppIcon.calendar,
                  "${AppString.date}:",
                  item.givenDate ?? AppString.na,
                ),
                const SizedBox(height: 4),
                _infoItem(
                  AppIcon.rupee,
                  "${AppString.gvnAmt}:",
                  item.givenAmount ?? "0.00",
                ),
                const SizedBox(height: 4),
                _infoItem(
                  AppIcon.locker,
                  "${AppString.locker}:",
                  item.lockerCode ?? AppString.na,
                ),
                const SizedBox(height: 4),
                _infoItem(
                  AppIcon.weight,
                  "${AppString.weightInGm}:",
                  "${item.weight ?? '0.00'} ${AppString.gm}",
                ),
                const SizedBox(height: 4),
                _infoItem(
                  AppIcon.rupee,
                  "${AppString.rate}:",
                  item.todayRate ?? "0.00",
                ),
                const SizedBox(height: 4),
                _infoItem(
                  AppIcon.category,
                  "${AppString.pcs}:",
                  item.pieces ?? "0",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _infoItem(IconData icon, String label, String value) {
  final bool isDesktopOrTablet = AppSize.isDesktop || AppSize.isTablet;
  return Row(
    children: [
      Icon(icon, size: isDesktopOrTablet ? 16.0 : AppSize.p16, color: AppColor.goldColor),
      SizedBox(width: AppSize.p8),
      Text(
        label,
        style: TextStyle(
          color: AppColor.textColor,
          fontSize: isDesktopOrTablet ? 13.0 : AppSize.size12,
          fontWeight: FontWeight.w400,
        ),
      ),
      SizedBox(width: AppSize.p4),
      Expanded(
        child: Text(
          value,
          style: TextStyle(
            color: AppColor.black,
            fontSize: isDesktopOrTablet ? 13.0 : AppSize.size12,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}

Widget _shimmerLoading() {
  return Shimmer.fromColors(
    baseColor: AppColor.grey300,
    highlightColor: AppColor.white,
    child: ListView.builder(
      itemCount: 6,
      padding: EdgeInsets.all(AppSize.p16),
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: AppSize.p16),
          height: AppSize.height * 0.22,
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(AppSize.p12),
          ),
        );
      },
    ),
  );
}
