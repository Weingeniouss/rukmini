// ignore_for_file: strict_top_level_inference, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/drawer/home/customers/custList_Controller.dart';
import 'package:rukmini/modal/drawer/home/customer/customer_list_model.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/drawer.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:marquee/marquee.dart';
import 'package:shimmer/shimmer.dart';

class Custlist extends StatefulWidget {
  const Custlist({super.key});

  @override
  State<Custlist> createState() => _CustlistState();
}

class _CustlistState extends State<Custlist> {
  final custListController = Get.put(CustListController());
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final RxBool _isSearching = false.obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CallApi.callCustList(isRefresh: true);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
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
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Fullscreen(
        appBar: appBar(
          title: _isSearching.value
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    hintText: 'Search Customer...',
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    custListController.searchQuery.value = value;
                    CallApi.callCustList(isRefresh: true, search: value);
                  },
                )
              : AppString.customer,
          searchIcon: true,
          searchOnPressed: () {
            _isSearching.value = !_isSearching.value;
            if (!_isSearching.value) {
              _searchController.clear();
              custListController.searchQuery.value = "";
              CallApi.callCustList(isRefresh: true);
            }
          },
        ),
        drawer: homeDrawer(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColor.primaryColor,
          onPressed: () {
            Get.snackbar(
              'Coming Soon',
              'Add Customer feature is under development',
            );
          },
          child: Icon(Icons.add, color: Colors.white),
        ),
        child: Obx(() {
          final loading = custListController.isLoading.value;
          final list = custListController.customers;

          if (loading && list.isEmpty) {
            return customerLoading();
          }

          if (!loading && list.isEmpty) {
            return Center(child: Text('No Customers Found'));
          }

          return RefreshIndicator(
            backgroundColor: AppColor.backgroundColor,
            color: AppColor.primaryColor,
            elevation: 2.0,
            onRefresh: () => CallApi.callCustList(
              isRefresh: true,
              search: _searchController.text,
            ),
            child: Column(
              children: [
                customersList(scrollController: _scrollController, list: list),
                if (custListController.isMoreLoading.value) nextPageLoading(),
              ],
            ),
          );
        }),
      );
    });
  }
}

Widget customersList({
  ScrollController? scrollController,
  required List<CustomerData> list,
}) {
  return Expanded(
    child: ListView.builder(
      controller: scrollController,
      itemCount: list.length,
      itemBuilder: (context, index) {
        final customer = list[index];
        final phoneData =
            (customer.phoneList != null && customer.phoneList!.isNotEmpty)
            ? customer.phoneList!.first
            : null;

        final custType =
            (customer.custType != null && customer.custType!.isNotEmpty)
            ? customer.custType!.first
            : null;

        // Logic for Section Headers (A, B, C...)
        final String name = customer.name ?? 'No Name';
        final String currentInitial = name.isNotEmpty
            ? name[0].toUpperCase()
            : '?';

        bool showHeader = false;
        if (index == 0) {
          showHeader = true;
        } else {
          final String prevName = list[index - 1].name ?? '';
          final String previousInitial = prevName.isNotEmpty
              ? prevName[0].toUpperCase()
              : '?';
          if (currentInitial != previousInitial) {
            showHeader = true;
          }
        }

        return dataValue(
          showHeader,
          currentInitial,
          customer,
          phoneData,
          custType,
        );
      },
    ),
  );
}

Widget dataValue(showHeader, currentInitial, customer, phoneData, custType) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (showHeader)
        Padding(
          padding: EdgeInsets.fromLTRB(
            Get.width * 0.02,
            Get.height * 0.02,
            Get.width * 0.02,
            Get.width * 0.02,
          ),
          child: Text(
            currentInitial,
            style: TextStyle(
              fontSize: Get.width * 0.045,
              fontWeight: FontWeight.normal,
              color: Colors.green,
            ),
          ),
        ),
      Card(
        color: AppColor.backgroundColor,
        margin: EdgeInsets.symmetric(vertical: 6),
        child: ListTile(
          leading: Container(
            width: Get.width * 0.12,
            height: Get.height * 0.1,
            decoration: BoxDecoration(
              color: AppColor.primaryColor,
              borderRadius: BorderRadius.circular(Get.width * 0.015),
              image: customer.imagePath != null
                  ? DecorationImage(
                      image: NetworkImage(customer.imagePath!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: customer.imagePath == null
                ? Icon(Icons.person, color: AppColor.backgroundColor)
                : null,
          ),
          title: Column(
            children: [
              valueText(key: AppString.name, value: customer.name),
              valueText(key: AppString.address, value: customer.address),
              Row(
                children: [
                  Expanded(
                    child: valueText(
                      key: AppString.phone,
                      value: phoneData?.phone,
                    ),
                  ),
                  Spacer(),
                  Expanded(
                    child: valueText(
                      key: AppString.type,
                      value: custType?.typeName,
                    ),
                  ),
                ],
              ),
            ],
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 5),
            child: valueText(key: AppString.custCode, value: customer.custCode),
          ),
          onTap: () => Get.toNamed('/custDetail', arguments: customer),
        ),
      ),
    ],
  );
}

Widget valueText({String? key, String? value}) {
  return Row(
    children: [
      Text(
        '$key: ',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: Get.width * 0.030,
        ),
      ),
      marqueeText(value ?? ''),
    ],
  );
}

Widget nextPageLoading() {
  return Padding(
    padding: EdgeInsets.all(8.0),
    child: Center(
      child: CircularProgressIndicator(color: AppColor.primaryColor),
    ),
  );
}

Widget marqueeText(String text) {
  final String displayText = text.isEmpty ? 'N/A' : text;
  final TextStyle textStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: Get.width * 0.035,
    color: AppColor.textColor,
  );

  return Expanded(
    child: SizedBox(
      height: 20,
      child: displayText.length > 11
          ? Marquee(
              text: displayText,
              style: textStyle,
              scrollAxis: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              blankSpace: 30.0,
              velocity: 30.0,
              pauseAfterRound: Duration(seconds: 2),
              startPadding: Get.width * 0.025,
              accelerationDuration: Duration(seconds: 1),
              accelerationCurve: Curves.linear,
              decelerationDuration: Duration(milliseconds: 500),
              decelerationCurve: Curves.easeOut,
            )
          : Text(
              displayText,
              style: textStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
    ),
  );
}

Widget customerLoading() {
  return ListView.builder(
    itemCount: 10,
    itemBuilder: (context, index) {
      return Shimmer.fromColors(
        baseColor: AppColor.baseColor ?? Colors.grey[300]!,
        highlightColor: AppColor.highlightColor ?? Colors.grey[100]!,
        child: Card(
          child: ListTile(
            leading: Container(
              width: Get.width * 0.12,
              height: Get.height * 0.1,
              decoration: BoxDecoration(
                color: AppColor.textField,
                borderRadius: BorderRadius.circular(Get.width * 0.015),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: Get.height * 0.02,
                  color: AppColor.textField,
                ),
                SizedBox(height: Get.height * 0.012),
                Container(
                  width: Get.width * 0.5,
                  height: Get.height * 0.02,
                  color: AppColor.textField,
                ),
              ],
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(top: Get.height * 0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: Get.width * 0.2,
                    height: Get.height * 0.02,
                    color: AppColor.textField,
                  ),
                  Container(
                    width: Get.width * 0.2,
                    height: Get.height * 0.02,
                    color: AppColor.textField,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
