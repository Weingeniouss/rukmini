// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/controllers/drawer/productInLocker/cust_product_controller.dart';
import 'package:rukmini/controller/ui/home/productInLocker/changeLocker_ControllerUI.dart';
import 'package:rukmini/modal/drawer/productInLocker/cust_product_model.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:rukmini/view/utils/widget/horizontalPadding.dart';

class ChangeTheLocker extends StatelessWidget {
  final ChangeLockerControllerUI uiController;
  final CustProductController custProductController;
  const ChangeTheLocker({
    super.key,
    required this.uiController,
    required this.custProductController,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDesktopOrTablet = AppSize.isDesktop || AppSize.isTablet;

    return Fullscreen(
      isPadding: false,
      appBar: appBar(
        title: AppString.lockerSelection,
        back: true,
        centerTitle: true,
      ),
      child: Column(
        children: [
          _buildTopSelectors(),
          _buildFilterRow(context),
          Expanded(
            child: Obx(() {
              if (custProductController.selectedProducts.isEmpty) {
                return const Center(child: Text(AppString.noProductsSelected));
              }

              if (isDesktopOrTablet) {
                return GridView.builder(
                  padding: EdgeInsets.all(AppSize.p16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: AppSize.isDesktop ? 3 : 2,
                    crossAxisSpacing: AppSize.p16,
                    mainAxisSpacing: AppSize.p16,
                    mainAxisExtent: 150,
                  ),
                  itemCount: custProductController.selectedProducts.length,
                  itemBuilder: (context, index) {
                    final item = custProductController.selectedProducts[index];
                    return _buildProductItemCard(item);
                  },
                );
              }

              return ListView.separated(
                padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
                itemCount: custProductController.selectedProducts.length,
                separatorBuilder: (context, index) {
                  return Divider(
                    color: AppColor.boderSideColor.shade300,
                    thickness: 1,
                    height: 1,
                  );
                },
                itemBuilder: (context, index) {
                  final item = custProductController.selectedProducts[index];
                  return _buildProductItem(item);
                },
              );
            }),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildTopSelectors() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.p16,
        vertical: AppSize.p8,
      ),
      decoration: BoxDecoration(
        color: AppColor.fullScreenColor,
        border: Border(
          bottom: BorderSide(color: AppColor.boderSideColor.shade300),
        ),
      ),
      child: Row(
        children: [
          Icon(
            AppIcon.security,
            color: AppColor.activeColor,
            size: AppSize.p24,
          ),
          SizedBox(width: AppSize.p10),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () => _showLockerSelection(),
              child: Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => Text(
                        uiController.selectedLocker.value?.lockerCode ??
                            AppString.selectLocker,
                        style: TextStyle(
                          color: uiController.selectedLocker.value == null
                              ? AppColor.textColor
                              : AppColor.dark,
                          fontSize: AppSize.size15,
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    AppIcon.arrowDown,
                    color: AppColor.activeColor,
                    size: AppSize.p20,
                  ),
                  SizedBox(width: AppSize.p4),
                  GestureDetector(
                    onTap: () {
                      uiController.clearLocker();
                    },
                    child: Icon(
                      AppIcon.remove,
                      color: AppColor.activeColor,
                      size: AppSize.p20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 24,
            width: 1,
            color: AppColor.boderSideColor.shade400,
            margin: EdgeInsets.symmetric(horizontal: AppSize.p10),
          ),
          Expanded(
            flex: 1,
            child: TextField(
              controller: uiController.lockerCodeController,
              decoration: InputDecoration(
                hintText: AppString.lockerCode,
                hintStyle: TextStyle(
                  color: AppColor.textColor,
                  fontSize: AppSize.size15,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLockerSelection() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.4,
        decoration: BoxDecoration(
          color: AppColor.fullScreenColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                AppString.selectLocker,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: Obx(() {
                if (uiController.lockerListController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (uiController.lockerListController.lockerList.isEmpty) {
                  return const Center(child: Text(AppString.noLockersAvailable));
                }
                return ListView.builder(
                  itemCount:
                      uiController.lockerListController.lockerList.length,
                  itemBuilder: (context, index) {
                    final locker =
                        uiController.lockerListController.lockerList[index];
                    return ListTile(
                      title: Text(
                        locker.lockerCode ?? "N/A",
                        style: const TextStyle(fontSize: 16),
                      ),
                      subtitle: Text(locker.comName ?? ""),
                      onTap: () {
                        uiController.selectLocker(locker);
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

  Widget _buildFilterRow(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.p16,
        vertical: AppSize.p12,
      ),
      child: Row(
        children: [
          Text(
            "${AppString.date}  ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppSize.size15,
              color: AppColor.dark,
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => uiController.selectDate(context),
              child: Row(
                children: [
                  Obx(
                    () => Text(
                      uiController.selectedDate.value.isEmpty
                          ? AppString.selectDate
                          : uiController.selectedDate.value,
                      style: TextStyle(
                        color: uiController.selectedDate.value.isEmpty
                            ? AppColor.textColor
                            : AppColor.dark,
                        fontSize: AppSize.size15,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSize.p4),
                  Icon(
                    AppIcon.arrowDown,
                    color: AppColor.textColor,
                    size: AppSize.size15,
                  ),
                ],
              ),
            ),
          ),
          Text(
            "${AppString.interestRate}  ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppSize.size15,
              color: AppColor.dark,
            ),
          ),
          Row(
            children: [
              Obx(
                () => Text(
                  uiController.selectedLocker.value?.interestRate ??
                      AppString.rate,
                  style: TextStyle(
                    color: uiController.selectedLocker.value == null
                        ? AppColor.textColor
                        : AppColor.dark,
                    fontSize: AppSize.size15,
                  ),
                ),
              ),
              SizedBox(width: AppSize.p4),
              Icon(
                AppIcon.arrowDown,
                color: AppColor.textColor,
                size: AppSize.size15,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductItemCard(ProductList item) {
    return Container(
      padding: EdgeInsets.all(AppSize.p12),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImagePlaceholder(item.productImg),
          SizedBox(width: AppSize.p12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${item.metalName} Karat ${item.prodType} ${item.catName}",
                  style: TextStyle(
                    color: AppColor.dark.withOpacity(0.7),
                    fontSize: AppSize.size14,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppSize.p4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.custName ?? "N/A",
                        style: TextStyle(
                          color: AppColor.dark,
                          fontSize: AppSize.size14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      item.girviDate ?? "",
                      style: TextStyle(
                        color: AppColor.textColor,
                        fontSize: AppSize.size12,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSize.p4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLabelValue(AppString.pcsColon, item.pieces ?? "0"),
                    _buildLabelValue(AppString.wgtColon, "${item.weight} ${AppString.gm}"),
                  ],
                ),
                SizedBox(height: AppSize.p4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLabelValue(AppString.gvnAmtColon, item.givenAmount ?? "0.00"),
                    Row(
                      children: [
                        Text(
                          "${AppString.tknAmt} ",
                          style: TextStyle(
                            color: AppColor.textColor,
                            fontSize: AppSize.size12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          width: 60,
                          height: 22,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColor.boderSideColor,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: TextField(
                              controller: uiController
                                  .tknAmtControllers[item.productId ?? ""],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: AppSize.size12,
                                color: AppColor.dark,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(ProductList item) {
    return horizontalPadding(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Get.height * 0.015),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImagePlaceholder(item.productImg),
            SizedBox(width: Get.width * 0.035),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${item.metalName} Karat ${item.prodType} ${item.catName}",
                    style: TextStyle(
                      color: AppColor.dark.withOpacity(0.7),
                      fontSize: AppSize.p16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: Get.height * 0.002),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.custName ?? "N/A",
                        style: TextStyle(
                          color: AppColor.dark,
                          fontSize: AppSize.size15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        item.girviDate ?? "",
                        style: TextStyle(
                          color: AppColor.textColor,
                          fontSize: Get.width * 0.032,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Get.height * 0.005),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLabelValue(AppString.pcsColon, item.pieces ?? "0"),
                      _buildLabelValue(AppString.wgtColon, "${item.weight} ${AppString.gm}"),
                    ],
                  ),
                  SizedBox(height: Get.height * 0.005),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLabelValue(AppString.gvnAmtColon, item.givenAmount ?? "0.00"),
                      Row(
                        children: [
                          Text(
                            "${AppString.tknAmt} ",
                            style: TextStyle(
                              color: AppColor.textColor,
                              fontSize: Get.width * 0.032,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            width: Get.width * 0.18,
                            height: AppSize.p16,
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSize.p4,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColor.boderSideColor,
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Center(
                              child: TextField(
                                controller: uiController
                                    .tknAmtControllers[item.productId ?? ""],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: Get.width * 0.032,
                                  color: AppColor.dark,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ),
                        ],
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

  Widget _buildImagePlaceholder(String? imageUrl) {
    final bool isDesktopOrTablet = AppSize.isDesktop || AppSize.isTablet;

    return Container(
      width: isDesktopOrTablet ? 50 : Get.width * 0.12,
      height: isDesktopOrTablet ? 50 : Get.width * 0.12,
      decoration: BoxDecoration(
        color: AppColor.boderSideColor.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
      child: (imageUrl != null && imageUrl.isNotEmpty)
          ? ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildPlaceholderContent(),
              ),
            )
          : _buildPlaceholderContent(),
    );
  }

  Widget _buildPlaceholderContent() {
    final bool isDesktopOrTablet = AppSize.isDesktop || AppSize.isTablet;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          AppIcon.image,
          size: isDesktopOrTablet ? 20 : Get.width * 0.05,
          color: AppColor.boderSideColor.shade600,
        ),
        Text(
          AppString.image,
          style: TextStyle(
            fontSize: isDesktopOrTablet ? 10 : Get.width * 0.02,
            color: AppColor.boderSideColor.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildLabelValue(String label, String value) {
    final bool isDesktopOrTablet = AppSize.isDesktop || AppSize.isTablet;

    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: isDesktopOrTablet ? 12 : Get.width * 0.035,
          color: AppColor.textColor,
        ),
        children: [
          TextSpan(
            text: label,
            style: TextStyle(
              fontSize: isDesktopOrTablet ? 12 : Get.width * 0.035,
              fontWeight: FontWeight.w600,
              color: AppColor.dark,
            ),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final bool isDesktopOrTablet = AppSize.isDesktop || AppSize.isTablet;

    return GestureDetector(
      onTap: uiController.submit,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: isDesktopOrTablet ? 16 : Get.height * 0.015,
          horizontal: AppSize.p16,
        ),
        color: AppColor.primaryColor,
        child: Align(
          alignment: Alignment.centerRight,
          child: Obx(
            () => uiController.isLoading.value
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColor.activeColor,
                    ),
                  )
                : Text(
                    AppString.done,
                    style: TextStyle(
                      color: AppColor.activeColor,
                      fontSize: isDesktopOrTablet ? 16 : Get.width * 0.03,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
