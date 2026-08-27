// ignore_for_file: file_names, unnecessary_non_null_assertion, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/drawer/all_master/locker_master/lockerList_Controller.dart';
import 'package:rukmini/controller/api/controllers/drawer/productInLocker/cust_product_controller.dart';
import 'package:rukmini/modal/drawer/productInLocker/cust_product_model.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/drawer.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:rukmini/view/utils/widget/horizontalPadding.dart';
import 'package:shimmer/shimmer.dart';

class ProductInLocker extends StatelessWidget {
  final CustProductController custProductController;
  final LockerListController lockerListController;

  const ProductInLocker({
    super.key,
    required this.custProductController,
    required this.lockerListController,
  });

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CallApi.callCustProduct();
    });

    return Fullscreen(
      isPadding: false,
      backGroundcolor: AppColor.backgroundColor,
      drawer: homeDrawer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          kToolbarHeight + AppSize.p12 + AppSize.p4 / 4,
        ),
        child: Obx(
          () => appBar(
            centerTitle: true,
            title: custProductController.isSearching.value
                ? TextField(
                    controller: custProductController.searchController,
                    autofocus: true,
                    style: TextStyle(
                      color: AppColor.black,
                      fontSize: AppSize.commonText,
                    ),
                    decoration: InputDecoration(
                      hintText: AppString.search,
                      hintStyle: TextStyle(
                        color: AppColor.black.withOpacity(0.4),
                      ),
                      border: InputBorder.none,
                    ),
                    onChanged: (val) {
                      custProductController.updateSearch(val);
                    },
                  )
                : _buildDecorativeTitle(AppString.productinLocker),
            searchIcon: !custProductController.isSearching.value,
            close: custProductController.isSearching.value,
            filter: true,
            searchOnPressed: () => custProductController.toggleSearch(),
            closeOnPressed: () => custProductController.closeSearch(),
            filterOnPressed: () => _showLockerFilterPopup(),
            back: false,
          ),
        ),
      ),
      child: Column(
        children: [
          _buildCustomerSelector(),
          Expanded(
            child: Obx(() {
              if (custProductController.isLoading.value &&
                  custProductController.filteredProductList.isEmpty) {
                return _shimmerLoading();
              }

              if (custProductController.filteredProductList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        AppIcon.inventory,
                        size: AppSize.iconLarge * 2,
                        color: AppColor.goldColor.withOpacity(0.2),
                      ),
                      SizedBox(height: AppSize.p16),
                      Text(
                        AppString.noProductsFound,
                        style: TextStyle(
                          color: AppColor.black.withOpacity(0.5),
                          fontSize: AppSize.commonText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: CallApi.callCustProduct,
                color: AppColor.goldColor,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(vertical: AppSize.p12),
                  itemCount: custProductController.filteredProductList.length,
                  itemBuilder: (context, index) {
                    final item =
                        custProductController.filteredProductList[index];
                    return Obx(() {
                      bool isSelected = custProductController.selectedProducts
                          .contains(item);
                      return GestureDetector(
                        onLongPress: () {
                          custProductController.toggleSelection(item);
                        },
                        onTap: () {
                          if (custProductController
                              .selectedProducts
                              .isNotEmpty) {
                            custProductController.toggleSelection(item);
                          } else {
                            Get.toNamed(
                              '/productInLockerDetail',
                              arguments: item,
                            );
                          }
                        },
                        child: _buildProductCard(item, isSelected),
                      );
                    });
                  },
                ),
              );
            }),
          ),
          Obx(() {
            if (custProductController.selectedProducts.isNotEmpty) {
              return _buildBottomBar();
            } else {
              return const SizedBox();
            }
          }),
        ],
      ),
    );
  }

  Widget _buildDecorativeTitle(String title) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColor.black,
            fontSize: AppSize.titleText,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: AppSize.p4 / 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppSize.p40,
              height: AppSize.p4 / 4,
              color: AppColor.goldColor.withOpacity(0.5),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.p4),
              child: Transform.rotate(
                angle: 0.785, // 45 degrees
                child: Container(
                  width: AppSize.p8 / 1.33,
                  height: AppSize.p8 / 1.33,
                  color: AppColor.goldColor,
                ),
              ),
            ),
            Container(
              width: AppSize.p40,
              height: AppSize.p4 / 4,
              color: AppColor.goldColor.withOpacity(0.5),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCustomerSelector() {
    return horizontalPadding(
      child: GestureDetector(
        onTap: () => _showCustomerSelectionPopup(),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: AppSize.p12),
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.p16,
            vertical: AppSize.p12,
          ),
          decoration: BoxDecoration(
            color: AppColor.whiteOrang.withOpacity(0.3),
            borderRadius: BorderRadius.circular(AppSize.p20),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSize.p8),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.goldColor.withOpacity(0.1),
                      blurRadius: AppSize.p4,
                    ),
                  ],
                ),
                child: Icon(
                  AppIcon.person,
                  color: AppColor.goldColor,
                  size: AppSize.p20,
                ),
              ),
              SizedBox(width: AppSize.p12),
              Expanded(
                child: Obx(
                  () => Text(
                    custProductController.selectedCustName.value.isEmpty ||
                            custProductController.selectedCustName.value ==
                                "Select Customer"
                        ? AppString.selectCustomer
                        : custProductController.selectedCustName.value,
                    style: TextStyle(
                      color: AppColor.black,
                      fontSize: AppSize.commonText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Icon(
                AppIcon.arrow_down,
                color: AppColor.goldColor,
                size: AppSize.p20,
              ),
              if (custProductController.selectedCustId.value.isNotEmpty) ...[
                SizedBox(width: AppSize.p8),
                GestureDetector(
                  onTap: () {
                    custProductController.clearCustomerFilter();
                  },
                  child: Icon(
                    AppIcon.remove,
                    color: AppColor.goldColor,
                    size: AppSize.p20,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showCustomerSelectionPopup() {
    showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColor.white,
          titlePadding: EdgeInsets.fromLTRB(
            AppSize.p16,
            AppSize.p16,
            AppSize.p16,
            AppSize.p8,
          ),
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.p16),
            side: BorderSide(color: AppColor.goldColor.withOpacity(0.2)),
          ),
          title: Text(
            AppString.selectCustomer,
            style: TextStyle(
              color: AppColor.goldColor,
              fontSize: AppSize.headingText,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSize.p16),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        AppIcon.searchIcon,
                        color: AppColor.goldColor,
                        size: AppSize.p20,
                      ),
                      hintText: AppString.searchCustomer,
                      hintStyle: TextStyle(
                        fontSize: AppSize.commonText,
                        color: AppColor.black.withOpacity(0.4),
                      ),
                      isDense: true,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColor.goldColor.withOpacity(0.2),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColor.goldColor),
                      ),
                    ),
                    onChanged: (val) {
                      // Note: Filtering logic for customer list should be implemented in controller if needed
                    },
                  ),
                ),
                SizedBox(height: AppSize.p8),
                Flexible(
                  child: Container(
                    constraints: BoxConstraints(maxHeight: Get.height * 0.6),
                    child: Obx(() {
                      if (custProductController.custList.isEmpty) {
                        return const Center(
                          child: Text(AppString.noCustomersAvailable),
                        );
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(vertical: AppSize.p8),
                        itemCount: custProductController.custList.length,
                        separatorBuilder: (context, index) => Divider(
                          height: AppSize.p4 / 4,
                          indent: AppSize.p16,
                          endIndent: AppSize.p16,
                          color: AppColor.goldColor.withOpacity(0.1),
                        ),
                        itemBuilder: (context, index) {
                          final cust = custProductController.custList[index];
                          return ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: AppSize.p16,
                            ),
                            title: Text(
                              cust.name ?? "N/A",
                              style: TextStyle(
                                fontSize: AppSize.commonText,
                                color: AppColor.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              cust.custCode ?? "",
                              style: TextStyle(
                                fontSize: AppSize.size12,
                                color: AppColor.black.withOpacity(0.6),
                              ),
                            ),
                            onTap: () {
                              custProductController.filterByCustomer(
                                cust.custId ?? "",
                                cust.name ?? "",
                              );
                              Get.back();
                            },
                          );
                        },
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                AppString.cancel,
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

  void _showLockerFilterPopup() {
    lockerListController.getLockerList();
    showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColor.white,
          titlePadding: EdgeInsets.fromLTRB(
            AppSize.p16,
            AppSize.p16,
            AppSize.p16,
            AppSize.p8,
          ),
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.p16),
            side: BorderSide(color: AppColor.goldColor.withOpacity(0.2)),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppString.selectLocker,
                style: TextStyle(
                  color: AppColor.goldColor,
                  fontSize: AppSize.headingText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  custProductController.resetLockerFilter();
                  Get.back();
                },
                child: Text(
                  AppString.reset,
                  style: TextStyle(
                    color: AppColor.goldColor,
                    fontSize: AppSize.size12,
                  ),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Container(
                    constraints: BoxConstraints(maxHeight: Get.height * 0.4),
                    child: Obx(() {
                      if (lockerListController.isLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColor.goldColor,
                          ),
                        );
                      }
                      if (lockerListController.lockerList.isEmpty) {
                        return const Center(
                          child: Text(AppString.noLockersAvailable),
                        );
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(vertical: AppSize.p8),
                        itemCount: lockerListController.lockerList.length,
                        separatorBuilder: (context, index) => Divider(
                          height: AppSize.p4 / 4,
                          indent: AppSize.p16,
                          endIndent: AppSize.p16,
                          color: AppColor.goldColor.withOpacity(0.1),
                        ),
                        itemBuilder: (context, index) {
                          final locker = lockerListController.lockerList[index];
                          return ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: AppSize.p16,
                            ),
                            title: Text(
                              locker.lockerCode ?? "N/A",
                              style: TextStyle(
                                fontSize: AppSize.commonText,
                                color: AppColor.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              locker.comName ?? "",
                              style: TextStyle(
                                fontSize: AppSize.size12,
                                color: AppColor.black.withOpacity(0.6),
                              ),
                            ),
                            onTap: () {
                              custProductController.filterByLocker(
                                locker.lockerCode ?? "",
                              );
                              Get.back();
                            },
                          );
                        },
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                AppString.cancel,
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

  Widget _buildProductCard(ProductList item, bool isSelected) {
    return horizontalPadding(
      child: Container(
        margin: EdgeInsets.only(bottom: AppSize.p16),
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
              children: [
                // Gold vertical strip
                Container(
                  width: AppSize.p4,
                  color: isSelected ? AppColor.activeColor : AppColor.goldColor,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(AppSize.p12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProductImage(item.productImg, isSelected),
                        SizedBox(width: AppSize.p12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildHeaderRow(
                                item.custName ?? "N/A",
                                item.uniqueId ?? "",
                              ),
                              SizedBox(height: AppSize.p4),
                              _buildTitleRow(
                                "${item.metalName} Karat ${item.prodType} ${item.catName}",
                                item.girviDate ?? "",
                              ),
                              SizedBox(height: AppSize.p8),
                              _buildInfoRow(
                                AppString.pcsColon,
                                item.pieces ?? "0",
                                AppString.wgtColon,
                                "${item.weight} ${AppString.gm}",
                              ),
                              SizedBox(height: AppSize.p4),
                              _buildInfoRow(
                                AppString.gvnAmtColon,
                                item.givenAmount ?? "0.00",
                                AppString.lockerCodeColon,
                                "${item.lockerCode}-${item.code}",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(String? imageUrl, bool isSelected) {
    return Stack(
      children: [
        Container(
          width: AppSize.width * 0.18,
          height: AppSize.width * 0.18,
          decoration: BoxDecoration(
            color: AppColor.whiteOrang.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSize.p12),
            border: Border.all(color: AppColor.goldColor.withOpacity(0.1)),
          ),
          child: (imageUrl != null && imageUrl.isNotEmpty)
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(AppSize.p12),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildImagePlaceholder();
                    },
                  ),
                )
              : _buildImagePlaceholder(),
        ),
        if (isSelected)
          Positioned(
            right: 4,
            top: 4,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: AppColor.activeColor,
                shape: BoxShape.circle,
              ),
              child: Icon(AppIcon.check, color: AppColor.white, size: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          AppIcon.camera,
          size: AppSize.p24,
          color: AppColor.goldColor.withOpacity(0.5),
        ),
        Text(
          AppString.images,
          style: TextStyle(
            fontSize: AppSize.size12,
            color: AppColor.goldColor.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderRow(String name, String code) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            name,
            style: TextStyle(
              color: AppColor.goldColor,
              fontWeight: FontWeight.bold,
              fontSize: AppSize.size14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          code,
          style: TextStyle(
            color: AppColor.goldColor,
            fontSize: AppSize.size12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTitleRow(String title, String date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: AppColor.black,
              fontWeight: FontWeight.w400,
              fontSize: AppSize.size12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          date,
          style: TextStyle(
            color: AppColor.black.withOpacity(0.5),
            fontSize: AppSize.size12,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    String label1,
    String value1,
    String label2,
    String value2,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: AppSize.size12, color: AppColor.black),
            children: [
              TextSpan(
                text: label1,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColor.black.withOpacity(0.6),
                ),
              ),
              TextSpan(
                text: value1,
                style: TextStyle(
                  color: AppColor.goldColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: AppSize.size12, color: AppColor.black),
            children: [
              TextSpan(
                text: label2,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColor.black.withOpacity(0.6),
                ),
              ),
              TextSpan(
                text: value2,
                style: TextStyle(
                  color: AppColor.goldColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.all(AppSize.p16),
      decoration: BoxDecoration(
        color: AppColor.white,
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.05),
            blurRadius: AppSize.p10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColor.goldColor, AppColor.dashboardGold],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppSize.p16),
          boxShadow: [
            BoxShadow(
              color: AppColor.goldColor.withOpacity(0.3),
              blurRadius: AppSize.p8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            Get.toNamed('/changeTheLocker');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.transparent,
            shadowColor: AppColor.transparent,
            padding: EdgeInsets.symmetric(vertical: AppSize.p16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSize.p16),
            ),
          ),
          child: Text(
            AppString.changeTheLocker,
            style: TextStyle(
              color: AppColor.white,
              fontWeight: FontWeight.bold,
              fontSize: AppSize.largeText,
            ),
          ),
        ),
      ),
    );
  }

  Widget _shimmerLoading() {
    return Shimmer.fromColors(
      baseColor: AppColor.baseColor!,
      highlightColor: AppColor.highlightColor!,
      child: ListView.separated(
        itemCount: 6,
        padding: EdgeInsets.all(AppSize.p16),
        separatorBuilder: (context, index) {
          return SizedBox(height: AppSize.p12);
        },
        itemBuilder: (context, index) {
          return Container(
            height: AppSize.p4 * 30,
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(AppSize.p12),
            ),
          );
        },
      ),
    );
  }
}
