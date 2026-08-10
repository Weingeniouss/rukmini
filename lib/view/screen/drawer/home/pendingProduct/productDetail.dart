// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/product/product_Controller.dart';
import 'package:rukmini/modal/product/productList_Modal.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
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
  final List<String> _tabs = ["Pending", "Return", "Sold", "Touch"];
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Fullscreen(
        drawer: homeDrawer(),
        isPadding: false,
        appBar: appBar(
          title: _isSearching.value
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: TextStyle(color: AppColor.fullScreenColor),
                  cursorColor: AppColor.fullScreenColor,
                  decoration: InputDecoration(
                    hintText: 'Search Product...',
                    hintStyle: TextStyle(color: Colors.white70),
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
            preferredSize: const Size.fromHeight(50),
            child: Container(
              color: AppColor.fullScreenColor,
              child: TabBar(
                controller: _tabController,
                onTap: (index) {
                  productController.products.clear();
                  fetchData(index: index, isRefresh: true);
                },
                indicatorColor: AppColor.activeColor,
                labelColor: AppColor.activeColor,
                unselectedLabelColor: AppColor.dark,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: AppColor.boderSideColor.shade300,
                tabs: [
                  _buildTab(AppString.pendingProduct),
                  _buildTab(AppString.returnProduct),
                  _buildTab(AppString.soldProduct),
                  _buildTab(AppString.karkitProduct, isLast: true),
                ],
              ),
            ),
          ),
        ),
        child: TabBarView(
          physics: NeverScrollableScrollPhysics(),
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
        return const Center(child: Text("No Data Found"));
      }
      return RefreshIndicator(
        onRefresh: () => fetchData(isRefresh: true),
        child: _productList(data),
      );
    });
  }

  Widget _buildTab(String text, {bool isLast = false}) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        // border: isLast
        //     ? null
        //     : Border(right: BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
      child: Tab(
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Get.width * 0.035,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _productList(List<ProductListData> data) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: data.length + (productController.isMoreLoading.value ? 1 : 0),
      padding: EdgeInsets.all(Get.width * 0.02),
      itemBuilder: (context, index) {
        if (index < data.length) {
          return _productCard(data[index]);
        } else {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget _productCard(ProductListData item) {
    return Card(
      elevation: 0,
      color: AppColor.fullScreenColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColor.boderSideColor.shade300),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: EdgeInsets.all(Get.width * 0.03),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: Get.width * 0.18,
                  height: Get.width * 0.18,
                  decoration: BoxDecoration(
                    color: AppColor.textField.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          AppIcon.camera_alt,
                          color: AppColor.boderSideColor.shade600,
                          size: Get.width * 0.06,
                        ),
                        Text(
                          AppString.image,
                          style: TextStyle(
                            fontSize: Get.width * 0.02,
                            color: AppColor.boderSideColor.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: Get.width * 0.03),
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
                                color: AppColor.primaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: Get.width * 0.038,
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
                              fontSize: Get.width * 0.038,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        "${item.metalName} ${item.prodType}",
                        style: TextStyle(
                          color: AppColor.boderSideColor.shade600,
                          fontSize: Get.width * 0.032,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: Get.height * 0.015),
            _detailRow(
              "${AppString.date} :",
              item.givenDate ?? "N/A",
              "Wgt :",
              "${item.weight ?? '0.00'} gm",
            ),
            _detailRow(
              "${AppString.gvnAmt}:",
              item.givenAmount ?? "0.00",
              "Rate :",
              "${item.todayRate ?? '0.00'}",
            ),
            _detailRow(
              "Locker :",
              item.lockerCode ?? "N/A",
              "${AppString.pcs} :",
              item.pieces ?? "0",
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(
    String label1,
    String value1,
    String label2,
    String value2,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: AppColor.dark,
                  fontSize: Get.width * 0.035,
                  fontFamily: 'Poppins',
                ),
                children: [
                  TextSpan(
                    text: "$label1 ",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  TextSpan(text: value1),
                ],
              ),
            ),
          ),
          RichText(
            textAlign: TextAlign.right,
            text: TextSpan(
              style: TextStyle(
                color: AppColor.dark,
                fontSize: Get.width * 0.035,
                fontFamily: 'Poppins',
              ),
              children: [
                TextSpan(
                  text: "$label2 ",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                TextSpan(text: value2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmerLoading() {
    return Shimmer.fromColors(
      baseColor: AppColor.baseColor!,
      highlightColor: AppColor.highlightColor!,
      child: ListView.builder(
        itemCount: 6,
        padding: EdgeInsets.all(Get.width * 0.02),
        itemBuilder: (context, index) {
          return Card(
            elevation: 0,
            margin: EdgeInsets.symmetric(vertical: 5),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: AppColor.textField),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Container(
              height: Get.height * 0.18,
              width: double.infinity,
              color: AppColor.textField,
            ),
          );
        },
      ),
    );
  }
}
