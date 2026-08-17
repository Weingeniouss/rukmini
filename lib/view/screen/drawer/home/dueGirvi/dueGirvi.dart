// ignore_for_file: file_names, strict_top_level_inference, unnecessary_non_null_assertion, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/drawer/home/pendingTransaction/pending_transaction_controller.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/drawer.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:shimmer/shimmer.dart';

class DueGirvi extends StatefulWidget {
  const DueGirvi({super.key});

  @override
  State<DueGirvi> createState() => _DueGirviState();
}

class _DueGirviState extends State<DueGirvi> {
  final pendingTransactionController = Get.put(PendingTransactionController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (Get.currentRoute.contains('/dueOverGirvi')) {
      pendingTransactionController.currentFilter.value = '2';
    } else {
      pendingTransactionController.currentFilter.value = '1';
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      CallApi.callPendingTransaction(
        isRefresh: true,
        isFilterer: pendingTransactionController.currentFilter.value,
      );
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!pendingTransactionController.isLoadMore.value &&
            pendingTransactionController.hasMoreData.value) {
          CallApi.callPendingTransaction(
            isLoadMoreAction: true,
            isFilterer: pendingTransactionController.currentFilter.value,
            search: pendingTransactionController.searchTextController.text,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Fullscreen(
        drawer: homeDrawer(),
        isPadding: false,
        appBar: appBar(
          title: pendingTransactionController.isSearching.value
              ? _buildNameSearchField()
              : pendingTransactionController.isLocalitySearching.value
              ? _buildLocalitySearchField()
              : AppString.pendingTransaction,
          searchIcon: !pendingTransactionController.isLocalitySearching.value,
          // filter: !pendingTransactionController.isSearching.value,
          // filterOnPressed: () {
          //   pendingTransactionController.isLocalitySearching.value =
          //       !pendingTransactionController.isLocalitySearching.value;
          //   if (!pendingTransactionController.isLocalitySearching.value) {
          //     pendingTransactionController.localityTextController.clear();
          //     CallApi.callPendingTransaction(
          //       isRefresh: true,
          //       isFilterer: pendingTransactionController.currentFilter.value,
          //     );
          //   }
          // },
          searchOnPressed: () {
            pendingTransactionController.isSearching.value =
                !pendingTransactionController.isSearching.value;
            if (!pendingTransactionController.isSearching.value) {
              pendingTransactionController.searchTextController.clear();
              CallApi.callPendingTransaction(
                isRefresh: true,
                isFilterer: pendingTransactionController.currentFilter.value,
              );
            }
          },
        ),
        child: Column(
          children: [_buildLegendBar(), listOfPendingTransaction()],
        ),
      );
    });
  }

  Widget listOfPendingTransaction() {
    return Expanded(
      child: Obx(() {
        if (pendingTransactionController.isLoading.value &&
            pendingTransactionController.pendingTransactionList.isEmpty) {
          return _buildShimmerLoading();
        }
        if (pendingTransactionController.pendingTransactionList.isEmpty) {
          return const Center(child: Text(AppString.noDataFound));
        }
        return RefreshIndicator(
          onRefresh: () => CallApi.callPendingTransaction(
            isRefresh: true,
            isFilterer: pendingTransactionController.currentFilter.value,
            search: pendingTransactionController.searchTextController.text,
          ),
          child: ListView.separated(
            controller: _scrollController,
            itemCount:
                pendingTransactionController.pendingTransactionList.length +
                (pendingTransactionController.isLoadMore.value ? 1 : 0),
            separatorBuilder: (context, index) =>
                const Divider(height: 1, color: AppColor.boderSideColor),
            itemBuilder: (context, index) {
              if (index <
                  pendingTransactionController.pendingTransactionList.length) {
                return _buildCard(
                  pendingTransactionController.pendingTransactionList[index],
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          ),
        );
      }),
    );
  }

  Widget _buildLegendBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColor.fullScreenColor,
        border: Border(
          bottom: BorderSide(color: AppColor.boderSideColor.shade300),
        ),
      ),
      child: Row(
        children: [
          _buildLegendItem(
            AppColor.yellow,
            AppString.duedateover,
            onTap: () {
              pendingTransactionController.currentFilter.value = '1';
              CallApi.callPendingTransaction(
                isRefresh: true,
                isFilterer: pendingTransactionController.currentFilter.value,
              );
            },
          ),
           SizedBox(width: Get.width * 0.05),
          _buildLegendItem(
            AppColor.orange,
            AppString.oneyearup,
            onTap: () {
              pendingTransactionController.currentFilter.value = '2';
              CallApi.callPendingTransaction(
                isRefresh: true,
                isFilterer: pendingTransactionController.currentFilter.value,
              );
            },
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              pendingTransactionController.currentFilter.value = null;
              pendingTransactionController.searchTextController.clear();
              CallApi.callPendingTransaction(
                isRefresh: true,
                isFilterer: pendingTransactionController.currentFilter.value,
              );
            },
            child: Text(
              AppString.clear,
              style: TextStyle(
                color: AppColor.activeColor,
                fontWeight: FontWeight.w500,
                fontSize: AppSize.size12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: AppSize.size14,
            height: AppSize.size14,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: AppSize.size14,
              color: AppColor.dark.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(var data) {
    Color indicatorColor = AppColor.orange;
    if (pendingTransactionController.currentFilter.value == '1') {
      indicatorColor = AppColor.yellow;
    } else if (pendingTransactionController.currentFilter.value == '2') {
      indicatorColor = AppColor.oneYearup;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.whiteOrang,
        border: Border(left: BorderSide(color: indicatorColor, width: 5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  data.custName ?? "null",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: AppSize.p16 * 1.025, // 0.041
                    color: AppColor.dark.withOpacity(0.8),
                  ),
                ),
              ),
              Text(
                data.uniqueId ?? "",
                style: TextStyle(
                  color: AppColor.activeColor,
                  fontWeight: FontWeight.bold,
                  fontSize: AppSize.size15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailItem(
                AppString.gvnDt,
                data.girviDate ?? "01 JAN 1970",
              ),
              _buildDetailItem(AppString.dueDt, data.dueDate ?? "22 JUL 2026"),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailItem(AppString.totAmtGvn, data.givenAmt ?? "0.00"),
              _buildDetailItem(
                AppString.balance,
                data.balance?.toString() ?? "0",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: AppColor.dark,
          fontSize: AppSize.size14,
          fontFamily: 'Poppins',
        ),
        children: [
          TextSpan(
            text: "$label : ",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: AppColor.baseColor!,
      highlightColor: AppColor.highlightColor!,
      child: ListView.builder(
        itemCount: 8,
        itemBuilder: (context, index) {
          return Container(
            height: 100,
            margin: const EdgeInsets.symmetric(vertical: 2),
            color: AppColor.fullScreenColor,
          );
        },
      ),
    );
  }

  Widget _buildNameSearchField() {
    return TextField(
      controller: pendingTransactionController.searchTextController,
      autofocus: true,
      style: const TextStyle(color: AppColor.fullScreenColor),
      cursorColor: AppColor.fullScreenColor,
      decoration: InputDecoration(
        hintText: AppString.searchName,
        hintStyle: const TextStyle(color: AppColor.otherWhite),
        border: InputBorder.none,
      ),
      onChanged: (value) {
        CallApi.callPendingTransaction(
          isRefresh: true,
          search: value,
          isFilterer: pendingTransactionController.currentFilter.value,
          locality: pendingTransactionController.localityTextController.text,
        );
      },
    );
  }

  Widget _buildLocalitySearchField() {
    return TextField(
      controller: pendingTransactionController.localityTextController,
      autofocus: true,
      style: const TextStyle(color: AppColor.fullScreenColor),
      cursorColor: AppColor.fullScreenColor,
      decoration: InputDecoration(
        hintText: AppString.searchLocality,
        hintStyle: const TextStyle(color: AppColor.otherWhite),
        border: InputBorder.none,
      ),
      onChanged: (value) {
        CallApi.callPendingTransaction(
          isRefresh: true,
          locality: value,
          isFilterer: pendingTransactionController.currentFilter.value,
          search: pendingTransactionController.searchTextController.text,
        );
      },
    );
  }
}
