import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/drawer/home/girvi/giriviDetail_Controller.dart';
import 'package:rukmini/modal/drawer/home/girvi/girvi_detail_modal.dart';
import 'package:rukmini/modal/drawer/locker/locker_wise_del_modal.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
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
  final giriviDetailController = Get.put(GiriviDetailController());
  late LockerWiseData? lockerData;

  @override
  void initState() {
    super.initState();
    lockerData = Get.arguments;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (lockerData?.girviId != null) {
        CallApi.callGiriviDetail(girviId: lockerData!.girviId!);
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
            title: Obx(() {
              final detail = giriviDetailController.giriviDetailData.value.data;
              bool isOpen = detail?.isClosed != "1";
              return RichText(
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
                    TextSpan(
                      text: isOpen ? "( Open )" : "( Closed )",
                      style: TextStyle(
                        color: isOpen
                            ? AppColor.activeColor
                            : AppColor.errorColor,
                        fontSize: Get.width * 0.04,
                      ),
                    ),
                  ],
                ),
              );
            }),
            centerTitle: true,
            back: true,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: AppColor.primaryColor,
          shape: const CircleBorder(),
          child: const Icon(AppIcon.add, color: AppColor.activeColor, size: 30),
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
                if (giriviDetailController.isLoading.value) {
                  return _shimmerLoading();
                }

                final detail =
                    giriviDetailController.giriviDetailData.value.data;
                if (detail == null) {
                  return const Center(child: Text("No data found"));
                }

                return TabBarView(
                  children: [
                    _buildProductDetails(detail),
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

  Widget _buildProductDetails(GiriviDetailData detail) {
    // Assuming we want the product detail matching ProdLockerId or the first one
    final product =
        detail.productDetail?.firstWhereOrNull(
          (p) => p.productId == lockerData?.prodLockerId,
        ) ??
        (detail.productDetail?.isNotEmpty == true
            ? detail.productDetail!.first
            : ProductDetail());

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
                            color: product.productStatus == "Active"
                                ? AppColor.orange
                                : AppColor.activeColor,
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
        ),
      ],
    );
  }

  Widget _buildTransactionDetails(GiriviDetailData detail) {
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
                    "${detail.givenAmt} (${detail.interest} %)",
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildTransItem(
                        "Tot Int : ",
                        "${detail.tillInterest} (${detail.tillMonth} mon.)",
                      ),
                      Text(
                        "Till ${detail.tillDate}",
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
                children: [_buildTransItem("Bal. Amt : ", "${detail.balance}")],
              ),
              SizedBox(height: Get.height * 0.015),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTransItem("Paid Amt : ", "${detail.totalPaidAmt}"),
                  _buildTransItem("Paid Int : ", "${detail.paidInterset}"),
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
