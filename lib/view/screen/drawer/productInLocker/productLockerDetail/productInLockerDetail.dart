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
      appBar: appBar(
        title: AppString.productDetail,
        back: true,
        centerTitle: true,
      ),
      child: Column(
        children: [
          SizedBox(height: AppSize.p8),
          _buildTopInfo(item),
          SizedBox(height: AppSize.p8),
          _buildSectionHeader(AppString.productDetail),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildProductDetailsList(item),
                _buildSectionHeader(AppString.lockerDetail),
                SizedBox(height: AppSize.p8),
                _buildLockerDetailTable(item),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopInfo(ProductList? item) {
    return horizontalPadding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item?.custName ?? "N/A",
                style: TextStyle(
                  color: AppColor.activeColor,
                  fontSize: AppSize.size18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                item?.girviDate ?? "",
                style: TextStyle(
                  color: AppColor.textColor,
                  fontSize: AppSize.mediumText,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${item?.metalName} Karat ${item?.prodType} ${item?.catName}",
                style: TextStyle(
                  color: AppColor.dark.withOpacity(0.7),
                  fontSize: AppSize.size18,
                ),
              ),
              Text(
                item?.status ?? AppString.pending,
                style: TextStyle(
                  color:
                      (item?.status == AppString.active ||
                          item?.status == AppString.open)
                      ? AppColor.deleteColor
                      : AppColor.activeColor,
                  fontSize: AppSize.size18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      children: [
        Divider(color: AppColor.boderSideColor.shade300, thickness: 1),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: Get.width * 0.042,
              fontWeight: FontWeight.w500,
              color: AppColor.dark,
            ),
          ),
        ),
        Divider(color: Colors.grey.shade300, thickness: 1),
      ],
    );
  }

  Widget _buildProductDetailsList(ProductList? item) {
    return horizontalPadding(
      child: Column(
        children: [
          _buildDetailRow(
            AppIcon.badge,
            "${AppString.girviId} :",
            item?.uniqueId ?? "",
            isValueGreen: true,
          ),
          _buildDetailRow(
            AppIcon.balance,
            AppString.weightColon,
            "${item?.weight}${AppString.gm}",
          ),
          _buildDetailRow(
            AppIcon.rupee,
            "${AppString.amtGiven} :",
            item?.givenAmount ?? "0.00",
          ),
          _buildDetailRow(
            AppIcon.rupee,
            "${AppString.actualAmt} :",
            item?.balance ?? "0.00",
          ),
          _buildDetailRow(AppIcon.balance, "${AppString.rate} :", "74500.00"),
          _buildDetailRow(
            AppIcon.calendar,
            "${AppString.girviDt} :",
            item?.girviDate ?? "",
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value, {
    bool isValueGreen = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColor.activeColor, size: 22),
          SizedBox(width: AppSize.p16),
          SizedBox(
            width: Get.width * 0.28,
            child: Text(
              label,
              style: TextStyle(
                fontSize: AppSize.mediumText,
                fontWeight: FontWeight.w500,
                color: AppColor.dark,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: AppSize.mediumText,
              color: isValueGreen ? AppColor.activeColor : AppColor.dark,
              fontWeight: isValueGreen ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLockerDetailTable(ProductList? item) {
    return horizontalPadding(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  AppString.locker,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppSize.mediumText,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  AppString.returnDate,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppSize.mediumText,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.p8),
          Row(
            children: [
              Expanded(
                child: Text(
                  "${item?.lockerCode}-${item?.code}",
                  style: TextStyle(fontSize: AppSize.mediumText),
                ),
              ),
              Expanded(
                child: Text(
                  "-",
                  style: TextStyle(fontSize: AppSize.mediumText),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
