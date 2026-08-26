// ignore_for_file: file_names, unnecessary_non_null_assertion, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/drawer/all_master/locker_master/lockerList_Controller.dart';
import 'package:rukmini/controller/api/controllers/drawer/all_master/locker_master/lockerRemove_Controller.dart';
import 'package:rukmini/modal/drawer/allMaster/locker_master/locker_master_modal.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/drawer.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:shimmer/shimmer.dart';

class LockerCodeMaster extends StatefulWidget {
  const LockerCodeMaster({super.key});

  @override
  State<LockerCodeMaster> createState() => _LockerCodeMasterState();
}

class _LockerCodeMasterState extends State<LockerCodeMaster> {
  final lockerController = Get.put(LockerListController());
  final lockerRemoveController = Get.put(LockerRemoveController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CallApi.callLockerList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Fullscreen(
      drawer: homeDrawer(),
      isPadding: false,
      backGroundcolor: AppColor.backgroundColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.p12),
        ),
        onPressed: () => Get.toNamed('/addLockerCode'),
        child: Icon(
          AppIcon.add,
          color: AppColor.goldColor,
          size: AppSize.p24 + AppSize.p4,
        ),
      ),
      appBar: appBar(
        back: true,
        centerTitle: true,
        title: _buildDecorativeTitle(),
      ),
      child: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (lockerController.isLoading.value &&
                  lockerController.lockerList.isEmpty) {
                return _shimmerLoading();
              }

              final list = lockerController.filteredLockerList;

              if (list.isEmpty) {
                return const Center(child: Text(AppString.noDataFound));
              }

              return RefreshIndicator(
                onRefresh: () => CallApi.callLockerList(),
                color: AppColor.goldColor,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.p16,
                    vertical: AppSize.p12,
                  ),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return _buildLockerCard(list[index]);
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
          AppString.lockerCodeMaster,
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

  Widget _buildLockerCard(LockerData item) {
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
              _buildLockerCardDetails(item),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLockerCardDetails(LockerData item) {
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
                // Locker Icon in Cream Circle
                Container(
                  padding: EdgeInsets.all(AppSize.p8),
                  decoration: BoxDecoration(
                    color: AppColor.whiteOrang.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    AppIcon.locker,
                    color: AppColor.goldColor,
                    size: AppSize.p24,
                  ),
                ),
                SizedBox(width: AppSize.p12),
                // Title (Code)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${item.lockerCode} (${item.interestRate ?? '0.00'} %)",
                        style: TextStyle(
                          color: AppColor.black,
                          fontSize: AppSize.commonText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        item.comName ?? "",
                        style: TextStyle(
                          color: AppColor.textColor,
                          fontSize: AppSize.smallText,
                        ),
                      ),
                    ],
                  ),
                ),
                // Actions
                _buildActionButtons(item),
              ],
            ),
            SizedBox(height: AppSize.p12),
            const Divider(height: 1),
            SizedBox(height: AppSize.p8),
            // Details (Person & Phone)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetailItem(AppIcon.person, item.personName ?? ""),
                _buildDetailItem(AppIcon.phone, item.personPhone ?? ""),
              ],
            ),
            if (item.comAddress != null && item.comAddress!.isNotEmpty) ...[
              SizedBox(height: AppSize.p8),
              _buildDetailItem(
                AppIcon.location,
                item.comAddress!,
                isFullWidth: true,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(LockerData item) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Get.toNamed('/addLockerCode', arguments: item);
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
          onPressed: () => _showDeleteDialog(item),
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

  Widget _buildDetailItem(
    IconData icon,
    String value, {
    bool isFullWidth = false,
  }) {
    final content = Row(
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
    );

    return isFullWidth ? content : Expanded(child: content);
  }

  void _showDeleteDialog(LockerData item) {
    Get.defaultDialog(
      title: AppString.deleteCustomer,
      middleText: "${AppString.deleteMessage} \n\n ${item.lockerCode}",
      textConfirm: AppString.delete,
      textCancel: AppString.cancel,
      confirmTextColor: AppColor.white,
      buttonColor: AppColor.red,
      onConfirm: () async {
        Get.back();
        await lockerRemoveController.removeLocker(
          lockerId: item.lockerId ?? "",
        );
      },
    );
  }

  Widget _shimmerLoading() {
    return Shimmer.fromColors(
      baseColor: AppColor.grey300,
      highlightColor: AppColor.white,
      child: ListView.builder(
        itemCount: 5,
        padding: EdgeInsets.all(AppSize.p16),
        itemBuilder: (context, index) {
          return Container(
            height: AppSize.width * 0.3,
            margin: EdgeInsets.only(bottom: AppSize.p12),
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
