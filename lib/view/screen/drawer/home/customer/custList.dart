// ignore_for_file: deprecated_member_use, strict_top_level_inference, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/ui/widget/drawerControllerUI.dart';
import 'package:rukmini/controller/api/controllers/drawer/home/customers/custList_Controller.dart';
import 'package:rukmini/modal/drawer/home/customer/customer_list_model.dart';
import 'package:rukmini/view/utils/app_color.dart';
import 'package:rukmini/view/utils/app_icon.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/app_string.dart';
import 'package:rukmini/view/utils/app_url.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/drawer.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:shimmer/shimmer.dart';

class Custlist extends StatefulWidget {
  const Custlist({super.key});

  @override
  State<Custlist> createState() => _CustlistState();
}

class _CustlistState extends State<Custlist> {
  final custListController = Get.put(CustListController());
  final ScrollController _scrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  final RxBool _isGridView = false.obs;
  final RxString _selectedType = "All Type".obs;
  final RxString _selectedStatus = "All Status".obs;
  final RxString _selectedDateRange = "Date Range".obs;
  final RxSet<String> _selectedCustIds = <String>{}.obs;
  final RxBool _selectAll = false.obs;
  final RxInt _rowsPerPage = 10.obs;
  final RxInt _currentPageIndex = 1.obs;
  bool _isFetchingPage = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CallApi.callCustList(isRefresh: true);
    });

    _scrollController.addListener(() {
      if (_scrollController.hasClients &&
          _scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) {
        if (!custListController.isMoreLoading.value &&
            custListController.hasMoreData.value) {
          CallApi.callCustList(search: _searchController.text);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _horizontalScrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _goToPage(int pageNum) async {
    if (_isFetchingPage) return;
    _currentPageIndex.value = pageNum;
    final perPage = _rowsPerPage.value;
    final neededCount = pageNum * perPage;

    _isFetchingPage = true;
    try {
      while (custListController.customers.length < neededCount &&
          custListController.hasMoreData.value) {
        final beforeCount = custListController.customers.length;
        await CallApi.callCustList(search: _searchController.text);
        final afterCount = custListController.customers.length;
        if (afterCount == beforeCount) {
          break;
        }
      }
    } finally {
      _isFetchingPage = false;
    }
    setState(() {});
  }

  List<String> getAvailableTypes() {
    final Set<String> types = {"All Type"};
    for (var c in custListController.customers) {
      if (c.custType != null) {
        for (var t in c.custType!) {
          if (t.typeName != null && t.typeName!.isNotEmpty) {
            types.add(t.typeName!);
          }
        }
      }
    }
    return types.toList();
  }

  List<CustomerData> getFilteredCustomers(List<CustomerData> list) {
    final String typeFilter = _selectedType.value;
    final String statusFilter = _selectedStatus.value;
    final String searchVal = _searchController.text.trim().toLowerCase();

    return list.where((customer) {
      if (searchVal.isNotEmpty) {
        final name = (customer.name ?? "").toLowerCase();
        final code = (customer.custCode ?? "").toLowerCase();
        final address = (customer.address ?? "").toLowerCase();
        final phone =
            (customer.phoneList != null && customer.phoneList!.isNotEmpty)
            ? (customer.phoneList![0].phone ?? "").toLowerCase()
            : "";
        if (!name.contains(searchVal) &&
            !code.contains(searchVal) &&
            !address.contains(searchVal) &&
            !phone.contains(searchVal)) {
          return false;
        }
      }

      if (typeFilter != "All Type") {
        final types =
            customer.custType
                ?.map((t) => (t.typeName ?? "").toLowerCase())
                .toList() ??
            [];
        if (!types.contains(typeFilter.toLowerCase())) {
          return false;
        }
      }

      if (statusFilter != "All Status") {
        final status = (customer.status ?? "").toLowerCase();
        final filter = statusFilter.toLowerCase();
        if (filter == "active" &&
            (status == "inactive" || status == "0" || status == "false")) {
          return false;
        }
        if (filter == "pending" && !status.contains("pending")) {
          return false;
        }
        if (filter == "inactive" && status != "inactive" && status != "0") {
          return false;
        }
      }

      return true;
    }).toList();
  }

  void _resetFilters() {
    _searchController.clear();
    custListController.searchQuery.value = "";
    _selectedType.value = "All Type";
    _selectedStatus.value = "All Status";
    _selectedDateRange.value = "Date Range";
    _goToPage(1);
  }

  void _showTypeMenu(BuildContext context) {
    final types = getAvailableTypes();
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<String>(
      context: context,
      position: position,
      items: types
          .map(
            (t) => PopupMenuItem<String>(
              value: t,
              child: Text(t, style: const TextStyle(fontSize: 13)),
            ),
          )
          .toList(),
    ).then((val) {
      if (val != null) {
        _selectedType.value = val;
        _goToPage(1);
      }
    });
  }

  void _showStatusMenu(BuildContext context) {
    final statuses = ["All Status", "Active", "Pending", "Inactive"];
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<String>(
      context: context,
      position: position,
      items: statuses
          .map(
            (s) => PopupMenuItem<String>(
              value: s,
              child: Text(s, style: const TextStyle(fontSize: 13)),
            ),
          )
          .toList(),
    ).then((val) {
      if (val != null) {
        _selectedStatus.value = val;
        _goToPage(1);
      }
    });
  }

  void _showDateRangeMenu(BuildContext context) {
    final ranges = [
      "Date Range",
      "Today",
      "This Week",
      "This Month",
      "This Year",
    ];
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<String>(
      context: context,
      position: position,
      items: ranges
          .map(
            (r) => PopupMenuItem<String>(
              value: r,
              child: Text(r, style: const TextStyle(fontSize: 13)),
            ),
          )
          .toList(),
    ).then((val) {
      if (val != null) {
        _selectedDateRange.value = val;
        _goToPage(1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Fullscreen(
      isPadding: false,
      drawer: homeDrawer(),
      backGroundcolor: AppColor.backgroundColor,
      appBar: appBar(
        back: true,
        title: AppString.customer,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.dashboardGold,
        onPressed: () => NavDrawerController.toNamed('/addCustForm'),
        elevation: 5,
        shape: const CircleBorder(),
        child: Icon(
          AppIcon.add,
          color: AppColor.white,
          size: AppSize.p24 + AppSize.p8,
        ),
      ),
      child: Obx(() {
        final bool loading = custListController.isLoading.value;
        final bool isMoreLoading = custListController.isMoreLoading.value;
        final List<CustomerData> list = custListController.customers.toList();

        // Subscribe Obx to reactive states
        _isGridView.value;
        _selectedDateRange.value;
        _selectedCustIds.length;
        _selectAll.value;
        _rowsPerPage.value;
        _currentPageIndex.value;

        if (loading && list.isEmpty) {
          return customerLoading();
        }

        final filteredList = getFilteredCustomers(list);
        final totalCount =
            custListController.customerListData.value.custCount ?? list.length;

        final perPage = _rowsPerPage.value;
        int pageIndex = _currentPageIndex.value;
        int totalItems = filteredList.length;

        int startIndex = (pageIndex - 1) * perPage;
        if (startIndex >= totalItems && totalItems > 0) {
          startIndex = (totalItems - 1) ~/ perPage * perPage;
        }
        final endIndex = (startIndex + perPage).clamp(0, totalItems);
        final pagedList = filteredList.sublist(startIndex, endIndex);

        final startNum = totalItems == 0 ? 0 : startIndex + 1;
        final endNum = endIndex;

        return RefreshIndicator(
          key: const ValueKey('custListRefreshIndicator'),
          onRefresh: () => CallApi.callCustList(
            isRefresh: true,
            search: _searchController.text,
          ),
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFilterBar(),
                _buildSubHeader(startNum, endNum, totalCount),
                const SizedBox(height: 12),
                if (!loading && filteredList.isEmpty)
                  Container(
                    height: 200,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColor.grey300),
                    ),
                    child: Text(
                      AppString.noCustomersFound,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColor.grey500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                else
                  _isGridView.value
                      ? _buildGridView(pagedList)
                      : _buildTableView(pagedList, startIndex: startIndex),
                if (isMoreLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColor.dashboardGold,
                      ),
                    ),
                  ),
                _buildPaginationBar(totalCount),
              ],
            ),
          ),
        ),
      );
    }),
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
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.black.withOpacity(0.02),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColor.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: AppString.searchCustomerPlaceholder,
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
                                custListController.searchQuery.value = "";
                                _goToPage(1);
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
                      custListController.searchQuery.value = value;
                      _goToPage(1);
                      CallApi.callCustList(isRefresh: true, search: value);
                    },
                  ),
                ),
              ),

              Builder(
                builder: (btnContext) => _buildFilterPill(
                  icon: AppIcon.layers,
                  label: _selectedType.value,
                  onTap: () => _showTypeMenu(btnContext),
                ),
              ),

              Builder(
                builder: (btnContext) => _buildFilterPill(
                  icon: AppIcon.sellOutline,
                  label: _selectedStatus.value,
                  onTap: () => _showStatusMenu(btnContext),
                ),
              ),

              Builder(
                builder: (btnContext) => _buildFilterPill(
                  icon: AppIcon.calendarOutline,
                  label: _selectedDateRange.value,
                  onTap: () => _showDateRangeMenu(btnContext),
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
                    AppIcon.tune,
                    color: AppColor.dashboardGold,
                    size: 20,
                  ),
                  tooltip: AppString.resetFilters,
                  onPressed: _resetFilters,
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
        label != AppString.allType && label != AppString.allStatus && label != AppString.dateRange;
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

  Widget _buildSubHeader(int startNum, int endNum, int totalCount) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 12,
      children: [
        Text(
          "Showing $startNum – $endNum of $totalCount customers",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColor.black54,
          ),
        ),

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColor.grey300),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => _isGridView.value = false,
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
                        color: !_isGridView.value
                            ? AppColor.dashboardGold
                            : AppColor.transparent,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(9),
                          bottomLeft: Radius.circular(9),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            AppIcon.listBulleted,
                            size: 16,
                            color: !_isGridView.value
                                ? AppColor.white
                                : AppColor.grey500,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            AppString.list,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: !_isGridView.value
                                  ? AppColor.white
                                  : AppColor.grey500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => _isGridView.value = true,
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
                        color: _isGridView.value
                            ? AppColor.dashboardGold
                            : AppColor.transparent,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(9),
                          bottomRight: Radius.circular(9),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            AppIcon.gridView,
                            size: 16,
                            color: _isGridView.value
                                ? AppColor.white
                                : AppColor.grey500,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            AppString.grid,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _isGridView.value
                                  ? AppColor.white
                                  : AppColor.grey500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            OutlinedButton.icon(
              onPressed: () {
                Get.snackbar(
                  AppString.export,
                  AppString.exportingContacts,
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
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
            ),
            const SizedBox(width: 10),

            ElevatedButton.icon(
              onPressed: () => NavDrawerController.toNamed('/addCustForm'),
              icon: const Icon(AppIcon.add, size: 16, color: AppColor.white),
              label: const Text(
                AppString.addCustomer,
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
                  horizontal: 14,
                  vertical: 10,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTableView(List<CustomerData> list, {int startIndex = 0}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.grey300),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Scrollbar(
            controller: _horizontalScrollController,
            thumbVisibility: true,
            scrollbarOrientation: ScrollbarOrientation.bottom,
            child: SingleChildScrollView(
              controller: _horizontalScrollController,
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                ),
                child: DataTable(
            headingRowColor: WidgetStateProperty.all(AppColor.tableHeaderBg),
            headingRowHeight: 48,
            dataRowMinHeight: 56,
            dataRowMaxHeight: 64,
            horizontalMargin: 16,
            columnSpacing: 18,
            showCheckboxColumn: false,
            columns: [
              DataColumn(
                label: Checkbox(
                  value: _selectAll.value,
                  activeColor: AppColor.dashboardGold,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  onChanged: (val) {
                    _selectAll.value = val ?? false;
                    if (_selectAll.value) {
                      _selectedCustIds.assignAll(
                        list
                            .map((e) => e.custId ?? "")
                            .where((id) => id.isNotEmpty),
                      );
                    } else {
                      _selectedCustIds.clear();
                    }
                  },
                ),
              ),
              const DataColumn(
                label: Text(
                  "#",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: AppColor.black87,
                  ),
                ),
              ),
              DataColumn(label: _tableHeaderWithSort("Customer")),
              DataColumn(label: _tableHeaderWithSort("Customer Code")),
              DataColumn(label: _tableHeaderWithSort("Phone")),
              DataColumn(label: _tableHeaderWithSort("Type")),
              DataColumn(label: _tableHeaderWithSort("Address")),
              DataColumn(label: _tableHeaderWithSort("Status")),
              const DataColumn(
                label: Text(
                  "Actions",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: AppColor.black87,
                  ),
                ),
              ),
            ],
            rows: List.generate(list.length, (index) {
              final customer = list[index];
              final phoneList = customer.phoneList;
              final phoneData = (phoneList != null && phoneList.isNotEmpty)
                  ? phoneList[0]
                  : null;
              final custTypeList = customer.custType;
              final custType = (custTypeList != null && custTypeList.isNotEmpty)
                  ? custTypeList[0]
                  : null;
              final custId = customer.custId ?? "$index";

              return DataRow(
                cells: [
                  DataCell(
                    Checkbox(
                      value: _selectedCustIds.contains(custId),
                      activeColor: AppColor.dashboardGold,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: (val) {
                        if (val == true) {
                          _selectedCustIds.add(custId);
                        } else {
                          _selectedCustIds.remove(custId);
                        }
                      },
                    ),
                  ),
                  DataCell(
                    Text(
                      "${startIndex + index + 1}",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColor.black87,
                      ),
                    ),
                  ),
                  DataCell(
                    Row(
                      children: [
                        _buildCustomerAvatar(customer, size: 34),
                        const SizedBox(width: 10),
                        Text(
                          customer.name ?? AppString.noName,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColor.black87,
                          ),
                        ),
                      ],
                    ),
                    onTap: () => NavDrawerController.toNamed(
                      '/custDetail',
                      arguments: customer,
                    ),
                  ),
                  DataCell(
                    Text(
                      customer.custCode ?? "-",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColor.textSecondary,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      phoneData?.phone ?? "-",
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColor.textSecondary,
                      ),
                    ),
                  ),
                  DataCell(_buildTypeTag(custType?.typeName ?? "Regular")),
                  DataCell(
                    SizedBox(
                      width: 150,
                      child: Text(
                        customer.address ?? "-",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColor.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  DataCell(_buildStatusBadge(customer.status)),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            AppIcon.eyeOutline,
                            color: AppColor.dashboardGold,
                            size: 18,
                          ),
                          tooltip: AppString.viewDetails,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => NavDrawerController.toNamed(
                            '/custDetail',
                            arguments: customer,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(
                            AppIcon.editOutline,
                            color: AppColor.dashboardGold,
                            size: 18,
                          ),
                          tooltip: AppString.edit,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => NavDrawerController.toNamed(
                            '/addCustForm',
                            arguments: customer,
                          ),
                        ),
                        const SizedBox(width: 4),
                        PopupMenuButton<String>(
                          icon: const Icon(
                            AppIcon.moreVert,
                            color: AppColor.grey500,
                            size: 18,
                          ),
                          onSelected: (value) {
                            if (value == 'view') {
                              NavDrawerController.toNamed(
                                '/custDetail',
                                arguments: customer,
                              );
                            } else if (value == 'edit') {
                              NavDrawerController.toNamed(
                                '/addCustForm',
                                arguments: customer,
                              );
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'view',
                              child: Row(
                                children: [
                                  Icon(
                                    AppIcon.eyeOutline,
                                    size: 16,
                                    color: AppColor.dashboardGold,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    AppString.viewDetails,
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(
                                    AppIcon.editOutline,
                                    size: 16,
                                    color: AppColor.dashboardGold,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    AppString.updateCustomer,
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
  },
),
);
}

  Widget _tableHeaderWithSort(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: AppColor.black87,
          ),
        ),
        const SizedBox(width: 4),
        const Icon(AppIcon.unfoldMore, size: 14, color: AppColor.grey500),
      ],
    );
  }

  Widget _buildTypeTag(String typeName) {
    final isSilver = typeName.toLowerCase().contains("silver");
    final bg = isSilver ? AppColor.blueTagBg : AppColor.goldTagBg;
    final dotColor = isSilver ? AppColor.blueTagText : AppColor.goldTagDot;
    final textColor = isSilver ? AppColor.blueTagText : AppColor.goldTagText;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            typeName,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String? statusStr) {
    final s = (statusStr ?? "active").toLowerCase();
    final isPending = s.contains("pending") || s == "0";
    final isInactive = s.contains("inactive") || s == "false";

    Color bg;
    Color textColor;
    String text;

    if (isPending) {
      bg = AppColor.goldTagBg;
      textColor = AppColor.goldTagDot;
      text = AppString.pending;
    } else if (isInactive) {
      bg = AppColor.redLightBg;
      textColor = AppColor.redText;
      text = AppString.closed;
    } else {
      bg = AppColor.greenTagBg;
      textColor = AppColor.greenTagText;
      text = AppString.active;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(AppIcon.checkCircle, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerAvatar(CustomerData customer, {double size = 34}) {
    String? imageUrl;
    if (customer.imagePath != null &&
        customer.imagePath != "null" &&
        customer.imagePath!.isNotEmpty) {
      imageUrl = customer.imagePath;
    } else if (customer.image != null &&
        customer.image != "null" &&
        customer.image!.isNotEmpty) {
      imageUrl = customer.image;
    }

    final String? fullUrl = imageUrl != null
        ? (imageUrl.startsWith('http')
              ? imageUrl
              : "${AppUrl.baseURL}$imageUrl")
        : null;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColor.dashboardQuickActionBg,
        shape: BoxShape.circle,
        border: Border.all(color: AppColor.dashboardCream, width: 1),
      ),
      child: ClipOval(
        child: fullUrl != null
            ? Image.network(
                fullUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  AppIcon.person,
                  size: size * 0.6,
                  color: AppColor.dashboardGold.withOpacity(0.6),
                ),
              )
            : Icon(
                AppIcon.person,
                size: size * 0.6,
                color: AppColor.dashboardGold.withOpacity(0.6),
              ),
      ),
    );
  }

  Widget _buildGridView(List<CustomerData> list) {
    return GridView.builder(
      controller: _scrollController,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: AppSize.isDesktop ? 3 : (AppSize.isTablet ? 2 : 1),
        crossAxisSpacing: AppSize.p16,
        mainAxisSpacing: AppSize.p16,
        mainAxisExtent: 195,
      ),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final customer = list[index];
        final phoneList = customer.phoneList;
        final phoneData = (phoneList != null && phoneList.isNotEmpty)
            ? phoneList[0]
            : null;
        final custTypeList = customer.custType;
        final custType = (custTypeList != null && custTypeList.isNotEmpty)
            ? custTypeList[0]
            : null;

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColor.grey300),
            boxShadow: [
              BoxShadow(
                color: AppColor.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildCustomerAvatar(customer, size: 40),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customer.name ?? AppString.noName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColor.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Code: ${customer.custCode ?? '-'}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColor.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(customer.status),
                ],
              ),
              const Divider(height: 18, color: AppColor.grey200),
              Row(
                children: [
                  const Icon(
                    AppIcon.phone,
                    size: 14,
                    color: AppColor.dashboardGold,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      phoneData?.phone ?? "-",
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColor.textSecondary,
                      ),
                    ),
                  ),
                  _buildTypeTag(custType?.typeName ?? "Regular"),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    AppIcon.location,
                    size: 14,
                    color: AppColor.dashboardGold,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      customer.address ?? "-",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColor.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => NavDrawerController.toNamed(
                      '/custDetail',
                      arguments: customer,
                    ),
                    icon: const Icon(
                      AppIcon.eyeOutline,
                      size: 14,
                      color: AppColor.dashboardGold,
                    ),
                    label: const Text(
                      AppString.view,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColor.dashboardGold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColor.dashboardGold),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => NavDrawerController.toNamed(
                      '/addCustForm',
                      arguments: customer,
                    ),
                    icon: const Icon(
                      AppIcon.editOutline,
                      size: 14,
                      color: AppColor.white,
                    ),
                    label: const Text(
                      AppString.edit,
                      style: TextStyle(fontSize: 12, color: AppColor.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.dashboardGold,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaginationBar(int totalCount) {
    final perPage = _rowsPerPage.value;
    final totalPages = (totalCount / perPage).ceil().clamp(1, 9999);
    final currentPage = _currentPageIndex.value.clamp(1, totalPages);

    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 24),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 16,
        runSpacing: 12,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: currentPage > 1
                    ? () => _goToPage(currentPage - 1)
                    : null,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColor.grey300),
                  ),
                  child: Icon(
                    AppIcon.chevronLeft,
                    size: 18,
                    color: currentPage > 1
                        ? AppColor.black87
                        : AppColor.grey400,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ...List.generate(totalPages > 5 ? 5 : totalPages, (index) {
                final pageNum = index + 1;
                final isSelected = pageNum == currentPage;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: InkWell(
                    onTap: () => _goToPage(pageNum),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColor.dashboardGold
                            : AppColor.white,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? null
                            : Border.all(color: AppColor.grey300),
                      ),
                      child: Center(
                        child: Text(
                          "$pageNum",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isSelected
                                ? AppColor.white
                                : AppColor.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
              if (totalPages > 5) ...[
                const Text("...", style: TextStyle(color: AppColor.grey500)),
                const SizedBox(width: 6),
                InkWell(
                  onTap: () => _goToPage(totalPages),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: currentPage == totalPages
                          ? AppColor.dashboardGold
                          : AppColor.white,
                      shape: BoxShape.circle,
                      border: currentPage == totalPages
                          ? null
                          : Border.all(color: AppColor.grey300),
                    ),
                    child: Center(
                      child: Text(
                        "$totalPages",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: currentPage == totalPages
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: currentPage == totalPages
                              ? AppColor.white
                              : AppColor.black87,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
              ],
              InkWell(
                onTap: currentPage < totalPages
                    ? () => _goToPage(currentPage + 1)
                    : null,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColor.grey300),
                  ),
                  child: Icon(
                    AppIcon.chevronRight,
                    size: 18,
                    color: currentPage < totalPages
                        ? AppColor.black87
                        : AppColor.grey400,
                  ),
                ),
              ),
            ],
          ),
          PopupMenuButton<int>(
            onSelected: (count) {
              _rowsPerPage.value = count;
              _goToPage(1);
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                    size: 18,
                    color: AppColor.grey500,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget customerLoading() {
    return Shimmer.fromColors(
      baseColor: AppColor.baseColor,
      highlightColor: AppColor.highlightColor,
      child: ListView.builder(
        padding: EdgeInsets.all(AppSize.p16),
        itemCount: 8,
        itemBuilder: (context, index) => Container(
          height: AppSize.height * 0.15,
          margin: EdgeInsets.only(bottom: AppSize.p16),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(AppSize.p16),
          ),
        ),
      ),
    );
  }
}
