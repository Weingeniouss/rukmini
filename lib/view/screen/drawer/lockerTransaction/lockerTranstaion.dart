// ignore_for_file: file_names, unnecessary_non_null_assertion, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/ui/home/locker/locker_trans_ui_controller.dart';
import 'package:rukmini/modal/drawer/locker/locker_wise_del_modal.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/drawer.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:rukmini/view/utils/widget/horizontalPadding.dart';

class LockerTranStaion extends StatelessWidget {
  final LockerTransUIController uiController;

  const LockerTranStaion({super.key, required this.uiController});

  @override
  Widget build(BuildContext context) {
    return Fullscreen(
      isPadding: false,
      backGroundcolor: AppColor.backgroundColor,
      drawer: homeDrawer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + AppSize.p12),
        child: Obx(
          () => appBar(
            centerTitle: true,
            back: false,
            title: uiController.isSearching.value
                ? TextField(
                    controller: uiController.searchController,
                    autofocus: true,
                    style: TextStyle(
                      color: AppColor.dark,
                      fontSize: AppSize.headingText,
                    ),
                    decoration: InputDecoration(
                      hintText: AppString.search,
                      hintStyle: TextStyle(color: AppColor.textColor),
                      border: InputBorder.none,
                    ),
                    onChanged: (val) => uiController.updateSearch(val),
                  )
                : _buildDecorativeTitle(AppString.lockerTransaction),
            searchIcon: !uiController.isSearching.value,
            close: uiController.isSearching.value,
            searchOnPressed: () => uiController.toggleSearch(),
            closeOnPressed: () => uiController.closeSearch(),
          ),
        ),
      ),
      child: Column(
        children: [
          _buildLockerSelector(),
          Expanded(
            child: Obx(() {
              if (uiController.lockerWiseDelController.isLoading.value &&
                  uiController.lockerWiseDelController.lockerWiseList.isEmpty) {
                return _shimmerLoading();
              }

              if (uiController.lockerWiseDelController.lockerWiseList.isEmpty) {
                return Center(
                  child: Text(
                    AppString.noTransactionsFound,
                    style: TextStyle(
                      color: AppColor.textColor,
                      fontSize: AppSize.commonText,
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => uiController.fetchLockerWiseDetails(
                  uiController.selectedLocker.value?.lockerId ?? "",
                ),
                color: AppColor.goldColor,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(vertical: AppSize.p8),
                  itemCount: uiController
                      .lockerWiseDelController
                      .lockerWiseList
                      .length,
                  itemBuilder: (context, index) {
                    final item = uiController
                        .lockerWiseDelController
                        .lockerWiseList[index];
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed('/lockerTransationDetail', arguments: item);
                      },
                      child: _buildTransactionCard(item),
                    );
                  },
                ),
              );
            }),
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

  Widget _buildLockerSelector() {
    return horizontalPadding(
      child: GestureDetector(
        onTap: () => _showLockerSelectionDialog(),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: AppSize.p12),
          padding: EdgeInsets.all(AppSize.p12),
          decoration: BoxDecoration(
            color: AppColor.whiteOrang.withOpacity(0.3),
            borderRadius: BorderRadius.circular(AppSize.p12),
            border: Border.all(color: AppColor.goldColor.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSize.p8),
                decoration: BoxDecoration(
                  color: AppColor.goldColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  AppIcon.locker,
                  color: AppColor.goldColor,
                  size: AppSize.p20,
                ),
              ),
              SizedBox(width: AppSize.p12),
              Expanded(
                child: Obx(() {
                  final selected = uiController.selectedLocker.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppString.selectLocker,
                        style: TextStyle(
                          color: AppColor.textColor,
                          fontSize: AppSize.size12,
                        ),
                      ),
                      Text(
                        selected != null
                            ? "${selected.lockerCode} (${selected.comName}) [${selected.totalAmt}]"
                            : AppString.selectLocker,
                        style: TextStyle(
                          color: AppColor.dark,
                          fontSize: AppSize.size14,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  );
                }),
              ),
              Icon(
                AppIcon.arrow_down,
                color: AppColor.goldColor,
                size: AppSize.p24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLockerSelectionDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColor.white,
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.p16),
        ),
        title: Container(
          padding: EdgeInsets.all(AppSize.p16),
          decoration: BoxDecoration(
            color: AppColor.goldColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSize.p16),
              topRight: Radius.circular(AppSize.p16),
            ),
          ),
          child: Text(
            AppString.selectLocker,
            style: TextStyle(
              color: AppColor.white,
              fontSize: AppSize.headingText,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Obx(() {
            if (uiController.lockerTransController.isLoading.value) {
              return SizedBox(
                height: AppSize.height * 0.2,
                child: const Center(
                  child: CircularProgressIndicator(color: AppColor.goldColor),
                ),
              );
            }
            if (uiController.lockerTransController.lockerTransList.isEmpty) {
              return Padding(
                padding: EdgeInsets.all(AppSize.p20),
                child: const Text(AppString.noLockersAvailable),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              itemCount:
                  uiController.lockerTransController.lockerTransList.length,
              separatorBuilder: (context, index) => Divider(
                color: AppColor.goldColor.withOpacity(0.1),
                height: AppSize.p4 / 4,
                thickness: AppSize.p4 / 4,
              ),
              itemBuilder: (context, index) {
                final locker =
                    uiController.lockerTransController.lockerTransList[index];
                return ListTile(
                  title: Text(
                    "${locker.lockerCode} (${locker.comName})",
                    style: TextStyle(
                      color: AppColor.dark,
                      fontSize: AppSize.size14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    "${AppString.totalAmt}: ${locker.totalAmt}",
                    style: TextStyle(
                      color: AppColor.textColor,
                      fontSize: AppSize.size12,
                    ),
                  ),
                  onTap: () {
                    uiController.selectLocker(locker);
                    Get.back();
                  },
                );
              },
            );
          }),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              AppString.cancel,
              style: TextStyle(
                color: AppColor.goldColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(LockerWiseData data) {
    return horizontalPadding(
      child: Container(
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
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: AppSize.p4,
                decoration: BoxDecoration(
                  color: AppColor.goldColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppSize.p12),
                    bottomLeft: Radius.circular(AppSize.p12),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(AppSize.p12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.custName ?? AppString.na,
                        style: TextStyle(
                          color: AppColor.goldColor,
                          fontWeight: FontWeight.bold,
                          fontSize: AppSize.size18,
                        ),
                      ),
                      SizedBox(height: AppSize.p12),
                      Row(
                        children: [
                          Expanded(
                            child: _infoItem(
                              AppString.girviId,
                              data.uniqueId ?? AppString.na,
                            ),
                          ),
                          Expanded(
                            child: _infoItem(
                              AppString.lockerCode,
                              "${data.lockerCode}-${data.code}",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSize.p12),
                      Row(
                        children: [
                          Expanded(
                            child: _infoItem(
                              AppString.proTyp,
                              "${data.tatalProd} ${AppString.pcs}",
                            ),
                          ),
                          Expanded(
                            child: _infoItem(
                              AppString.totalAmt,
                              data.totalAmt ?? "0.00",
                              isCritical: true,
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
        ),
      ),
    );
  }

  Widget _infoItem(String label, String value, {bool isCritical = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppSize.size12,
            color: AppColor.textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: AppSize.p4 / 2),
        Text(
          value,
          style: TextStyle(
            fontSize: AppSize.size14,
            fontWeight: FontWeight.w600,
            color: isCritical ? AppColor.goldColor : AppColor.dark,
          ),
        ),
      ],
    );
  }

  Widget _shimmerLoading() {
    return Shimmer.fromColors(
      baseColor: AppColor.baseColor!,
      highlightColor: AppColor.highlightColor!,
      child: ListView.builder(
        itemCount: 6,
        padding: EdgeInsets.all(AppSize.p16),
        itemBuilder: (context, index) {
          return Container(
            height: AppSize.height * 0.15,
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
