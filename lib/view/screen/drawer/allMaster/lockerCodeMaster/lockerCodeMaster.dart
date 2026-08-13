// ignore_for_file: unnecessary_non_null_assertion, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/drawer/all_master/locker_master/lockerList_Controller.dart';
import 'package:rukmini/controller/api/controllers/drawer/all_master/locker_master/lockerRemove_Controller.dart';
import 'package:rukmini/modal/drawer/allMaster/locker_master/locker_master_modal.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
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
    return Obx(() {
      return Fullscreen(
        drawer: homeDrawer(),
        isPadding: false,
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColor.primaryColor,
          onPressed: () {
            Get.toNamed('/addLockerCode');
          },
          child: Icon(AppIcon.add, color: AppColor.activeColor),
        ),
        appBar: appBar(
          back: true,
          centerTitle: true,
          title: lockerController.isSearching.value
              ? TextField(
                  controller: lockerController.searchTextController,
                  autofocus: true,
                  style: TextStyle(color: AppColor.fullScreenColor),
                  cursorColor: AppColor.fullScreenColor,
                  decoration: InputDecoration(
                    hintText: AppString.searchLocker,
                    hintStyle: TextStyle(color: AppColor.otherWhite),
                    border: InputBorder.none,
                  ),
                )
              : AppString.lockerCodeMaster,
          searchIcon: true,
          searchOnPressed: () {
            lockerController.isSearching.value =
                !lockerController.isSearching.value;
            if (!lockerController.isSearching.value) {
              lockerController.searchTextController.clear();
            }
          },
        ),
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
            color: AppColor.activeColor,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
              itemCount: list.length,
              itemBuilder: (context, index) {
                return _buildLockerCard(list[index]);
              },
            ),
          );
        }),
      );
    });
  }

  Widget _buildLockerCard(LockerData item) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Get.width * 0.04,
        vertical: Get.height * 0.008,
      ),
      decoration: BoxDecoration(
        color: AppColor.fullScreenColor,
        border: Border.all(color: AppColor.grey300),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onLongPress: () {
          _showDeleteDialog(item);
        },
        child: Padding(
          padding: EdgeInsets.all(Get.width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRichText(
                AppString.code,
                "${item.lockerCode} (${item.interestRate ?? '0.00'} %)",
                isGreenValue: true,
              ),
              _buildRichText(
                AppString.company,
                item.comName ?? "",
                isGreenValue: true,
              ),
              SizedBox(height: Get.height * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildRichText(AppString.name, item.personName ?? ""),
                  _buildRichText(AppString.number, item.personPhone ?? ""),
                ],
              ),
              SizedBox(height: Get.height * 0.01),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _buildRichText(
                        AppString.address,
                        item.comAddress ?? "",
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.toNamed('/addLockerCode', arguments: item);
                      },
                      icon: Icon(
                        AppIcon.editNote,
                        color: AppColor.activeColor,
                        size: Get.width * 0.06,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
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

  void _showDeleteDialog(LockerData item) {
    Get.defaultDialog(
      title: AppString.deleteCustomer,
      middleText: "${AppString.deleteMessage} \n\n ${item.lockerCode}",
      textConfirm: AppString.delete,
      textCancel: AppString.cancel,
      confirmTextColor: AppColor.white,
      buttonColor: AppColor.deleteColor,
      onConfirm: () async {
        Get.back();
        await lockerRemoveController.removeLocker(
          lockerId: item.lockerId ?? "",
        );
      },
    );
  }

  Widget _buildRichText(
    String label,
    String value, {
    bool isGreenValue = false,
  }) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: AppColor.dark,
          fontSize: Get.width * 0.038,
          fontFamily: 'Poppins',
        ),
        children: [
          TextSpan(
            text: "$label : ",
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              color: isGreenValue ? AppColor.activeColor : AppColor.dark,
              fontWeight: isGreenValue ? FontWeight.w500 : FontWeight.w400,
            ),
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
        itemCount: 5,
        padding: EdgeInsets.all(Get.width * 0.04),
        itemBuilder: (context, index) {
          return Container(
            height: 100,
            margin: EdgeInsets.only(bottom: Get.height * 0.02),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(5),
            ),
          );
        },
      ),
    );
  }
}
