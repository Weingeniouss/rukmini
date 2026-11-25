// ignore_for_file: file_names, unnecessary_to_list_in_spreads, avoid_returning_null_for_void, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/ui/widget/drawerControllerUI.dart';
import 'package:rukmini/controller/api/controllers/drawer/home/girvi/giriviList_Controller.dart';
import 'package:rukmini/controller/api/controllers/year/year_Controller.dart';
import 'package:rukmini/modal/drawer/home/girvi/girvi_list_model.dart';
import 'package:rukmini/modal/year/year_modal.dart';
import 'package:rukmini/view/utils/app_color.dart';
import 'package:rukmini/view/utils/app_icon.dart';
import 'package:rukmini/view/utils/app_string.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/drawer.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:shimmer/shimmer.dart';

class GiriviList extends StatefulWidget {
  const GiriviList({super.key});

  @override
  State<GiriviList> createState() => _GiriviListState();
}

class _GiriviListState extends State<GiriviList> {
  final giriviListController = Get.put(GiriviListController());
  final yearController = Get.put(YearController());
  final ScrollController _scrollController = ScrollController();

  final RxBool _isGridView = true.obs;
  final RxString _selectedBranch = "All Branches".obs;
  final RxString _selectedStatus = "All Status".obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!giriviListController.isLoadMore.value &&
            giriviListController.hasMoreData.value) {
          callApiGirviList(giriviListController);
        }
      }
    });
  }

  Future<void> fetchData() async {
    if (yearController.yearList.isNotEmpty) {
      final selectedYear =
          yearController.yearList.firstWhereOrNull((y) => y.title == "2024") ??
          yearController.yearList.firstWhereOrNull((y) => y.isCurrent == "1") ??
          yearController.yearList.first;

      giriviListController.selectedYearId.value = selectedYear.yearId ?? '0';
      giriviListController.selectedYearTitle.value =
          selectedYear.title ?? 'All Years';
    }
    await CallApi.callGiriviList(
      search: giriviListController.searchTextController.text,
      yearId: giriviListController.selectedYearId.value,
      filterType: giriviListController.selectedFilterType.value,
      formDate: giriviListController.fromDateController.text,
      toDate: giriviListController.toDateController.text,
    );
    await yearController.getYearList();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<GirviData> getFilteredData(List<GirviData> list) {
    final query =
        giriviListController.searchTextController.text.toLowerCase().trim();
    final status = _selectedStatus.value.toLowerCase();

    return list.where((item) {
      if (query.isNotEmpty) {
        final name = (item.custName ?? '').toLowerCase();
        final uid = (item.uniqueId ?? '').toLowerCase();
        final phone = (item.custPhone ?? '').toLowerCase();
        if (!name.contains(query) &&
            !uid.contains(query) &&
            !phone.contains(query)) {
          return false;
        }
      }

      if (status != "all status" && status != "all") {
        bool isClosed = item.isClosed == "1";
        if (status == "open" && isClosed) return false;
        if (status == "closed" && !isClosed) return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Fullscreen(
      drawer: homeDrawer(),
      isPadding: false,
      backGroundcolor: AppColor.backgroundColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.dashboardGold,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        onPressed: () {
          NavDrawerController.toNamed('/giriviadd');
        },
        child: const Icon(AppIcon.add, color: AppColor.white, size: 28),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: appBar(
          back: true,
          title: AppString.giriviList,
          searchIcon: false,
          filter: false,
        ),
      ),
      child: Obx(() {
        if (giriviListController.isLoading.value &&
            giriviListController.giriviList.isEmpty) {
          return _shimmerLoading();
        }

        final rawList = giriviListController.giriviList;
        final filteredList = getFilteredData(rawList);
        final totalCount =
            giriviListController.giriviListData.value.custCount ??
                rawList.length;

        _isGridView.value;
        _selectedBranch.value;
        _selectedStatus.value;
        giriviListController.selectedYearTitle.value;

        return RefreshIndicator(
          backgroundColor: AppColor.white,
          color: AppColor.dashboardGold,
          elevation: 2.0,
          onRefresh: () => callApiGirviList(giriviListController),
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCards(filteredList, totalCount),
                _buildFilterBar(),
                if (filteredList.isEmpty)
                  Container(
                    height: 200,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColor.grey300),
                    ),
                    child: Text(
                      AppString.noDataFound,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColor.grey500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                else
                  _isGridView.value
                      ? _buildGridView(filteredList)
                      : _buildListView(filteredList),
                if (giriviListController.isLoadMore.value)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColor.dashboardGold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSummaryCards(List<GirviData> list, int totalCount) {
    int openCount = list.where((x) => x.isClosed != "1").length;
    int closedCount = list.where((x) => x.isClosed == "1").length;

    double totalAmtSum = 0.0;
    for (var x in list) {
      if (x.givenAmt != null) {
        final clean = x.givenAmt!.replaceAll(',', '').replaceAll('₹', '').trim();
        totalAmtSum += double.tryParse(clean) ?? 0.0;
      }
    }

    final String formattedTotalAmt = NumberFormat.currency(
      symbol: '₹',
      decimalDigits: 2,
      locale: 'en_IN',
    ).format(totalAmtSum);

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isCompact = constraints.maxWidth < 700;
        if (isCompact) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                _summaryCard(
                  icon: AppIcon.inventoryRounded,
                  iconBg: AppColor.goldTagBg,
                  iconColor: AppColor.dashboardGold,
                  label: "Total Girvi",
                  value: "$totalCount",
                ),
                const SizedBox(width: 12),
                _summaryCard(
                  icon: AppIcon.lockOutline,
                  iconBg: AppColor.greenTagBg,
                  iconColor: AppColor.greenTagText,
                  label: AppString.open,
                  value: "$openCount",
                ),
                const SizedBox(width: 12),
                _summaryCard(
                  icon: AppIcon.lockClock,
                  iconBg: AppColor.redLightBg,
                  iconColor: AppColor.redText,
                  label: AppString.closed,
                  value: "$closedCount",
                ),
                const SizedBox(width: 12),
                _summaryCard(
                  icon: AppIcon.rupee,
                  iconBg: AppColor.orangeLightBg,
                  iconColor: AppColor.orangeText,
                  label: "Total Amount",
                  value: formattedTotalAmt,
                ),
              ],
            ),
          );
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Expanded(
                child: _summaryCard(
                  icon: AppIcon.inventoryRounded,
                  iconBg: AppColor.goldTagBg,
                  iconColor: AppColor.dashboardGold,
                  label: "Total Girvi",
                  value: "$totalCount",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _summaryCard(
                  icon: AppIcon.lockOutline,
                  iconBg: AppColor.greenTagBg,
                  iconColor: AppColor.greenTagText,
                  label: AppString.open,
                  value: "$openCount",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _summaryCard(
                  icon: AppIcon.lockClock,
                  iconBg: AppColor.redLightBg,
                  iconColor: AppColor.redText,
                  label: AppString.closed,
                  value: "$closedCount",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _summaryCard(
                  icon: AppIcon.rupee,
                  iconBg: AppColor.orangeLightBg,
                  iconColor: AppColor.orangeText,
                  label: "Total Amount",
                  value: formattedTotalAmt,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _summaryCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.grey300.withOpacity(0.6)),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColor.grey500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColor.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 650;
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: isCompact ? constraints.maxWidth : 320,
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColor.grey300),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.black.withOpacity(0.02),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: giriviListController.searchTextController,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColor.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: AppString.searchGirviPlaceholder,
                      hintStyle: const TextStyle(
                        color: AppColor.grey500,
                        fontSize: 13,
                      ),
                      prefixIcon: const Icon(
                        AppIcon.searchIcon,
                        color: AppColor.grey500,
                        size: 20,
                      ),
                      suffixIcon: giriviListController
                              .searchTextController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(AppIcon.clearIcon, size: 18),
                              onPressed: () {
                                giriviListController.searchTextController.clear();
                                setState(() {});
                                callApiGirviList(giriviListController);
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {});
                      callApiGirviList(giriviListController);
                    },
                  ),
                ),
              ),

              Builder(
                builder: (btnContext) => _buildFilterPill(
                  icon: AppIcon.calendarOutline,
                  label: giriviListController.selectedYearTitle.value,
                  onTap: () => _showYearMenu(btnContext),
                ),
              ),

              Builder(
                builder: (btnContext) => _buildFilterPill(
                  icon: AppIcon.location,
                  label: _selectedBranch.value,
                  onTap: () => _showBranchMenu(btnContext),
                ),
              ),

              Builder(
                builder: (btnContext) => _buildFilterPill(
                  icon: AppIcon.sellOutline,
                  label: _selectedStatus.value,
                  onTap: () => _showStatusMenu(btnContext),
                ),
              ),

              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColor.grey300),
                ),
                child: IconButton(
                  icon: const Icon(
                    AppIcon.refresh,
                    color: AppColor.dashboardGold,
                    size: 20,
                  ),
                  tooltip: AppString.resetFilters,
                  onPressed: _resetFilters,
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColor.grey300),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () => _isGridView.value = true,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(9),
                        bottomLeft: Radius.circular(9),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _isGridView.value
                              ? AppColor.dashboardGold
                              : AppColor.transparent,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(9),
                            bottomLeft: Radius.circular(9),
                          ),
                        ),
                        child: Icon(
                          AppIcon.gridView,
                          size: 18,
                          color: _isGridView.value
                              ? AppColor.white
                              : AppColor.grey500,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => _isGridView.value = false,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(9),
                        bottomRight: Radius.circular(9),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: !_isGridView.value
                              ? AppColor.dashboardGold
                              : AppColor.transparent,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(9),
                            bottomRight: Radius.circular(9),
                          ),
                        ),
                        child: Icon(
                          AppIcon.listBulleted,
                          size: 18,
                          color: !_isGridView.value
                              ? AppColor.white
                              : AppColor.grey500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterPill({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final bool isSelected = label != "All Years" &&
        label != AppString.allBranches &&
        label != AppString.allStatus &&
        label != "All";
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.dashboardGold.withOpacity(0.08)
              : AppColor.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColor.dashboardGold : AppColor.grey300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppColor.dashboardGold : AppColor.grey500,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColor.dashboardGold : AppColor.black87,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              AppIcon.arrow_down,
              size: 18,
              color: isSelected ? AppColor.dashboardGold : AppColor.grey500,
            ),
          ],
        ),
      ),
    );
  }

  void _showYearMenu(BuildContext btnContext) {
    final RenderBox renderBox = btnContext.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + renderBox.size.height,
        offset.dx + renderBox.size.width,
        0,
      ),
      items: [
        const PopupMenuItem<String>(
          value: '0',
          child: Text("All Years", style: TextStyle(fontSize: 13)),
        ),
        ...yearController.yearList.map((YearData year) {
          return PopupMenuItem<String>(
            value: year.yearId ?? '0',
            child: Text(year.title ?? '', style: const TextStyle(fontSize: 13)),
          );
        }).toList(),
      ],
    ).then((value) {
      if (value != null) {
        changeYear(value);
      }
    });
  }

  void changeYear(String value) {
    giriviListController.selectedYearId.value = value;
    if (value == '0') {
      giriviListController.selectedYearTitle.value = "All Years";
    } else {
      final selected =
          yearController.yearList.firstWhereOrNull((y) => y.yearId == value);
      giriviListController.selectedYearTitle.value =
          selected?.title ?? "All Years";
    }
    callApiGirviList(giriviListController);
  }

  void _showBranchMenu(BuildContext btnContext) {
    final RenderBox renderBox = btnContext.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + renderBox.size.height,
        offset.dx + renderBox.size.width,
        0,
      ),
      items: [
        AppString.allBranches,
        "Pandesara",
        "Gambhir",
        "Panchavati",
      ].map((b) {
        return PopupMenuItem<String>(
          value: b,
          child: Text(b, style: const TextStyle(fontSize: 13)),
        );
      }).toList(),
    ).then((value) {
      if (value != null) {
        _selectedBranch.value = value;
      }
    });
  }

  void _showStatusMenu(BuildContext btnContext) {
    final RenderBox renderBox = btnContext.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + renderBox.size.height,
        offset.dx + renderBox.size.width,
        0,
      ),
      items: [
        AppString.allStatus,
        AppString.open,
        AppString.closed,
        "Carry Forward",
      ].map((s) {
        return PopupMenuItem<String>(
          value: s,
          child: Text(s, style: const TextStyle(fontSize: 13)),
        );
      }).toList(),
    ).then((value) {
      if (value != null) {
        _selectedStatus.value = value;
        giriviListController.selectedFilterType.value =
            value == AppString.allStatus ? "All" : value;
        callApiGirviList(giriviListController);
      }
    });
  }

  void _resetFilters() {
    giriviListController.searchTextController.clear();
    giriviListController.selectedYearId.value = '0';
    giriviListController.selectedYearTitle.value = "All Years";
    _selectedBranch.value = AppString.allBranches;
    _selectedStatus.value = AppString.allStatus;
    giriviListController.selectedFilterType.value = "All";
    giriviListController.fromDateController.clear();
    giriviListController.toDateController.clear();
    setState(() {});
    callApiGirviList(giriviListController);
  }

  Widget _buildGridView(List<GirviData> list) {
    final double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 3;
    if (screenWidth < 750) {
      crossAxisCount = 1;
    } else if (screenWidth < 1100) {
      crossAxisCount = 2;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        mainAxisExtent: 155,
      ),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return _buildGirviCardItem(list[index], isGrid: true);
      },
    );
  }

  Widget _buildListView(List<GirviData> list) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _buildGirviCardItem(list[index], isGrid: false);
      },
    );
  }

  Widget _buildGirviCardItem(GirviData item, {bool isGrid = false}) {
    final bool isClosed = item.isClosed == "1";
    final String formattedDate = _formatDate(item.girviDate);

    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.goldTagBg.withOpacity(0.8)),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          NavDrawerController.toNamed('/giriviDetail', arguments: item.girviId);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: AppColor.goldTagBg,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      AppIcon.person,
                      color: AppColor.dashboardGold,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.custName ?? AppString.noName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColor.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.goldTagBg.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "# ${item.uniqueId ?? '-'}",
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColor.goldTagText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isClosed ? AppColor.redLightBg : AppColor.greenTagBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isClosed ? AppString.closed : AppString.open,
                      style: TextStyle(
                        color:
                            isClosed ? AppColor.redText : AppColor.greenTagText,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const Divider(height: 16, color: AppColor.grey200),

              Row(
                children: [
                  const Icon(
                    AppIcon.calendarOutline,
                    size: 14,
                    color: AppColor.dashboardGold,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColor.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Icon(
                    AppIcon.location,
                    size: 14,
                    color: AppColor.dashboardGold,
                  ),
                  const SizedBox(width: 4),
                  const Expanded(
                    child: Text(
                      "Pandesara",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColor.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 4),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        AppIcon.rupee,
                        color: AppColor.dashboardGold,
                        size: 14,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        item.givenAmt ?? '0.00',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: AppColor.dashboardGold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${item.interest ?? '0.00'}%)',
                        style: const TextStyle(
                          color: AppColor.textMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      const Icon(
                        AppIcon.phone,
                        color: AppColor.dashboardGold,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.custPhone ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColor.black87,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColor.goldTagBg.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          AppIcon.chevronRight,
                          size: 14,
                          color: AppColor.dashboardGold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return AppString.na;
    try {
      DateTime date = DateTime.parse(dateStr);
      return DateFormat('dd MMMM yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  Widget _shimmerLoading() {
    return ListView.builder(
      itemCount: 6,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColor.grey300,
          highlightColor: AppColor.white,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            height: 155,
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      },
    );
  }
}

Future<void> callApiGirviList(
    GiriviListController giriviListController) async {
  CallApi.callGiriviList(
    isRefresh: true,
    search: giriviListController.searchTextController.text,
    yearId: giriviListController.selectedYearId.value,
    filterType: giriviListController.selectedFilterType.value,
    formDate: giriviListController.fromDateController.text,
    toDate: giriviListController.toDateController.text,
  );
  return null;
}
