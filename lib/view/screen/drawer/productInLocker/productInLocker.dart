// ignore_for_file: unnecessary_non_null_assertion, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/drawer/all_master/locker_master/lockerList_Controller.dart';
import 'package:rukmini/controller/api/controllers/drawer/productInLocker/cust_product_controller.dart';
import 'package:rukmini/modal/drawer/productInLocker/cust_product_model.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/drawer.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:rukmini/view/utils/widget/horizontalPadding.dart';
import 'package:shimmer/shimmer.dart';

class ProductInLocker extends StatelessWidget {
  ProductInLocker({super.key});

  final custProductController = Get.put(CustProductController());
  final lockerListController = Get.put(LockerListController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CallApi.callCustProduct();
    });

    return Fullscreen(
      isPadding: false,
      drawer: homeDrawer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Obx(
          () => appBar(
            title: custProductController.isSearching.value
                ? TextField(
                    controller: custProductController.searchController,
                    autofocus: true,
                    style: TextStyle(
                      color: AppColor.backgroundColor,
                      fontSize: Get.width * 0.045,
                    ),
                    decoration: InputDecoration(
                      hintText: AppString.search,
                      hintStyle: TextStyle(color: AppColor.backgroundColor),
                      border: InputBorder.none,
                    ),
                    onChanged: (val) {
                      custProductController.updateSearch(val);
                    },
                  )
                : AppString.productinLocker,
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
                return Center(child: Text(AppString.noProductsFound));
              }

              return RefreshIndicator(
                onRefresh: CallApi.callCustProduct,
                color: AppColor.activeColor,
                child: ListView.separated(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
                  itemCount: custProductController.filteredProductList.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(height: Get.height * 0.01);
                  },
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

  Widget _buildCustomerSelector() {
    return GestureDetector(
      onTap: () => _showCustomerSelectionPopup(),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Get.width * 0.04,
          vertical: Get.height * 0.015,
        ),
        decoration: BoxDecoration(
          color: AppColor.fullScreenColor,
          border: Border(
            bottom: BorderSide(color: AppColor.boderSideColor.withOpacity(0.3)),
          ),
        ),
        child: Row(
          children: [
            Icon(
              AppIcon.person,
              color: AppColor.activeColor,
              size: Get.width * 0.06,
            ),
            SizedBox(width: Get.width * 0.03),
            Expanded(
              child: Obx(
                () => Text(
                  custProductController.selectedCustName.value,
                  style: TextStyle(
                    color: custProductController.selectedCustId.value.isEmpty
                        ? AppColor.textColor
                        : AppColor.dark,
                    fontSize: Get.width * 0.042,
                  ),
                ),
              ),
            ),
            Icon(
              AppIcon.arrow_down,
              color: AppColor.activeColor,
              size: Get.width * 0.06,
            ),
            SizedBox(width: Get.width * 0.02),
            GestureDetector(
              onTap: () {
                custProductController.clearCustomerFilter();
              },
              child: Icon(
                AppIcon.remove,
                color: AppColor.activeColor,
                size: Get.width * 0.05,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomerSelectionPopup() {
    Get.bottomSheet(
      isScrollControlled: true,
      Container(
        height: Get.height * 0.8,
        decoration: BoxDecoration(
          color: AppColor.fullScreenColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(Get.width * 0.04),
              child: Text(
                AppString.selectCustomer,
                style: TextStyle(
                  fontSize: Get.width * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(),
            Expanded(
              child: Obx(() {
                if (custProductController.custList.isEmpty) {
                  return const Center(child: Text(AppString.noCustomersAvailable));
                }
                return ListView.builder(
                  itemCount: custProductController.custList.length,
                  itemBuilder: (context, index) {
                    final cust = custProductController.custList[index];
                    return ListTile(
                      title: Text(
                        cust.name ?? "N/A",
                        style: TextStyle(fontSize: Get.width * 0.04),
                      ),
                      subtitle: Text(cust.custCode ?? ""),
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
          ],
        ),
      ),
    );
  }

  void _showLockerFilterPopup() {
    lockerListController.getLockerList();
    Get.bottomSheet(
      Container(
        height: Get.height * 0.45,
        decoration: BoxDecoration(
          color: AppColor.fullScreenColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(Get.width * 0.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppString.selectLocker,
                    style: TextStyle(
                      fontSize: Get.width * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      custProductController.resetLockerFilter();
                      Get.back();
                    },
                    child: const Text(AppString.reset),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: Obx(() {
                if (lockerListController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (lockerListController.lockerList.isEmpty) {
                  return const Center(child: Text(AppString.noLockersAvailable));
                }
                return ListView.builder(
                  itemCount: lockerListController.lockerList.length,
                  itemBuilder: (context, index) {
                    final locker = lockerListController.lockerList[index];
                    return ListTile(
                      title: Text(
                        locker.lockerCode ?? "N/A",
                        style: TextStyle(fontSize: Get.width * 0.04),
                      ),
                      subtitle: Text(locker.comName ?? ""),
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
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(ProductList item, bool isSelected) {
    return horizontalPadding(
      child: Container(
        padding: EdgeInsets.all(Get.width * 0.03),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.activeColor.withOpacity(0.1)
              : AppColor.fullScreenColor,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: isSelected
                ? AppColor.activeColor
                : AppColor.boderSideColor.withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                _buildProductImage(item.productImg),
                if (isSelected)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: AppColor.activeColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        AppIcon.check,
                        color: AppColor.backgroundColor,
                        size: 12,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: Get.width * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderRow(item.custName ?? "N/A", item.uniqueId ?? ""),
                  SizedBox(height: Get.height * 0.005),
                  _buildTitleRow(
                    "${item.metalName} Karat ${item.prodType} ${item.catName}",
                    item.girviDate ?? "",
                  ),
                  SizedBox(height: Get.height * 0.008),
                  _buildInfoRow(
                    AppString.pcsColon,
                    item.pieces ?? "0",
                    AppString.wgtColon,
                    "${item.weight} ${AppString.gm}",
                  ),
                  SizedBox(height: Get.height * 0.005),
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
    );
  }

  Widget _buildProductImage(String? imageUrl) {
    return Container(
      width: Get.width * 0.13,
      height: Get.width * 0.23,
      decoration: BoxDecoration(
        color: AppColor.boderSideColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: (imageUrl != null && imageUrl.isNotEmpty)
          ? ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildImagePlaceholder();
                },
              ),
            )
          : _buildImagePlaceholder(),
    );
  }

  Widget _buildImagePlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          AppIcon.camera,
          size: Get.width * 0.08,
          color: AppColor.textColor.withOpacity(0.5),
        ),
        Text(
          AppString.images,
          style: TextStyle(
            fontSize: Get.width * 0.025,
            color: AppColor.textColor.withOpacity(0.5),
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
              color: AppColor.activeColor,
              fontWeight: FontWeight.w600,
              fontSize: Get.width * 0.035,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          code,
          style: TextStyle(
            color: AppColor.activeColor,
            fontSize: Get.width * 0.03,
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
              color: AppColor.dark,
              fontWeight: FontWeight.w400,
              fontSize: Get.width * 0.038,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          date,
          style: TextStyle(
            color: AppColor.textColor,
            fontSize: Get.width * 0.032,
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
            style: TextStyle(fontSize: Get.width * 0.032, color: AppColor.dark),
            children: [
              TextSpan(
                text: label1,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              TextSpan(
                text: value1,
                style: TextStyle(color: AppColor.textColor),
              ),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: Get.width * 0.032, color: AppColor.dark),
            children: [
              TextSpan(
                text: label2,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              TextSpan(
                text: value2,
                style: TextStyle(color: AppColor.textColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/changeTheLocker');
      },
      child: Container(
        width: Get.width,
        padding: EdgeInsets.symmetric(vertical: Get.height * 0.015),
        color: AppColor.primaryColor,
        child: Center(
          child: Text(
            "Change the locker",
            style: TextStyle(
              color: AppColor.activeColor,
              fontSize: Get.width * 0.045,
              fontWeight: FontWeight.w500,
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
        padding: EdgeInsets.all(Get.width * 0.04),
        separatorBuilder: (context, index) {
          return SizedBox(height: Get.height * 0.02);
        },
        itemBuilder: (context, index) {
          return Container(
            height: 100,
            decoration: BoxDecoration(
              color: AppColor.fullScreenColor,
              borderRadius: BorderRadius.circular(5),
            ),
          );
        },
      ),
    );
  }
}
