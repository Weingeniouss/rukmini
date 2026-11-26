// ignore_for_file: file_names, unnecessary_non_null_assertion, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/ui/widget/drawerControllerUI.dart';
import 'package:rukmini/controller/ui/home/locker/locker_trans_ui_controller.dart';
import 'package:rukmini/modal/drawer/locker/locker_wise_del_modal.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rukmini/view/utils/app_color.dart';
import 'package:rukmini/view/utils/app_icon.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/app_string.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/drawer.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:rukmini/view/utils/widget/horizontalPadding.dart';

class LockerTranStaion extends StatelessWidget {
  final LockerTransUIController uiController;

  const LockerTranStaion({super.key, required this.uiController});

  @override
  Widget build(BuildContext context) {
    final bool isDesktopOrTablet = AppSize.isDesktop || AppSize.isTablet;

    return Fullscreen(
      isPadding: false,
      backGroundcolor: AppColor.backgroundColor,
      drawer: homeDrawer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + AppSize.p12),
        child: Obx(
          () => appBar(
            centerTitle: true,
            back: true,
            title: uiController.isSearching.value
                ? TextField(
                    controller: uiController.searchController,
                    autofocus: true,
                    style: TextStyle(
                      color: AppColor.mainText,
                      fontSize: AppSize.headingText,
                    ),
                    decoration: InputDecoration(
                      hintText: AppString.search,
                      hintStyle: TextStyle(color: AppColor.subText),
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
                      color: AppColor.subText,
                      fontSize: AppSize.commonText,
                    ),
                  ),
                );
              }

              final list = uiController.lockerWiseDelController.lockerWiseList;

              return RefreshIndicator(
                onRefresh: () => uiController.fetchLockerWiseDetails(
                  uiController.selectedLocker.value?.lockerId ?? "",
                ),
                color: AppColor.goldColor,
                child: isDesktopOrTablet
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [_buildTableView(context, list)],
                      )
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(vertical: AppSize.p8),
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final item = list[index];
                          return GestureDetector(
                            onTap: () {
                              NavDrawerController.toNamed(
                                '/lockerTransationDetail',
                                arguments: item,
                              );
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
            color: AppColor.mainText,
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
            color: AppColor.cardBg,
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
                          color: AppColor.subText,
                          fontSize: AppSize.size12,
                        ),
                      ),
                      Text(
                        selected != null
                            ? "${selected.lockerCode} (${selected.comName}) [${selected.totalAmt}]"
                            : AppString.selectLocker,
                        style: TextStyle(
                          color: AppColor.mainText,
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
        backgroundColor: AppColor.cardBg,
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
                child: Text(
                  AppString.noLockersAvailable,
                  style: TextStyle(color: AppColor.subText),
                ),
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
                      color: AppColor.mainText,
                      fontSize: AppSize.size14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    "${AppString.totalAmt}: ${locker.totalAmt}",
                    style: TextStyle(
                      color: AppColor.subText,
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

  Widget _buildTableView(BuildContext context, List<LockerWiseData> items) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.p16,
        vertical: AppSize.p8,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColor.cardBg,
          borderRadius: BorderRadius.circular(AppSize.p12),
          border: Border.all(color: AppColor.border),
          boxShadow: [
            BoxShadow(
              color: AppColor.black.withOpacity(AppColor.isDark ? 0.3 : 0.04),
              blurRadius: AppSize.p10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: AppColor.tableDivider,
                  ),
                  child: DataTable(
                    headingRowColor:
                        WidgetStateProperty.all(AppColor.tableHeaderBg),
                    headingRowHeight: 48,
                    dataRowHeight: 60,
                    horizontalMargin: 16,
                    columnSpacing: 28,
                    columns: [
                      DataColumn(
                        label: Text(
                          AppString.hashSymbol,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColor.mainText,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          AppString.customerName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColor.mainText,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          AppString.girviId,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColor.mainText,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          AppString.lockerCode,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColor.mainText,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          AppString.proTyp,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColor.mainText,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          AppString.totalAmt,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColor.mainText,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          AppString.actions,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColor.mainText,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                    rows: List.generate(items.length, (index) {
                      final item = items[index];
                      return DataRow(
                        cells: [
                          // #
                          DataCell(
                            Text(
                              "${index + 1}",
                              style: TextStyle(
                                color: AppColor.subText,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          // Customer Name
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(AppSize.p4),
                                  decoration: BoxDecoration(
                                    color: AppColor.goldColor.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    AppIcon.person,
                                    color: AppColor.goldColor,
                                    size: AppSize.p16,
                                  ),
                                ),
                                SizedBox(width: AppSize.p8),
                                Text(
                                  item.custName ?? AppString.na,
                                  style: TextStyle(
                                    color: AppColor.mainText,
                                    fontWeight: FontWeight.w600,
                                    fontSize: AppSize.size14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Girvi ID
                          DataCell(
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSize.p8,
                                vertical: AppSize.p4 / 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColor.blueTagBg,
                                borderRadius:
                                    BorderRadius.circular(AppSize.p12),
                              ),
                              child: Text(
                                item.uniqueId ?? AppString.na,
                                style: TextStyle(
                                  color: AppColor.blueTagText,
                                  fontWeight: FontWeight.w600,
                                  fontSize: AppSize.size12,
                                ),
                              ),
                            ),
                          ),
                          // Locker Code
                          DataCell(
                            Text(
                              "${item.lockerCode}-${item.code}",
                              style: TextStyle(
                                color: AppColor.mainText,
                                fontWeight: FontWeight.w500,
                                fontSize: AppSize.size14,
                              ),
                            ),
                          ),
                          // Total Prod
                          DataCell(
                            Text(
                              "${item.tatalProd} ${AppString.pcs}",
                              style: TextStyle(
                                color: AppColor.mainText,
                                fontWeight: FontWeight.w500,
                                fontSize: AppSize.size14,
                              ),
                            ),
                          ),
                          // Total Amt
                          DataCell(
                            Text(
                              item.totalAmt ?? AppString.zeroAmount,
                              style: TextStyle(
                                color: AppColor.goldColor,
                                fontWeight: FontWeight.bold,
                                fontSize: AppSize.size14,
                              ),
                            ),
                          ),
                          // Actions
                          DataCell(
                            IconButton(
                              icon: Icon(
                                AppIcon.eyeOutline,
                                color: AppColor.goldColor,
                                size: AppSize.p20,
                              ),
                              onPressed: () {
                                NavDrawerController.toNamed(
                                  '/lockerTransationDetail',
                                  arguments: item,
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTransactionCard(LockerWiseData data) {
    return horizontalPadding(
      child: Container(
        margin: EdgeInsets.only(bottom: AppSize.p16),
        decoration: BoxDecoration(
          color: AppColor.cardBg,
          borderRadius: BorderRadius.circular(AppSize.p12),
          border: Border.all(color: AppColor.border),
          boxShadow: [
            BoxShadow(
              color: AppColor.black.withOpacity(AppColor.isDark ? 0.3 : 0.05),
              blurRadius: AppSize.p10,
              offset: const Offset(0, 4),
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        data.custName ?? AppString.na,
                        style: TextStyle(
                          color: AppColor.goldColor,
                          fontWeight: FontWeight.bold,
                          fontSize: AppSize.size18,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                              data.totalAmt ?? AppString.zeroAmount,
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
            color: AppColor.subText,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: AppSize.p4 / 2),
        Text(
          value,
          style: TextStyle(
            fontSize: AppSize.size14,
            fontWeight: FontWeight.w600,
            color: isCritical ? AppColor.goldColor : AppColor.mainText,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _shimmerLoading() {
    return Shimmer.fromColors(
      baseColor: AppColor.isDark ? AppColor.shimmerBaseDark : AppColor.grey300,
      highlightColor: AppColor.isDark ? AppColor.shimmerHighlightDark : AppColor.white,
      child: ListView.builder(
        itemCount: 6,
        padding: EdgeInsets.all(AppSize.p16),
        itemBuilder: (context, index) {
          return Container(
            height: AppSize.height * 0.15,
            margin: EdgeInsets.only(bottom: AppSize.p16),
            decoration: BoxDecoration(
              color: AppColor.cardBg,
              borderRadius: BorderRadius.circular(AppSize.p12),
            ),
          );
        },
      ),
    );
  }
}
