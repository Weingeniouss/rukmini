// ignore_for_file: file_names, camel_case_types, unnecessary_string_interpolations, unnecessary_non_null_assertion, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
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

  @override
  void initState() {
    super.initState();
    int initialIndex = Get.arguments ?? 0;
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: initialIndex,
    );
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        fetchData(isRefresh: true);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData(index: initialIndex);
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
                  style: const TextStyle(color: AppColor.black),
                  cursorColor: AppColor.goldColor,
                  decoration: InputDecoration(
                    hintText: AppString.searchProduct,
                    hintStyle: TextStyle(
                      color: AppColor.textColor.withOpacity(0.5),
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
          bottom: PreferredSize(
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
        child: TabBarView(
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
    return ListView.builder(
      controller: _scrollController,
      itemCount: data.length + (productController.isMoreLoading.value ? 1 : 0),
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.p16,
        vertical: AppSize.p8,
      ),
      itemBuilder: (context, index) {
        if (index < data.length) {
          return _productCard(data[index]);
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

  Widget _productCard(ProductListData item) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSize.p16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(AppSize.p12),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.05),
            blurRadius: AppSize.p10,
            offset: Offset(0, AppSize.p4),
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
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(AppSize.p12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Placeholder
                Container(
                  width: AppSize.width * 0.18,
                  height: AppSize.width * 0.18,
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
                        size: AppSize.p24,
                      ),
                      SizedBox(height: AppSize.p4),
                      Text(
                        AppString.image,
                        style: TextStyle(
                          fontSize: AppSize.smallText,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.custName ?? "N/A",
                              style: TextStyle(
                                color: AppColor.black,
                                fontWeight: FontWeight.bold,
                                fontSize: AppSize.mediumText * 1.2,
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
                              size: AppSize.size14,
                              color: AppColor.goldColor,
                            ),
                            SizedBox(width: AppSize.p4),
                            Text(
                              "${item.metalName} ${item.prodType}",
                              style: TextStyle(
                                color: AppColor.goldColor,
                                fontSize: AppSize.smallText,
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
            SizedBox(height: AppSize.p12),
            const Divider(height: 1),
            SizedBox(height: AppSize.p12),
            // Grid Info
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _infoItem(
                        AppIcon.calendar,
                        "${AppString.date}:",
                        item.givenDate ?? AppString.na,
                      ),
                      SizedBox(height: AppSize.p8),
                      _infoItem(
                        AppIcon.rupee,
                        "${AppString.gvnAmt}:",
                        item.givenAmount ?? "0.00",
                      ),
                      SizedBox(height: AppSize.p8),
                      _infoItem(
                        AppIcon.locker,
                        "${AppString.locker}:",
                        item.lockerCode ?? AppString.na,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: AppSize.width * 0.15,
                  width: 1,
                  color: AppColor.grey300.withOpacity(0.5),
                  margin: EdgeInsets.symmetric(horizontal: AppSize.p16),
                ),
                Expanded(
                  child: Column(
                    children: [
                      _infoItem(
                        AppIcon.weight,
                        "${AppString.weightInGm}:",
                        "${item.weight ?? '0.00'} ${AppString.gm}",
                      ),
                      SizedBox(height: AppSize.p8),
                      _infoItem(
                        AppIcon.rupee,
                        "${AppString.rate}:",
                        item.todayRate ?? "0.00",
                      ),
                      SizedBox(height: AppSize.p8),
                      _infoItem(
                        AppIcon.category,
                        "${AppString.pcs}:",
                        item.pieces ?? "0",
                      ),
                    ],
                  ),
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
  return Row(
    children: [
      Icon(icon, size: AppSize.p16, color: AppColor.goldColor),
      SizedBox(width: AppSize.p8),
      Text(
        label,
        style: TextStyle(
          color: AppColor.textColor,
          fontSize: AppSize.size12,
          fontWeight: FontWeight.w400,
        ),
      ),
      SizedBox(width: AppSize.p4),
      Expanded(
        child: Text(
          value,
          style: TextStyle(
            color: AppColor.black,
            fontSize: AppSize.size12,
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
