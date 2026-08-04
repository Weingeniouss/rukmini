// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/year/year_Controller.dart';
import 'package:rukmini/modal/year/year_modal.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:shimmer/shimmer.dart';

class YearMaster extends StatefulWidget {
  const YearMaster({super.key});

  @override
  State<YearMaster> createState() => _YearMasterState();
}

class _YearMasterState extends State<YearMaster> {
  final yearController = Get.put(YearController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CallApi.callYearList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Fullscreen(
      isPadding: false,
      appBar: appBar(
        title: AppString.yearMaster,
        back: true,
        centerTitle: true,
        searchIcon: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/addYearMaster');
        },
        backgroundColor: AppColor.primaryColor,
        shape: CircleBorder(),
        child: Icon(AppIcon.add, color: AppColor.activeColor, size: 30),
      ),
      child: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (yearController.isLoading.value &&
                  yearController.yearList.isEmpty) {
                return _shimmerLoading();
              }

              if (yearController.yearList.isEmpty) {
                return Center(child: Text("No Data Found"));
              }

              return RefreshIndicator(
                onRefresh: CallApi.callYearList,
                color: AppColor.activeColor,
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    vertical: Get.height * 0.02,
                    horizontal: Get.width * 0.03,
                  ),
                  itemCount: yearController.yearList.length,
                  itemBuilder: (context, index) {
                    return _buildYearCard(yearController.yearList[index]);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildYearCard(YearData year) {
    return Container(
      margin: EdgeInsets.only(bottom: Get.height * 0.02),
      padding: EdgeInsets.all(Get.width * 0.04),
      decoration: BoxDecoration(
        color: AppColor.fullScreenColor,
        border: Border.all(
          color: AppColor.boderSideColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.dark.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    year.title ?? '',
                    style: TextStyle(
                      color: AppColor.activeColor,
                      fontSize: Get.width * 0.045,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: Get.height * 0.015),
                  Row(
                    children: [
                      _buildDateText("From :", year.formDate ?? ''),
                      SizedBox(width: Get.width * 0.05),
                      _buildDateText("To:", year.toDate ?? ''),
                    ],
                  ),
                ],
              ),
              IconButton(
                onPressed: () => _showDeleteDialog(year),
                icon: Icon(
                  AppIcon.remove,
                  color: AppColor.activeColor,
                  size: Get.width * 0.07,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(YearData year) {
    Get.defaultDialog(
      title: AppString.deleteYear,
      middleText: "${AppString.deleteYearMessage}\n\n${year.title}",
      textConfirm: AppString.delete,
      textCancel: AppString.cancel,
      confirmTextColor: AppColor.fullScreenColor,
      buttonColor: AppColor.deleteColor,
      onConfirm: () async {
        Get.back();
        await CallApi.callYearRemove(yearId: year.yearId ?? "");
        await CallApi.callYearList();
      },
    );
  }

  Widget _buildDateText(String label, String date) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: Get.width * 0.04, color: AppColor.dark),
        children: [
          TextSpan(
            text: '$label ',
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          TextSpan(
            text: date,
            style: TextStyle(fontWeight: FontWeight.w500),
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
        padding: EdgeInsets.all(Get.width * 0.04),
        itemBuilder: (context, index) {
          return Container(
            height: 80,
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
