// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/controllers/drawer/locker/locker_detail_controller.dart';
import 'package:rukmini/modal/drawer/locker/locker_detail_modal.dart';
import 'package:rukmini/modal/drawer/locker/locker_wise_del_modal.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:shimmer/shimmer.dart';

class LockerTransationDetail extends StatefulWidget {
  const LockerTransationDetail({super.key});

  @override
  State<LockerTransationDetail> createState() => _LockerTransationDetailState();
}

class _LockerTransationDetailState extends State<LockerTransationDetail> {
  final lockerDetailController = Get.put(LockerDetailController());
  late LockerWiseData? lockerData;

  @override
  void initState() {
    super.initState();
    lockerData = Get.arguments;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (lockerData?.lockerId != null && lockerData?.code != null) {
        lockerDetailController.getLockerDetail(
          lockerId: lockerData!.lockerId!,
          code: lockerData!.code!,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Fullscreen(
        isPadding: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: appBar(
            title: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: AppColor.fullScreenColor,
                  fontSize: Get.width * 0.05,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  TextSpan(
                    text: "${lockerData?.lockerCode}-${lockerData?.code} ",
                  ),
                  const TextSpan(
                    text: "( Open )",
                    style: TextStyle(color: AppColor.errorColor, fontSize: 14),
                  ),
                ],
              ),
            ),
            centerTitle: true,
            back: true,
          ),
        ),
        child: Column(
          children: [
            TabBar(
              labelColor: AppColor.primaryColor,
              unselectedLabelColor: AppColor.textColor,
              indicatorColor: AppColor.primaryColor,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(text: AppString.productDetail),
                Tab(text: AppString.transactionDetail),
              ],
            ),
            Expanded(
              child: Obx(() {
                if (lockerDetailController.isLoading.value) {
                  return _shimmerLoading();
                }

                final detail =
                    lockerDetailController.lockerDetailData.value.data;
                if (detail == null) {
                  return const Center(child: Text("No data found"));
                }

                return TabBarView(
                  children: [
                    _buildProductDetailsList(detail),
                    _buildTransactionDetails(detail),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductDetailsList(LockerDetailData detail) {
    if (detail.productList == null || detail.productList!.isEmpty) {
      return const Center(child: Text("No products found"));
    }
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
      itemCount: detail.productList!.length,
      itemBuilder: (context, index) {
        final product = detail.productList![index];
        return _buildProductDetailCard(product);
      },
    );
  }

  Widget _buildProductDetailCard(ProductListDetail product) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Get.width * 0.03,
        vertical: Get.height * 0.005,
      ),
      padding: EdgeInsets.all(Get.width * 0.04),
      decoration: BoxDecoration(
        color: AppColor.fullScreenColor,
        border: Border.all(color: AppColor.boderSideColor.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          _buildDetailRow(
            "Pro Typ : ",
            product.catName ?? "",
            "Metal : ",
            "${product.prodType} (${product.metalName} Karat)",
          ),
          SizedBox(height: Get.height * 0.015),
          _buildDetailRow(
            "Pcs : ",
            "${product.pieces} (${product.weight}gm)",
            "Orig Price : ",
            product.origAmount ?? "0.00",
          ),
          SizedBox(height: Get.height * 0.015),
          _buildDetailRow(
            "Gvn Amt : ",
            product.givenAmount ?? "0.00",
            "Rate : ",
            product.todayRate ?? "0.00",
          ),
          SizedBox(height: Get.height * 0.015),
          Row(
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: Get.width * 0.035,
                    color: AppColor.dark,
                  ),
                  children: [
                    const TextSpan(
                      text: "Status : ",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    TextSpan(
                      text: product.productStatus ?? "Pending",
                      style: TextStyle(
                        color: AppColor.orange,
                        fontWeight: FontWeight.w500,
                      ),
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

  Widget _buildTransactionDetails(LockerDetailData detail) {
    final trans = detail.transObj;
    if (trans == null) return const Center(child: Text("No transaction info"));

    return ListView(
      padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
      children: [
        Container(
          margin: EdgeInsets.all(Get.width * 0.03),
          padding: EdgeInsets.all(Get.width * 0.04),
          decoration: BoxDecoration(
            color: AppColor.fullScreenColor,
            border: Border.all(color: AppColor.boderSideColor.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTransItem(
                    "Tkn Amt : ",
                    "${trans.givenAmt} (${trans.interestRate} %)",
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildTransItem(
                        "Tot Int : ",
                        "${trans.tillInterest} (${trans.tillMonth} mon.)",
                      ),
                      Text(
                        "Till ${trans.tillDate}",
                        style: TextStyle(
                          fontSize: Get.width * 0.025,
                          color: AppColor.textColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.015),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [_buildTransItem("Bal. Amt : ", "${trans.balance}")],
              ),
              SizedBox(height: Get.height * 0.015),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTransItem("Paid Amt : ", "${trans.totalPaidAmt}"),
                  _buildTransItem("Paid Int : ", "${trans.paidInterset}"),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String l1, String v1, String l2, String v2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _buildRichItem(l1, v1)),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: _buildRichItem(l2, v2),
          ),
        ),
      ],
    );
  }

  Widget _buildRichItem(String label, String value) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: Get.width * 0.035, color: AppColor.dark),
        children: [
          TextSpan(
            text: label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          TextSpan(
            text: value,
            style: TextStyle(color: AppColor.textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildTransItem(String label, String value) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: Get.width * 0.035, color: AppColor.dark),
        children: [
          TextSpan(
            text: label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(fontWeight: FontWeight.w400),
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
        itemCount: 3,
        padding: EdgeInsets.all(Get.width * 0.04),
        itemBuilder: (context, index) {
          return Container(
            height: 120,
            margin: EdgeInsets.only(bottom: Get.height * 0.02),
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
