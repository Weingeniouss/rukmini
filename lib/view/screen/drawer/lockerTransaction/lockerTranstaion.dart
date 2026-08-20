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
      drawer: homeDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(
          () => appBar(
            title: uiController.isSearching.value
                ? TextField(
                    controller: uiController.searchController,
                    autofocus: true,
                    style: TextStyle(color: AppColor.white, fontSize: AppSize.headingText),
                    decoration: InputDecoration(
                      hintText: AppString.search,
                      hintStyle: TextStyle(color: AppColor.otherWhite),
                      border: InputBorder.none,
                    ),
                    onChanged: (val) => uiController.updateSearch(val),
                  )
                : AppString.lockerTransaction,
            searchIcon: !uiController.isSearching.value,
            close: uiController.isSearching.value,
            searchOnPressed: () => uiController.toggleSearch(),
            closeOnPressed: () => uiController.closeSearch(),
            back: false,
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
                return const Center(child: Text(AppString.noTransactionsFound));
              }

              return RefreshIndicator(
                onRefresh: () => uiController.fetchLockerWiseDetails(
                  uiController.selectedLocker.value?.lockerId ?? "",
                ),
                color: AppColor.activeColor,
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(vertical: AppSize.p4),
                  itemCount: uiController
                      .lockerWiseDelController
                      .lockerWiseList
                      .length,
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: AppColor.boderSideColor.withOpacity(0.3),
                      height: 1,
                    );
                  },
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

  Widget _buildLockerSelector() {
    return GestureDetector(
      onTap: () => _showLockerSelection(),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.p16,
          vertical: Get.height * 0.015,
        ),
        decoration: BoxDecoration(
          color: AppColor.fullScreenColor,
          border: Border(
            bottom: BorderSide(color: AppColor.boderSideColor.withOpacity(0.3)),
          ),
        ),
        child: Row(
          children: [
            Icon(
              AppIcon.locker,
              color: AppColor.activeColor,
              size: AppSize.p24,
            ),
            SizedBox(width: AppSize.p12),
            Expanded(
              child: Obx(() {
                final selected = uiController.selectedLocker.value;
                if (selected == null) {
                  return Text(
                    AppString.selectLocker,
                    style: TextStyle(
                      color: AppColor.textColor,
                      fontSize: Get.width * 0.042,
                    ),
                  );
                }
                return Text(
                  "${selected.lockerCode} (${selected.comName}) [${selected.totalAmt}]",
                  style: TextStyle(
                    color: AppColor.dark,
                    fontSize: Get.width * 0.042,
                  ),
                );
              }),
            ),
            Icon(
              AppIcon.arrowDown,
              color: AppColor.activeColor,
              size: AppSize.p24,
            ),
          ],
        ),
      ),
    );
  }

  void _showLockerSelection() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.4,
        decoration: BoxDecoration(
          color: AppColor.fullScreenColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(Get.width * 0.04),
              child: Text(
                AppString.selectLocker,
                style: TextStyle(
                  fontSize: Get.width * 0.03,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: Obx(() {
                if (uiController.lockerTransController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (uiController
                    .lockerTransController
                    .lockerTransList
                    .isEmpty) {
                  return const Center(child: Text(AppString.noLockersAvailable));
                }
                return ListView.builder(
                  itemCount:
                      uiController.lockerTransController.lockerTransList.length,
                  itemBuilder: (context, index) {
                    final locker = uiController
                        .lockerTransController
                        .lockerTransList[index];
                    return ListTile(
                      title: Text(
                        "${locker.lockerCode} (${locker.comName})",
                        style: TextStyle(fontSize: Get.width * 0.04),
                      ),
                      subtitle: Text("${AppString.totalAmt}: ${locker.totalAmt}"),
                      onTap: () {
                        uiController.selectLocker(locker);
                        Get.back();
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCard(LockerWiseData data) {
    return horizontalPadding(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Get.height * 0.015),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.custName ?? "N/A",
              style: TextStyle(
                color: AppColor.activeColor,
                fontWeight: FontWeight.w600,
                fontSize: AppSize.p16,
              ),
            ),
            SizedBox(height: Get.height * 0.005),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildRichText("${AppString.girviId} : ", data.uniqueId ?? ""),
                _buildRichText(
                  "${AppString.lockerCode} : ",
                  "${data.lockerCode}-${data.code}",
                ),
              ],
            ),
            SizedBox(height: Get.height * 0.005),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildRichText(
                  "${AppString.proTyp} : ",
                  "${data.tatalProd} ${AppString.pcs}",
                ),
                _buildRichText(
                  "${AppString.tknAmt} : ",
                  data.totalAmt ?? "0.00",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRichText(String label, String value) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: AppSize.size14, color: AppColor.dark),
        children: [
          TextSpan(
            text: label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColor.textColor,
            ),
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
      child: ListView.separated(
        itemCount: 6,
        padding: EdgeInsets.all(AppSize.p16),
        separatorBuilder: (context, index) =>
            SizedBox(height: AppSize.p8),
        itemBuilder: (context, index) {
          return Container(
            height: 80,
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
