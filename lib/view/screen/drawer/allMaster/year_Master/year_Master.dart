// ignore_for_file: file_names, unnecessary_non_null_assertion, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/year/year_Controller.dart';
import 'package:rukmini/modal/year/year_modal.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/view/utils/app_size.dart';
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
      backGroundcolor: AppColor.backgroundColor,
      appBar: appBar(
        title: _buildDecorativeTitle(),
        back: true,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/addYearMaster');
        },
        backgroundColor: AppColor.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.p12),
        ),
        child: Icon(
          AppIcon.add,
          color: AppColor.goldColor,
          size: AppSize.p24 + AppSize.p4,
        ),
      ),
      child: Column(
        children: [
          _buildFilterAndAddSection(),
          const Divider(height: 1),
          Expanded(
            child: Obx(() {
              if (yearController.isLoading.value &&
                  yearController.yearList.isEmpty) {
                return _shimmerLoading();
              }

              if (yearController.yearList.isEmpty) {
                return Center(child: Text(AppString.noDataFound));
              }

              return RefreshIndicator(
                onRefresh: CallApi.callYearList,
                color: AppColor.goldColor,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.p16,
                    vertical: AppSize.p12,
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

  Widget _buildDecorativeTitle() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppString.yearMaster,
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
              width: AppSize.width * 0.1,
              height: 1,
              color: AppColor.goldColor.withOpacity(0.5),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.p4),
              child: Transform.rotate(
                angle: 0.785, // 45 degrees
                child: Container(
                  width: AppSize.p8,
                  height: AppSize.p8,
                  color: AppColor.goldColor,
                ),
              ),
            ),
            Container(
              width: AppSize.width * 0.1,
              height: 1,
              color: AppColor.goldColor.withOpacity(0.5),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterAndAddSection() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.p16,
        vertical: AppSize.p8,
      ),
      color: AppColor.white,
      child: Row(
        children: [
          Icon(AppIcon.grid, color: AppColor.goldColor, size: AppSize.p24),
          SizedBox(width: AppSize.p16),
          Text(
            AppString.yearMaster,
            style: TextStyle(
              fontSize: AppSize.commonText,
              color: AppColor.goldColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Get.toNamed('/addYearMaster'),
            child: Container(
              padding: EdgeInsets.all(AppSize.p4),
              decoration: BoxDecoration(
                color: AppColor.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColor.goldColor, width: 1.5),
              ),
              child: Icon(
                AppIcon.add,
                color: AppColor.goldColor,
                size: AppSize.p20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearCard(YearData year) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSize.p16),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSize.p12),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left gold indicator
              Container(width: AppSize.p4, color: AppColor.goldColor),
              _buildYearCardDetails(year),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildYearCardDetails(YearData year) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(AppSize.p12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Checkmark icon
                Container(
                  padding: EdgeInsets.all(AppSize.p4 / 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColor.goldColor, width: 1.5),
                  ),
                  child: Icon(
                    AppIcon.check,
                    color: AppColor.goldColor,
                    size: AppSize.size14,
                  ),
                ),
                SizedBox(width: AppSize.p12),
                // Icon in Cream Circle
                Container(
                  padding: EdgeInsets.all(AppSize.p8),
                  decoration: BoxDecoration(
                    color: AppColor.whiteOrang.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    AppIcon.calendar,
                    color: AppColor.goldColor,
                    size: AppSize.p24,
                  ),
                ),
                SizedBox(width: AppSize.p12),
                // Title
                Expanded(
                  child: Text(
                    year.title ?? "",
                    style: TextStyle(
                      color: AppColor.black,
                      fontSize: AppSize.commonText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Actions
                _buildActionButtons(year),
              ],
            ),
            SizedBox(height: AppSize.p12),
            const Divider(height: 1),
            SizedBox(height: AppSize.p8),
            // Date Details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetailItem(AppIcon.date, year.formDate ?? ""),
                _buildDetailItem(AppIcon.date, year.toDate ?? ""),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(YearData year) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Get.toNamed('/addYearMaster', arguments: year);
          },
          icon: Icon(AppIcon.editNote, color: AppColor.goldColor),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        Container(
          width: 1,
          height: AppSize.p20,
          color: AppColor.grey300,
          margin: EdgeInsets.symmetric(horizontal: AppSize.p8),
        ),
        IconButton(
          onPressed: () => _showDeleteDialog(year),
          icon: Container(
            padding: EdgeInsets.all(AppSize.p4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColor.red.withOpacity(0.5)),
            ),
            child: Icon(
              AppIcon.deleteIcon,
              color: AppColor.red,
              size: AppSize.p16,
            ),
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  Widget _buildDetailItem(IconData icon, String value) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppSize.p16, color: AppColor.goldColor),
          SizedBox(width: AppSize.p8),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                color: AppColor.black,
                fontSize: AppSize.size12,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
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
      confirmTextColor: AppColor.white,
      buttonColor: AppColor.red,
      onConfirm: () async {
        Get.back();
        await CallApi.callYearRemove(yearId: year.yearId ?? "");
        await CallApi.callYearList();
      },
    );
  }

  Widget _shimmerLoading() {
    return Shimmer.fromColors(
      baseColor: AppColor.grey300,
      highlightColor: AppColor.white,
      child: ListView.builder(
        itemCount: 6,
        padding: EdgeInsets.all(AppSize.p16),
        itemBuilder: (context, index) {
          return Container(
            height: AppSize.width * 0.25,
            margin: EdgeInsets.only(bottom: AppSize.p16),
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
