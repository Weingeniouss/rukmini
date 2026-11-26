// ignore_for_file: file_names, unnecessary_non_null_assertion, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/product/productType_Controller.dart';
import 'package:rukmini/controller/api/controllers/product/productTypeRemove_Controller.dart';
import 'package:rukmini/controller/ui/home/allMaster/metal_Master/metalMaster_ControllerUI.dart';
import 'package:rukmini/modal/product/productTypeList_Modal.dart';
import 'package:rukmini/view/utils/app_color.dart';
import 'package:rukmini/view/utils/app_icon.dart';
import 'package:rukmini/view/utils/app_string.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:shimmer/shimmer.dart';

class MetalMaster extends StatefulWidget {
  const MetalMaster({super.key});

  @override
  State<MetalMaster> createState() => _MetalMasterState();
}

class _MetalMasterState extends State<MetalMaster> {
  final productTypeController = Get.put(ProductTypeController());
  final metalMasterUI = Get.put(MetalMasterControllerUI());
  final productTypeRemoveController = Get.put(ProductTypeRemoveController());

  final TextEditingController _searchController = TextEditingController();
  final RxString _selectedMetalFilter = AppString.allMetal.obs;
  final RxString _selectedStatusFilter = AppString.allStatus.obs;
  final RxSet<String> _selectedIds = <String>{}.obs;
  final RxBool _selectAll = false.obs;
  final RxInt _rowsPerPage = 10.obs;
  final RxInt _currentPage = 1.obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CallApi.callProductTypeList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ProductTypeData> getFilteredList(List<ProductTypeData> list) {
    final query = _searchController.text.toLowerCase().trim();
    final metalFilter = _selectedMetalFilter.value.toLowerCase();
    final statusFilter = _selectedStatusFilter.value.toLowerCase();

    return list.where((item) {
      final name = (item.name ?? '').toLowerCase();
      final code = _generateCode(item.name).toLowerCase();

      if (query.isNotEmpty) {
        if (!name.contains(query) && !code.contains(query)) {
          return false;
        }
      }

      if (metalFilter != "all metal" && metalFilter != "all") {
        if (!name.contains(metalFilter)) {
          return false;
        }
      }

      if (statusFilter == "active") {
        // All active by default
      } else if (statusFilter == "inactive") {
        return false;
      }

      return true;
    }).toList();
  }

  String _generateCode(String? name) {
    if (name == null || name.isEmpty) return "MT-GEN";
    final clean = name.trim().replaceAll(" ", "").toUpperCase();
    if (clean.length <= 4) return "MT-$clean";
    return "MT-${clean.substring(0, 4)}";
  }

  String _getWeightUnit(String? name) {
    if (name == null) return "0.00 gm";
    final n = name.toLowerCase();
    if (n.contains("diamond")) return "0.00 ct";
    return "0.00 gm";
  }

  IconData _getMetalIcon(String? name) {
    if (name == null) return AppIcon.metal;
    final n = name.toLowerCase();
    if (n.contains("diamond")) return AppIcon.diamond;
    if (n.contains("gold") || n.contains("silver") || n.contains("platinum")) {
      return AppIcon.metal;
    }
    return AppIcon.layers;
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
        final bool isLoading = productTypeController.isLoading.value;
        final rawList = productTypeController.productTypeList.toList();
        final filteredList = getFilteredList(rawList);

        _selectedMetalFilter.value;
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
          onRefresh: () => CallApi.callProductTypeList(),
          color: AppColor.dashboardGold,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCards(rawList),
                _buildFilterBar(),
                if (filteredList.isEmpty)
                  Container(
                    height: 200,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColor.cardBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColor.border),
                    ),
                    child: Text(
                      AppString.noDataFound,
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
          AppIcon.layers,
          color: AppColor.dashboardGold,
          size: 22,
        ),
        const SizedBox(width: 8),
        Text(
          AppString.metalMaster,
          style: TextStyle(
            color: AppColor.mainText,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards(List<ProductTypeData> list) {
    String goldRate = "1,45,500.00";
    String silverRate = "90,000.00";

    for (var item in list) {
      final n = (item.name ?? '').toLowerCase();
      if (n.contains("gold") && !n.contains("rose")) {
        if (item.rate != null && item.rate!.isNotEmpty) {
          goldRate = item.rate!;
        }
      } else if (n.contains("silver")) {
        if (item.rate != null && item.rate!.isNotEmpty) {
          silverRate = item.rate!;
        }
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.goldTagBg.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColor.goldTagBg),
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColor.cardBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      AppIcon.metal,
                      color: AppColor.dashboardGold,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Gold",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColor.mainText,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "₹ $goldRate",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColor.mainText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.blueTagBg.withOpacity(0.4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColor.blueTagBg),
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColor.cardBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      AppIcon.metal,
                      color: AppColor.blueTagText,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Silver",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColor.mainText,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "₹ $silverRate",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColor.mainText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
                width: isCompact ? constraints.maxWidth : 300,
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColor.cardBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColor.border),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColor.mainText,
                    ),
                    decoration: InputDecoration(
                      hintText: AppString.searchMetalPlaceholder,
                      hintStyle: TextStyle(
                        color: AppColor.grey500,
                        fontSize: 13,
                      ),
                      prefixIcon: Icon(
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
                  icon: AppIcon.layers,
                  label: _selectedMetalFilter.value,
                  onTap: () => _showMetalMenu(btnContext),
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
                  color: AppColor.cardBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColor.border),
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
                    "Exporting Metal Master list...",
                    backgroundColor: AppColor.cardBg,
                    colorText: AppColor.mainText,
                    borderColor: AppColor.dashboardGold,
                    borderWidth: 1,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                icon: Icon(
                  AppIcon.fileDownload,
                  size: 16,
                  color: AppColor.mainText,
                ),
                label: Text(
                  AppString.export,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColor.mainText,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColor.cardBg,
                  side: BorderSide(color: AppColor.border),
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
                onPressed: () => _showAddEditDialog(),
                icon: const Icon(AppIcon.add, size: 16, color: AppColor.white),
                label: const Text(
                  AppString.addMetal,
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
        label != AppString.allMetal && label != AppString.allStatus;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.dashboardGold.withOpacity(0.08)
              : AppColor.cardBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColor.dashboardGold : AppColor.border,
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
                color: isSelected ? AppColor.dashboardGold : AppColor.mainText,
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

  void _showMetalMenu(BuildContext btnContext) {
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
      items: [AppString.allMetal, "Gold", "Silver", "Platinum", "Diamond"].map((m) {
        return PopupMenuItem<String>(
          value: m,
          child: Text(m, style: const TextStyle(fontSize: 13)),
        );
      }).toList(),
    ).then((value) {
      if (value != null) {
        _selectedMetalFilter.value = value;
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
    _selectedMetalFilter.value = AppString.allMetal;
    _selectedStatusFilter.value = AppString.allStatus;
    setState(() {});
  }

  Widget _buildTableView(List<ProductTypeData> list, {int startIndex = 0}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.border),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(AppColor.isDark ? 0.3 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: DataTable(
                  headingRowColor:
                      WidgetStateProperty.all(AppColor.dashboardGold),
                  headingTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.white,
                    fontSize: 13,
                  ),
                  dataRowMinHeight: 52,
                  dataRowMaxHeight: 52,
                  horizontalMargin: 16,
                  columnSpacing: 24,
                  columns: [
                    DataColumn(
                      label: Checkbox(
                        value: _selectAll.value,
                        activeColor: AppColor.white,
                        checkColor: AppColor.dashboardGold,
                        side:
                            const BorderSide(color: AppColor.white, width: 1.5),
                        onChanged: (val) {
                          _selectAll.value = val ?? false;
                          if (_selectAll.value) {
                            _selectedIds.addAll(
                              list.map((e) => e.productTypeId ?? ''),
                            );
                          } else {
                            _selectedIds.clear();
                          }
                        },
                      ),
                    ),
                    const DataColumn(label: Text("#")),
                    const DataColumn(label: Text("Metal")),
                    const DataColumn(label: Text("Code")),
                    DataColumn(label: _sortHeader("Rate (₹)")),
                    DataColumn(label: _sortHeader("Qty / Weight")),
                    DataColumn(label: _sortHeader("Status")),
                    const DataColumn(label: Text("Actions")),
                  ],
                  rows: List.generate(list.length, (index) {
                    final item = list[index];
                    final id = item.productTypeId ?? '';
                    final isChecked = _selectedIds.contains(id);
                    final code = _generateCode(item.name);
                    final weightUnit = _getWeightUnit(item.name);

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
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: AppColor.mainText,
                            ),
                          ),
                        ),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getMetalIcon(item.name),
                                color: AppColor.dashboardGold,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                item.name ?? AppString.noName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: AppColor.mainText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(
                          Text(
                            code,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColor.subText,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            item.rate ?? "0.00",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColor.mainText,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            weightUnit,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColor.subText,
                            ),
                          ),
                        ),
                        DataCell(_buildStatusBadge("Active")),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  AppIcon.eyeOutline,
                                  color: AppColor.mainText,
                                  size: 18,
                                ),
                                tooltip: AppString.view,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () => _showAddEditDialog(item: item),
                              ),
                              const SizedBox(width: 10),
                              IconButton(
                                icon: Icon(
                                  AppIcon.editOutline,
                                  color: AppColor.mainText,
                                  size: 18,
                                ),
                                tooltip: AppString.edit,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () => _showAddEditDialog(item: item),
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
      );
    },
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
      child: Row(
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
          style: TextStyle(
            fontSize: 13,
            color: AppColor.subText,
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
                      color: AppColor.cardBg,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColor.border),
                    ),
                    child: Icon(
                      AppIcon.chevronLeft,
                      size: 16,
                      color: currentPage > 1
                          ? AppColor.mainText
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
                      color: AppColor.cardBg,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColor.border),
                    ),
                    child: Icon(
                      AppIcon.chevronLeft,
                      size: 16,
                      color: currentPage > 1
                          ? AppColor.mainText
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
                      color: AppColor.cardBg,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColor.border),
                    ),
                    child: Icon(
                      AppIcon.chevronRight,
                      size: 16,
                      color: currentPage < totalPages
                          ? AppColor.mainText
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
                      color: AppColor.cardBg,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColor.border),
                    ),
                    child: Icon(
                      AppIcon.chevronRight,
                      size: 16,
                      color: currentPage < totalPages
                          ? AppColor.mainText
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
                  color: AppColor.cardBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColor.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${_rowsPerPage.value} / page",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColor.mainText,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
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

  void _showAddEditDialog({ProductTypeData? item}) {
    if (item != null) {
      metalMasterUI.startEditing(
        item.productTypeId,
        item.name,
        item.rate,
      );
    } else {
      metalMasterUI.editingId.value = null;
      metalMasterUI.metalController.clear();
      metalMasterUI.rateController.clear();
    }

    Get.dialog(
      Dialog(
        backgroundColor: AppColor.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 380,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    AppIcon.layers,
                    color: AppColor.dashboardGold,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item == null ? AppString.addMetal : "Edit Metal Master",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColor.mainText,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(AppIcon.clearIcon, size: 20, color: AppColor.mainText),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              Divider(height: 20, color: AppColor.border),
              const SizedBox(height: 10),
              TextField(
                controller: metalMasterUI.metalController,
                style: TextStyle(color: AppColor.mainText),
                decoration: InputDecoration(
                  labelText: AppString.metal,
                  labelStyle: TextStyle(color: AppColor.subText),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColor.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColor.dashboardGold),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: metalMasterUI.rateController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: AppColor.mainText),
                decoration: InputDecoration(
                  labelText: AppString.rate,
                  labelStyle: TextStyle(color: AppColor.subText),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColor.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColor.dashboardGold),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () async {
                    Get.back();
                    await metalMasterUI.save();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.dashboardGold,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    item == null ? AppString.save : AppString.update,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColor.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _shimmerLoading() {
    return Shimmer.fromColors(
      baseColor: AppColor.isDark ? const Color(0xFF1E293B) : AppColor.grey300,
      highlightColor: AppColor.isDark ? const Color(0xFF334155) : AppColor.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: List.generate(
            6,
            (index) => Container(
              height: 52,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColor.cardBg,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(ProductTypeData item) {
    Get.defaultDialog(
      title: AppString.deleteMetalTouch,
      middleText: "${AppString.deleteMetalTouchMessage} \n\n ${item.name}",
      textConfirm: AppString.delete,
      textCancel: AppString.cancel,
      confirmTextColor: AppColor.white,
      buttonColor: AppColor.deleteColor,
      onConfirm: () async {
        Get.back();
        await CallApi.callProductTypeRemove(
          productTypeId: item.productTypeId ?? "",
        );
        await CallApi.callProductTypeList();
      },
    );
  }
}
