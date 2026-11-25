// ignore_for_file: file_names, unnecessary_non_null_assertion, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/drawer/all_master/locker_master/lockerList_Controller.dart';
import 'package:rukmini/controller/api/controllers/drawer/all_master/locker_master/lockerRemove_Controller.dart';
import 'package:rukmini/modal/drawer/allMaster/locker_master/locker_master_modal.dart';
import 'package:rukmini/view/utils/app_color.dart';
import 'package:rukmini/view/utils/app_icon.dart';
import 'package:rukmini/view/utils/app_string.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
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

  final TextEditingController _searchController = TextEditingController();
  final RxString _selectedLockerFilter = AppString.allLockers.obs;
  final RxString _selectedStatusFilter = AppString.allStatus.obs;
  final RxSet<String> _selectedIds = <String>{}.obs;
  final RxBool _selectAll = false.obs;
  final RxInt _rowsPerPage = 10.obs;
  final RxInt _currentPage = 1.obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CallApi.callLockerList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<LockerData> getFilteredList(List<LockerData> list) {
    final query = _searchController.text.toLowerCase().trim();
    final lockerFilter = _selectedLockerFilter.value.toLowerCase();
    final statusFilter = _selectedStatusFilter.value.toLowerCase();

    return list.where((item) {
      final code = (item.lockerCode ?? '').toLowerCase();
      final comName = (item.comName ?? '').toLowerCase();
      final personName = (item.personName ?? '').toLowerCase();
      final phone = (item.personPhone ?? '').toLowerCase();

      if (query.isNotEmpty) {
        if (!code.contains(query) &&
            !comName.contains(query) &&
            !personName.contains(query) &&
            !phone.contains(query)) {
          return false;
        }
      }

      if (lockerFilter != "all lockers" && lockerFilter != "all") {
        if (!code.contains(lockerFilter)) {
          return false;
        }
      }

      if (statusFilter == "active") {
        // Active
      } else if (statusFilter == "inactive") {
        return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Fullscreen(
      isPadding: false,
      backGroundcolor: AppColor.backgroundColor,
      appBar: appBar(
        back: true,
        centerTitle: true,
        title: _buildHeaderTitle(),
      ),
      child: Obx(() {
        final bool isLoading = lockerController.isLoading.value;
        final rawList = lockerController.lockerList.toList();
        final filteredList = getFilteredList(rawList);

        _selectedLockerFilter.value;
        _selectedStatusFilter.value;
        _selectedIds.length;
        _selectAll.value;
        _rowsPerPage.value;
        _currentPage.value;

        if (isLoading && rawList.isEmpty) {
          return _shimmerLoading();
        }

        final totalCount = filteredList.length;
        final perPage = _rowsPerPage.value;
        int pageIndex = _currentPage.value;

        int startIndex = (pageIndex - 1) * perPage;
        if (startIndex >= totalCount && totalCount > 0) {
          startIndex = (totalCount - 1) ~/ perPage * perPage;
        }
        final endIndex = (startIndex + perPage).clamp(0, totalCount);
        final pagedList = filteredList.sublist(startIndex, endIndex);

        final startNum = totalCount == 0 ? 0 : startIndex + 1;
        final endNum = endIndex;

        return RefreshIndicator(
          onRefresh: () => CallApi.callLockerList(),
          color: AppColor.dashboardGold,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    child: const Text(
                      AppString.noLockersAvailable,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColor.grey500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                else
                  _buildTableView(pagedList, startIndex: startIndex),
                const SizedBox(height: 12),
                _buildPaginationBar(startNum, endNum, totalCount),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeaderTitle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          AppIcon.locker,
          color: AppColor.dashboardGold,
          size: 22,
        ),
        const SizedBox(width: 8),
        Text(
          AppString.lockerCodeMaster,
          style: const TextStyle(
            color: AppColor.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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
                width: isCompact ? constraints.maxWidth : 300,
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColor.grey300),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColor.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: AppString.searchLockerPlaceholder,
                      hintStyle: const TextStyle(
                        color: AppColor.grey500,
                        fontSize: 13,
                      ),
                      prefixIcon: const Icon(
                        AppIcon.searchIcon,
                        color: AppColor.grey500,
                        size: 20,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(AppIcon.clearIcon, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
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
                    },
                  ),
                ),
              ),

              Builder(
                builder: (btnContext) => _buildFilterPill(
                  icon: AppIcon.locker,
                  label: _selectedLockerFilter.value,
                  onTap: () => _showLockerMenu(btnContext),
                ),
              ),

              Builder(
                builder: (btnContext) => _buildFilterPill(
                  icon: AppIcon.trend,
                  label: _selectedStatusFilter.value,
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

              OutlinedButton.icon(
                onPressed: () {
                  Get.snackbar(
                    AppString.export,
                    "Exporting Locker Code Master list...",
                    backgroundColor: AppColor.white,
                    colorText: AppColor.black,
                    borderColor: AppColor.dashboardGold,
                    borderWidth: 1,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                icon: const Icon(
                  AppIcon.fileDownload,
                  size: 16,
                  color: AppColor.black87,
                ),
                label: const Text(
                  AppString.export,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColor.black87,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColor.white,
                  side: const BorderSide(color: AppColor.grey300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 11,
                  ),
                ),
              ),

              ElevatedButton.icon(
                onPressed: () => Get.toNamed('/addLockerCode'),
                icon: const Icon(AppIcon.add, size: 16, color: AppColor.white),
                label: const Text(
                  AppString.addLockerCode,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColor.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.dashboardGold,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 11,
                  ),
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
    final bool isSelected =
        label != AppString.allLockers && label != AppString.allStatus;
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

  void _showLockerMenu(BuildContext btnContext) {
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
        AppString.allLockers,
        "M",
        "D",
        "N"
      ].map((l) {
        return PopupMenuItem<String>(
          value: l,
          child: Text(l, style: const TextStyle(fontSize: 13)),
        );
      }).toList(),
    ).then((value) {
      if (value != null) {
        _selectedLockerFilter.value = value;
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
      items: [AppString.allStatus, "Active", "Inactive"].map((s) {
        return PopupMenuItem<String>(
          value: s,
          child: Text(s, style: const TextStyle(fontSize: 13)),
        );
      }).toList(),
    ).then((value) {
      if (value != null) {
        _selectedStatusFilter.value = value;
      }
    });
  }

  void _resetFilters() {
    _searchController.clear();
    _selectedLockerFilter.value = AppString.allLockers;
    _selectedStatusFilter.value = AppString.allStatus;
    setState(() {});
  }

  Widget _buildTableView(List<LockerData> list, {int startIndex = 0}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.grey300),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(AppColor.dashboardGold),
            headingTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColor.white,
              fontSize: 13,
            ),
            dataRowMinHeight: 52,
            dataRowMaxHeight: 52,
            horizontalMargin: 16,
            columnSpacing: 28,
            columns: [
              DataColumn(
                label: Checkbox(
                  value: _selectAll.value,
                  activeColor: AppColor.white,
                  checkColor: AppColor.dashboardGold,
                  side: const BorderSide(color: AppColor.white, width: 1.5),
                  onChanged: (val) {
                    _selectAll.value = val ?? false;
                    if (_selectAll.value) {
                      _selectedIds.addAll(
                        list.map((e) => e.lockerId ?? ''),
                      );
                    } else {
                      _selectedIds.clear();
                    }
                  },
                ),
              ),
              const DataColumn(label: Text("#")),
              const DataColumn(label: Text("Locker Code")),
              const DataColumn(label: Text("Company")),
              const DataColumn(label: Text("Contact Person")),
              DataColumn(label: _sortHeader("Interest Rate")),
              DataColumn(label: _sortHeader("Status")),
              const DataColumn(label: Text("Actions")),
            ],
            rows: List.generate(list.length, (index) {
              final item = list[index];
              final id = item.lockerId ?? '';
              final isChecked = _selectedIds.contains(id);

              return DataRow(
                selected: isChecked,
                cells: [
                  DataCell(
                    Checkbox(
                      value: isChecked,
                      activeColor: AppColor.dashboardGold,
                      onChanged: (val) {
                        if (val == true) {
                          _selectedIds.add(id);
                        } else {
                          _selectedIds.remove(id);
                          _selectAll.value = false;
                        }
                      },
                    ),
                  ),
                  DataCell(
                    Text(
                      "${startIndex + index + 1}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: AppColor.black87,
                      ),
                    ),
                  ),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          AppIcon.locker,
                          color: AppColor.dashboardGold,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          item.lockerCode ?? "-",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: AppColor.black87,
                          ),
                        ),
                        if (item.isDefault == "1") ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColor.goldTagBg,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              AppString.defaultLabel,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColor.goldTagText,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  DataCell(
                    Text(
                      item.comName ?? "-",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColor.textSecondary,
                      ),
                    ),
                  ),
                  DataCell(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.personName ?? "-",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColor.black87,
                          ),
                        ),
                        if (item.personPhone != null &&
                            item.personPhone!.isNotEmpty)
                          Text(
                            item.personPhone!,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColor.textMuted,
                            ),
                          ),
                      ],
                    ),
                  ),
                  DataCell(
                    Text(
                      "${item.interestRate ?? '0.00'} %",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColor.black87,
                      ),
                    ),
                  ),
                  DataCell(_buildStatusBadge("Active")),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            AppIcon.eyeOutline,
                            color: AppColor.black87,
                            size: 18,
                          ),
                          tooltip: AppString.view,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => Get.toNamed(
                            '/addLockerCode',
                            arguments: item,
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(
                            AppIcon.editOutline,
                            color: AppColor.black87,
                            size: 18,
                          ),
                          tooltip: AppString.edit,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => Get.toNamed(
                            '/addLockerCode',
                            arguments: item,
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(
                            AppIcon.deleteIcon,
                            color: AppColor.deleteColor,
                            size: 18,
                          ),
                          tooltip: AppString.delete,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => _showDeleteDialog(item),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _sortHeader(String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label),
        const SizedBox(width: 4),
        const Icon(
          AppIcon.unfoldMore,
          size: 14,
          color: AppColor.white,
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String statusStr) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColor.greenTagBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            AppIcon.checkCircle,
            size: 12,
            color: AppColor.greenTagText,
          ),
          SizedBox(width: 4),
          Text(
            "Active",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColor.greenTagText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationBar(int startNum, int endNum, int totalCount) {
    if (totalCount <= 0) return const SizedBox.shrink();

    final perPage = _rowsPerPage.value;
    final totalPages = (totalCount / perPage).ceil().clamp(1, 9999);
    final currentPage = _currentPage.value.clamp(1, totalPages);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Showing $startNum – $endNum of $totalCount records",
          style: const TextStyle(
            fontSize: 13,
            color: AppColor.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: currentPage > 1 ? () => _currentPage.value = 1 : null,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColor.grey300),
                    ),
                    child: Icon(
                      AppIcon.chevronLeft,
                      size: 16,
                      color: currentPage > 1
                          ? AppColor.black87
                          : AppColor.grey400,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                InkWell(
                  onTap: currentPage > 1
                      ? () => _currentPage.value = currentPage - 1
                      : null,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColor.grey300),
                    ),
                    child: Icon(
                      AppIcon.chevronLeft,
                      size: 16,
                      color: currentPage > 1
                          ? AppColor.black87
                          : AppColor.grey400,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColor.dashboardGold,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "$currentPage",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColor.white,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                InkWell(
                  onTap: currentPage < totalPages
                      ? () => _currentPage.value = currentPage + 1
                      : null,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColor.grey300),
                    ),
                    child: Icon(
                      AppIcon.chevronRight,
                      size: 16,
                      color: currentPage < totalPages
                          ? AppColor.black87
                          : AppColor.grey400,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                InkWell(
                  onTap: currentPage < totalPages
                      ? () => _currentPage.value = totalPages
                      : null,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColor.grey300),
                    ),
                    child: Icon(
                      AppIcon.chevronRight,
                      size: 16,
                      color: currentPage < totalPages
                          ? AppColor.black87
                          : AppColor.grey400,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 14),
            PopupMenuButton<int>(
              onSelected: (count) {
                _rowsPerPage.value = count;
                _currentPage.value = 1;
              },
              itemBuilder: (context) => [10, 25, 50, 100]
                  .map(
                    (count) => PopupMenuItem<int>(
                      value: count,
                      child: Text(
                        "$count / page",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  )
                  .toList(),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColor.grey300),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${_rowsPerPage.value} / page",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColor.black87,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      AppIcon.arrow_down,
                      size: 16,
                      color: AppColor.grey500,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
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

  Widget _shimmerLoading() {
    return Shimmer.fromColors(
      baseColor: AppColor.grey300,
      highlightColor: AppColor.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: List.generate(
            6,
            (index) => Container(
              height: 52,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
