import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/drawer/home/pendingTransaction/pending_transaction_controller.dart';
import 'package:rukmini/view/utils/app_Color.dart';
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
          return const Center(child: Text("No Data Found"));
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
                const Divider(height: 1, color: Colors.grey),
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
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          _buildLegendItem(
            const Color(0xFFFFD700),
            "Due date over",
            onTap: () {
              pendingTransactionController.currentFilter.value = '1';
              CallApi.callPendingTransaction(
                isRefresh: true,
                isFilterer: pendingTransactionController.currentFilter.value,
              );
            },
          ),
          const SizedBox(width: 16),
          _buildLegendItem(
            const Color(0xFFFF8C00),
            "One year up",
            onTap: () {
              pendingTransactionController.currentFilter.value = '2';
              CallApi.callPendingTransaction(
                isRefresh: true,
                isFilterer: pendingTransactionController.currentFilter.value,
              );
            },
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              pendingTransactionController.currentFilter.value = null;
              pendingTransactionController.searchTextController.clear();
              CallApi.callPendingTransaction(
                isRefresh: true,
                isFilterer: pendingTransactionController.currentFilter.value,
              );
            },
            child: const Text(
              "Clear",
              style: TextStyle(
                color: Color(0xFF2E7D32),
                fontWeight: FontWeight.w500,
                fontSize: 14,
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
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(var data) {
    // Indicator color based on the selected filter or default
    Color indicatorColor = const Color(0xFFFF8C00); // Default Orange
    if (pendingTransactionController.currentFilter.value == '1') {
      indicatorColor = const Color(0xFFFFD700); // Yellow for Due date over
    } else if (pendingTransactionController.currentFilter.value == '2') {
      indicatorColor = const Color(0xFFFF8C00); // Orange for One year up
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF2E1),
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
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              ),
              Text(
                data.uniqueId ?? "",
                style: const TextStyle(
                  color: Color(0xFF4CAF50),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailItem("Gvn Dt", data.girviDate ?? "01 JAN 1970"),
              _buildDetailItem("Due Dt", data.dueDate ?? "22 JUL 2026"),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailItem("Tot Amt Gvn", data.givenAmt ?? "0.00"),
              _buildDetailItem("Balance", data.balance?.toString() ?? "0"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 13,
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
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 8,
        itemBuilder: (context, index) {
          return Container(
            height: 100,
            margin: const EdgeInsets.symmetric(vertical: 2),
            color: Colors.white,
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
      decoration: const InputDecoration(
        hintText: 'Search Name...',
        hintStyle: TextStyle(color: Colors.white70),
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
      decoration: const InputDecoration(
        hintText: 'Search Locality...',
        hintStyle: TextStyle(color: Colors.white70),
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
