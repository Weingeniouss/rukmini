// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/modal/drawer/productInLocker/cust_product_model.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:rukmini/view/utils/widget/horizontalPadding.dart';

class ProductInLockerDetail extends StatelessWidget {
  const ProductInLockerDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductList? item = Get.arguments;
    return Fullscreen(
      isPadding: false,
      backGroundcolor: AppColor.backgroundColor,
      appBar: appBar(
        title: _buildDecorativeTitle(AppString.productDetail),
        back: true,
        centerTitle: true,
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: AppSize.p16),
              children: [
                _buildHeroImageSection(item),
                SizedBox(height: AppSize.p24),
                horizontalPadding(
                  child: _buildSectionHeader(
                    AppString.productDetail,
                    AppIcon.product,
                  ),
                ),
                SizedBox(height: AppSize.p16),
                _buildProductDetailsCard(item),
                SizedBox(height: AppSize.p24),
                horizontalPadding(
                  child: _buildSectionHeader(
                    AppString.lockerDetail,
                    AppIcon.locker,
                  ),
                ),
                SizedBox(height: AppSize.p16),
                _buildLockerDetailCard(item),
                SizedBox(height: AppSize.p24),
              ],
            ),
          ),
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
                  width: AppSize.p4 * 1.5,
                  height: AppSize.p4 * 1.5,
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

  Widget _buildHeroImageSection(ProductList? item) {
    return horizontalPadding(
      child: Center(
        child: Container(
          height: AppSize.p4 * 55,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(AppSize.p20),
            border: Border.all(
              color: AppColor.goldColor.withOpacity(0.3),
              width: AppSize.p4 * 0.375,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColor.goldColor.withOpacity(0.1),
                blurRadius: AppSize.p10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: -AppSize.p20,
                right: -AppSize.p20,
                child: Icon(
                  AppIcon.leaf,
                  color: AppColor.goldColor.withOpacity(0.05),
                  size: AppSize.iconLarge * 4,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(AppSize.p16),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColor.whiteOrang.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(AppSize.p12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(AppSize.p12),
                          child:
                              item?.productImg != null &&
                                  item!.productImg!.isNotEmpty
                              ? Image.network(
                                  item.productImg!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(
                                        AppIcon.image,
                                        color: AppColor.goldColor,
                                        size: AppSize.iconLarge * 2,
                                      ),
                                )
                              : Icon(
                                  AppIcon.image,
                                  color: AppColor.goldColor,
                                  size: AppSize.iconLarge * 2,
                                ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSize.p16),
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item?.custName ?? "N/A",
                            style: TextStyle(
                              color: AppColor.black,
                              fontSize: AppSize.headingText,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: AppSize.p4),
                          Text(
                            "${item?.metalName} ${item?.prodType} ${item?.catName}",
                            style: TextStyle(
                              color: AppColor.black.withOpacity(0.6),
                              fontSize: AppSize.commonText,
                            ),
                            maxLines: 2,
                          ),
                          SizedBox(height: AppSize.p12),
                          _buildStatusBadge(item?.status ?? AppString.pending),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    bool isActive =
        status.toLowerCase() == AppString.active.toLowerCase() ||
        status.toLowerCase() == "open";
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.p12,
        vertical: AppSize.p4,
      ),
      decoration: BoxDecoration(
        color: isActive ? AppColor.goldColor : AppColor.whiteOrang,
        borderRadius: BorderRadius.circular(AppSize.p20),
        border: Border.all(color: AppColor.goldColor.withOpacity(0.5)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: isActive ? AppColor.white : AppColor.goldColor,
          fontSize: AppSize.size12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Container(
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
            child: Icon(icon, color: AppColor.goldColor, size: AppSize.p20),
          ),
          SizedBox(width: AppSize.p12),
          Text(
            title,
            style: TextStyle(
              fontSize: AppSize.headingText,
              fontWeight: FontWeight.bold,
              color: AppColor.black,
            ),
          ),
          const Spacer(),
          Icon(
            AppIcon.leaf,
            color: AppColor.goldColor.withOpacity(0.1),
            size: AppSize.iconLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetailsCard(ProductList? item) {
    return horizontalPadding(
      child: Container(
        padding: EdgeInsets.all(AppSize.p16),
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
        child: Column(
          children: [
            _buildDetailRow(
              AppIcon.badge,
              "${AppString.girviId} :",
              item?.uniqueId ?? "",
              isGoldValue: true,
            ),
            _buildDivider(),
            _buildDetailRow(
              AppIcon.balance,
              AppString.weightColon,
              "${item?.weight} ${AppString.gm}",
              isGoldValue: true,
            ),
            _buildDivider(),
            _buildDetailRow(
              AppIcon.rupee,
              "${AppString.amtGiven} :",
              item?.givenAmount ?? "0.00",
              isGoldValue: true,
            ),
            _buildDivider(),
            _buildDetailRow(
              AppIcon.rupee,
              "${AppString.actualAmt} :",
              item?.balance ?? "0.00",
              isGoldValue: true,
            ),
            _buildDivider(),
            _buildDetailRow(
              AppIcon.rate,
              "${AppString.rate} :",
              "74500.00",
              isGoldValue: true,
            ),
            _buildDivider(),
            _buildDetailRow(
              AppIcon.calendar,
              "${AppString.girviDt} :",
              item?.girviDate ?? "",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value, {
    bool isGoldValue = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSize.p12),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSize.p8),
            decoration: BoxDecoration(
              color: AppColor.whiteOrang.withOpacity(0.5),
              borderRadius: BorderRadius.circular(AppSize.p8),
            ),
            child: Icon(icon, color: AppColor.goldColor, size: AppSize.p16),
          ),
          SizedBox(width: AppSize.p16),
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: TextStyle(
                fontSize: AppSize.commonText,
                fontWeight: FontWeight.w500,
                color: AppColor.black,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: AppSize.commonText,
                color: isGoldValue ? AppColor.goldColor : AppColor.black,
                fontWeight: isGoldValue ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: AppColor.goldColor.withOpacity(0.1),
      height: AppSize.p4 / 4,
      thickness: AppSize.p4 / 4,
    );
  }

  Widget _buildLockerDetailCard(ProductList? item) {
    return horizontalPadding(
      child: Container(
        padding: EdgeInsets.all(AppSize.p16),
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
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppString.locker,
                        style: TextStyle(
                          color: AppColor.black.withOpacity(0.6),
                          fontSize: AppSize.size12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: AppSize.p4),
                      Row(
                        children: [
                          Icon(
                            AppIcon.locker,
                            color: AppColor.goldColor,
                            size: AppSize.p16,
                          ),
                          SizedBox(width: AppSize.p8),
                          Text(
                            "${item?.lockerCode}-${item?.code}",
                            style: TextStyle(
                              color: AppColor.goldColor,
                              fontSize: AppSize.commonText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: AppSize.p4 / 4,
                  height: AppSize.p40,
                  color: AppColor.goldColor.withOpacity(0.2),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: AppSize.p16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppString.returnDate,
                          style: TextStyle(
                            color: AppColor.black.withOpacity(0.6),
                            fontSize: AppSize.size12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: AppSize.p4),
                        Row(
                          children: [
                            Icon(
                              AppIcon.calendar,
                              color: AppColor.goldColor,
                              size: AppSize.p16,
                            ),
                            SizedBox(width: AppSize.p8),
                            Text(
                              "-",
                              style: TextStyle(
                                color: AppColor.black,
                                fontSize: AppSize.commonText,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
