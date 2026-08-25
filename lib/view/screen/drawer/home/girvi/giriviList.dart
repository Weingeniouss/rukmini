// ignore_for_file: file_names, unnecessary_to_list_in_spreads, avoid_returning_null_for_void, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/drawer/home/girvi/giriviList_Controller.dart';
import 'package:rukmini/controller/api/controllers/year/year_Controller.dart';
import 'package:rukmini/modal/year/year_modal.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:rukmini/view/utils/widget/horizontalPadding.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../utils/app_Icon.dart';

class GiriviList extends StatefulWidget {
  const GiriviList({super.key});

  @override
  State<GiriviList> createState() => _GiriviListState();
}

class _GiriviListState extends State<GiriviList> {
  final giriviListController = Get.put(GiriviListController());
  final yearController = Get.put(YearController());
  final ScrollController _scrollController = ScrollController();

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
          selectedYear.title ?? 'All';
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

  @override
  Widget build(BuildContext context) {
    return Fullscreen(
      isPadding: false,
      backGroundcolor: AppColor.backgroundColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        onPressed: () {
          Get.toNamed('/giriviadd');
        },
        child: Icon(AppIcon.add, color: AppColor.goldColor, size: 30),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(
          () => appBar(
            back: true,
            title: giriviListController.isSearching.value
                ? _searchField()
                : AppString.giriviList,
            searchIcon: !giriviListController.isSearching.value,
            filter: !giriviListController.isSearching.value,
            filterOnPressed: () => _showFilterOption(),
            searchOnPressed: () {
              giriviListController.isSearching.value = true;
            },
          ),
        ),
      ),
      child: Obx(() {
        if (giriviListController.isLoading.value &&
            giriviListController.giriviList.isEmpty) {
          return _shimmerLoading();
        }

        final data = giriviListController.giriviList;

        if (data.isEmpty) {
          return Center(child: Text(AppString.noDataFound));
        }

        return RefreshIndicator(
          backgroundColor: AppColor.white,
          color: AppColor.goldColor,
          elevation: 2.0,
          onRefresh: () => callApiGirviList(giriviListController),
          child: Column(
            children: [
              yearListSelector(),
              Expanded(child: horizontalPadding(child: listItem(data))),
            ],
          ),
        );
      }),
    );
  }

  Widget yearListSelector() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.p16,
        vertical: AppSize.p8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${AppString.selectYear}:',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: AppSize.size14,
              color: AppColor.textColor,
            ),
          ),
          Obx(
            () => Container(
              padding: EdgeInsets.symmetric(horizontal: AppSize.p12),
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColor.grey300.withOpacity(0.5)),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.black.withOpacity(0.02),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: giriviListController.selectedYearId.value,
                  icon: const Icon(
                    AppIcon.arrow_down,
                    color: AppColor.goldColor,
                  ),
                  items: [
                    DropdownMenuItem(
                      value: '0',
                      child: Text(
                        AppString.allYears,
                        style: TextStyle(fontSize: AppSize.size14),
                      ),
                    ),
                    ...yearController.yearList.map((YearData year) {
                      return DropdownMenuItem(
                        value: year.yearId,
                        child: Text(
                          year.title ?? '',
                          style: TextStyle(fontSize: AppSize.size14),
                        ),
                      );
                    }).toList(),
                  ],
                  onChanged: (String? value) {
                    changeYaer(value);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void changeYaer(String? value) {
    final api = giriviListController;
    if (value != null) {
      api.selectedYearId.value = value;
      final selected = yearController.yearList.firstWhereOrNull(
        (y) => y.yearId == value,
      );
      api.selectedYearTitle.value = selected?.title ?? AppString.allYears;
      callApiGirviList(giriviListController);
    }
  }

  Widget listItem(List<dynamic> data) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _scrollController,
      itemCount: data.length + (giriviListController.isLoadMore.value ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < data.length) {
          final item = data[index];
          bool isClosed = item.isClosed == "1";
          return Container(
            margin: EdgeInsets.symmetric(vertical: AppSize.p8),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColor.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: InkWell(
              onTap: () {
                Get.toNamed('/giriviDetail', arguments: item.girviId);
              },
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: EdgeInsets.all(AppSize.p16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(AppSize.p10),
                          decoration: BoxDecoration(
                            color: AppColor.whiteOrang.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            AppIcon.person,
                            color: AppColor.goldColor,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: AppSize.p12),
                        Expanded(
                          child: Text(
                            item.custName ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: AppSize.mediumText * 1.3,
                              color: AppColor.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isClosed
                                ? AppColor.red.withOpacity(0.1)
                                : AppColor.activeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            isClosed ? AppString.closed : AppString.open,
                            style: TextStyle(
                              color: isClosed
                                  ? AppColor.red
                                  : AppColor.activeColor,
                              fontSize: AppSize.smallText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSize.p12),
                      child: Divider(
                        height: 1,
                        thickness: 0.5,
                        color: AppColor.grey300.withOpacity(0.5),
                      ),
                    ),
                    Row(
                      children: [
                        _infoColumn(
                          item.uniqueId ?? 'N/A',
                          icon: AppIcon.fingerprint,
                        ),
                        Container(
                          height: 20,
                          width: 1,
                          color: AppColor.grey300.withOpacity(0.5),
                        ),
                        _infoColumn(
                          _formatDate(item.girviDate),
                          icon: AppIcon.calendar,
                        ),
                      ],
                    ),
                    SizedBox(height: AppSize.p16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSize.p16,
                            vertical: AppSize.p10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.whiteOrang.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                AppIcon.rupee,
                                color: AppColor.goldColor,
                                size: 18,
                              ),
                              SizedBox(width: AppSize.p4),
                              Text(
                                item.givenAmt ?? '0.00',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppSize.mediumText * 1.3,
                                  color: AppColor.goldColor,
                                ),
                              ),
                              SizedBox(width: AppSize.p8),
                              Text(
                                '(${item.interest ?? '0.00'}%)',
                                style: TextStyle(
                                  color: AppColor.textColor,
                                  fontSize: AppSize.smallText,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(AppSize.p8),
                              decoration: BoxDecoration(
                                color: AppColor.whiteOrang.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                AppIcon.phone,
                                color: AppColor.goldColor,
                                size: 18,
                              ),
                            ),
                            SizedBox(width: AppSize.p8),
                            Text(
                              item.custPhone ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColor.black,
                                fontSize: AppSize.commonText,
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
        } else {
          return _paginationShimmer();
        }
      },
    );
  }

  Widget _infoColumn(String value, {IconData? icon}) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: AppSize.p16, color: AppColor.goldColor),
            SizedBox(width: AppSize.p8),
          ],
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColor.black,
              fontSize: AppSize.commonText,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      DateTime date = DateTime.parse(dateStr);
      return DateFormat('dd/MMMM/yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  void _showFilterOption() {
    Get.bottomSheet(
      enableDrag: true,
      Container(
        height: Get.height * 0.7,
        padding: EdgeInsets.all(Get.width * 0.05),
        decoration: BoxDecoration(
          color: AppColor.fullScreenColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: Get.width * 0.1,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColor.grey300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppString.filterOptions,
                    style: TextStyle(
                      fontSize: Get.width * 0.03,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      giriviListController.selectedFilterType.value =
                          AppString.all;
                      giriviListController.fromDateController.clear();
                      giriviListController.toDateController.clear();
                    },
                    child: Text(AppString.reset),
                  ),
                ],
              ),
              Divider(),
              SizedBox(height: Get.height * 0.015),
              Text(
                AppString.status,
                style: TextStyle(
                  fontSize: Get.width * 0.02,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: Get.height * 0.015),
              Obx(
                () => Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: ['All', 'Open', 'Closed', 'Carry Forward'].map((
                    status,
                  ) {
                    bool isSelected =
                        giriviListController.selectedFilterType.value == status;

                    return ChoiceChip(
                      label: Text(
                        status,
                        style: TextStyle(
                          color: isSelected ? AppColor.white : AppColor.black,
                          fontSize: AppSize.commonText,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: _getStatusColor(status),
                      backgroundColor: AppColor.grey200,
                      onSelected: (selected) {
                        if (selected) {
                          giriviListController.selectedFilterType.value =
                              status;
                        }
                      },
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: Get.height * 0.03),
              Text(
                AppString.dateRange,
                style: TextStyle(
                  fontSize: Get.width * 0.02,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              Row(
                children: [
                  Expanded(
                    child: _dateTextField(
                      controller: giriviListController.fromDateController,
                      label: AppString.fromeDate,
                    ),
                  ),
                  SizedBox(width: Get.width * 0.04),
                  Expanded(
                    child: _dateTextField(
                      controller: giriviListController.toDateController,
                      label: AppString.toDate,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.04),
              SizedBox(
                width: double.infinity,
                height: Get.height * 0.06,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    callApiGirviList(giriviListController);
                    Get.back();
                  },
                  child: Text(
                    AppString.applyFilter,
                    style: TextStyle(
                      color: AppColor.white,
                      fontSize: AppSize.size14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).viewInsets.bottom + AppSize.p20,
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _searchField() {
    return TextField(
      controller: giriviListController.searchTextController,
      autofocus: true,
      style: const TextStyle(color: AppColor.black),
      cursorColor: AppColor.goldColor,
      decoration: InputDecoration(
        hintText: AppString.search,
        hintStyle: TextStyle(color: AppColor.black.withOpacity(0.5)),
        border: InputBorder.none,
        suffixIcon: IconButton(
          icon: const Icon(AppIcon.closeIcon, color: AppColor.goldColor),
          onPressed: () {
            giriviListController.searchTextController.clear();
            giriviListController.isSearching.value = false;
            fetchData();
          },
        ),
      ),
      onChanged: (value) {
        CallApi.callGiriviList(
          isRefresh: true,
          search: value,
          yearId: giriviListController.selectedYearId.value,
          filterType: giriviListController.selectedFilterType.value,
          formDate: giriviListController.fromDateController.text,
          toDate: giriviListController.toDateController.text,
        );
      },
    );
  }

  Widget _dateTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: Get.width * 0.032,
            color: AppColor.textColor,
          ),
        ),
        SizedBox(height: AppSize.p8),
        TextField(
          controller: controller,
          readOnly: true,
          style: TextStyle(fontSize: AppSize.commonText),
          decoration: InputDecoration(
            hintText: 'YYYY-MM-DD',
            hintStyle: TextStyle(
              fontSize: AppSize.smallText,
              color: AppColor.grey400,
            ),
            suffixIcon: const Icon(AppIcon.date, size: 18),
            filled: true,
            fillColor: AppColor.grey200,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.p10),
              borderSide: const BorderSide(color: AppColor.grey300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.p10),
              borderSide: const BorderSide(color: AppColor.grey300),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSize.p12,
              vertical: 0,
            ),
          ),
          onTap: () => _selectDate(controller),
        ),
      ],
    );
  }

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: _datePickerTheme,
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      controller.text = formattedDate;
    }
  }

  Widget _datePickerTheme(BuildContext context, Widget? child) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(
          primary: AppColor.primaryColor,
          onPrimary: AppColor.white,
          onSurface: AppColor.textColor,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: AppColor.primaryColor),
        ),
      ),
      child: child!,
    );
  }

  Widget _shimmerLoading() {
    return ListView.builder(
      itemCount: 6,
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.p16,
        vertical: AppSize.p4,
      ),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColor.grey300,
          highlightColor: AppColor.white,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: AppSize.p8),
            height: AppSize.height * 0.22,
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      },
    );
  }

  Widget _paginationShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColor.grey300,
      highlightColor: AppColor.white,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: AppSize.p8),
        height: AppSize.height * 0.1,
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Open':
        return AppColor.activeColor;
      case 'Closed':
        return AppColor.deleteColor;
      case 'Carry Forward':
        return AppColor.orange;
      default:
        return AppColor.primaryColor;
    }
  }
}

Future<void> callApiGirviList(GiriviListController giriviListController) async {
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
