// ignore_for_file: deprecated_member_use, strict_top_level_inference, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/home/dashbord_Controller.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/drawer.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:rukmini/view/utils/widget/locker_bar_chart.dart';
import 'package:shimmer/shimmer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final dashbord = Get.put(DashbordController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CallApi.callDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Fullscreen(
      drawer: homeDrawer(),
      backGroundcolor: AppColor.backgroundColor,
      appBar: appBar(title: AppString.homeScreen),
      child: Obx(() {
        final api = dashbord;
        final loading = api.isLoading.value;
        final dashboardData = api.dashboardData.value;
        final dataValue = dashboardData.data;

        if (loading || dataValue == null) {
          return loadingWait();
        }

        return RefreshIndicator(
          backgroundColor: AppColor.backgroundColor,
          color: AppColor.primaryColor,
          elevation: 2.0,
          onRefresh: CallApi.callDashboard,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                varticalSpace(),
                totalValueName(
                  //Value Navigate
                  customerOnTap: () => Get.toNamed('/custList'),

                  //Value
                  totalCustomer: dataValue.totalCust.toString(),
                  totalGirvi: dataValue.totalGirvi.toString(),
                  totalKarkit: dataValue.totalKarkit.toString(),
                  totalSold: dataValue.totalSold.toString(),
                  totalDueGirvi: dataValue.totalDueGirvi.toString(),
                  totalDueOverGirvi: dataValue.totalDueOverGirvi.toString(),
                  totalPendingProduct: dataValue.totalPendingProduct.toString(),
                  totalReturnProduct: dataValue.totalReturnProduct.toString(),
                ),
                varticalSpace(),
                if (dataValue.lockerList != null &&
                    dataValue.lockerList!.isNotEmpty)
                  LockerBarChart(lockerList: dataValue.lockerList!),
                varticalSpace(),
              ],
            ),
          ),
        );
      }),
    );
  }
}

Widget loadingWait() {
  return Shimmer.fromColors(
    baseColor: AppColor.baseColor!,
    highlightColor: AppColor.highlightColor!,
    child: SingleChildScrollView(
      child: Column(
        children: [
          varticalSpace(),
          Column(
            children: List.generate(
              4,
              (index) => Padding(
                padding: EdgeInsets.only(bottom: Get.height * 0.012),
                child: Row(
                  children: [
                    Expanded(child: shimmerCard()),
                    horizontalSpace(),
                    Expanded(child: shimmerCard()),
                  ],
                ),
              ),
            ),
          ),
          varticalSpace(),
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          varticalSpace(),
        ],
      ),
    ),
  );
}

Widget totalValueName({
  required String totalCustomer,
  required String totalGirvi,
  required String totalKarkit,
  required String totalSold,
  required String totalDueGirvi,
  required String totalDueOverGirvi,
  required String totalPendingProduct,
  required String totalReturnProduct,
  void Function()? customerOnTap,
}) {
  return Column(
    children: [
      Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: customerOnTap,
              child: totalValue(
                title: totalCustomer,
                label: AppString.totalCustomer,
              ),
            ),
          ),
          horizontalSpace(),
          Expanded(
            child: totalValue(title: totalGirvi, label: AppString.totalGirvi),
          ),
        ],
      ),
      varticalSpace(),
      Row(
        children: [
          Expanded(
            child: totalValue(
              title: totalPendingProduct,
              label: AppString.totalPendingProduct,
            ),
          ),
          horizontalSpace(),
          Expanded(
            child: totalValue(
              title: totalReturnProduct,
              label: AppString.totalReturnProduct,
            ),
          ),
        ],
      ),
      varticalSpace(),
      Row(
        children: [
          Expanded(
            child: totalValue(title: totalKarkit, label: AppString.totalKarkit),
          ),
          horizontalSpace(),
          Expanded(
            child: totalValue(title: totalSold, label: AppString.totalSold),
          ),
        ],
      ),
      varticalSpace(),
      Row(
        children: [
          Expanded(
            child: totalValue(
              title: totalDueGirvi,
              label: AppString.totalDueGirvi,
            ),
          ),
          horizontalSpace(),
          Expanded(
            child: totalValue(
              title: totalDueOverGirvi,
              label: AppString.totalDueOverGirvi,
            ),
          ),
        ],
      ),
    ],
  );
}

Widget totalValue({required String title, required String label}) {
  return AspectRatio(
    aspectRatio: 1,
    child: Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Get.width * 0.02),
        color: AppColor.fullScreenColor,
        boxShadow: kElevationToShadow[1],
        border: Border.all(color: AppColor.textField.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          varticalSpace(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.025),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                label,
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: Get.width * 0.033,
                ),
              ),
            ),
          ),
          Spacer(),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Get.width * 0.06,
              color: AppColor.primaryColor,
            ),
          ),
          Spacer(),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
            decoration: BoxDecoration(color: AppColor.primaryColor),
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: Get.width * 0.035,
                color: AppColor.backgroundColor,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget varticalSpace() => SizedBox(height: Get.height * 0.012);

Widget horizontalSpace() => SizedBox(width: Get.width * 0.025);

Widget shimmerCard() {
  return AspectRatio(
    aspectRatio: 1,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Get.width * 0.02),
        color: Colors.white,
      ),
    ),
  );
}
