// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/home/customers/custList_Controller.dart';
import 'package:rukmini/modal/home/customer/customer_list_model.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/drawer.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:marquee/marquee.dart';

class Custlist extends StatefulWidget {
  const Custlist({super.key});

  @override
  State<Custlist> createState() => _CustlistState();
}

class _CustlistState extends State<Custlist> {
  final custListController = Get.put(CustListController());
  final ScrollController _scrollController = ScrollController();

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
          CallApi.callCustList();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Fullscreen(
      appBar: appBar(title: 'Customer List'),
      drawer: homeDrawer(),
      child: Obx(() {
        final loading = custListController.isLoading.value;
        final list = custListController.customers;

        if (loading && list.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!loading && list.isEmpty) {
          return const Center(child: Text('No Customers Found'));
        }

        return RefreshIndicator(
          backgroundColor: AppColor.backgroundColor,
          color: AppColor.primaryColor,
          elevation: 2.0,
          onRefresh: () => CallApi.callCustList(isRefresh: true),
          child: Column(
            children: [
              customersList(scrollController: _scrollController, list: list),
              if (custListController.isMoreLoading.value) nextPageLoading(),
            ],
          ),
        );
      }),
    );
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
        // FIX: Access the first phone number, not the phone number at the global 'index'
        final phoneData =
            (customer.phoneList != null && customer.phoneList!.isNotEmpty)
            ? customer.phoneList!.first
            : null;

        final CustType =
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

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showHeader)
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                child: Text(
                  currentInitial,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Colors.green,
                  ),
                ),
              ),
            Card(
              color: AppColor.backgroundColor,
              margin: const EdgeInsets.symmetric(vertical: 6),
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
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
                ),
                title: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Name: ',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: Get.width * 0.035,
                          ),
                        ),
                        marqueeText(customer.name ?? ''),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Address: ',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: Get.width * 0.035,
                          ),
                        ),
                        marqueeText(customer.address ?? ''),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Phone: ',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: Get.width * 0.035,
                              ),
                            ),
                            Text(
                              phoneData?.phone ?? 'No Phone',
                              style: TextStyle(fontSize: Get.width * 0.035),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Type: ',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: Get.width * 0.035,
                              ),
                            ),
                            Text(
                              CustType?.typeName ?? 'No Phone',
                              style: TextStyle(fontSize: Get.width * 0.035),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'CustCode: ',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: Get.width * 0.037,
                        ),
                      ),
                      Text(
                        customer.custCode ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  // Navigate to details
                },
              ),
            ),
          ],
        );
      },
    ),
  );
}

Widget nextPageLoading() {
  return const Padding(
    padding: EdgeInsets.all(8.0),
    child: Center(child: CircularProgressIndicator()),
  );
}

Widget marqueeText(String text) {
  return Expanded(
    child: SizedBox(
      height: 20,
      child: Marquee(
        text: text.isEmpty ? 'N/A' : text,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: Get.width * 0.035,
        ),
        scrollAxis: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.start,
        blankSpace: 30.0,
        velocity: 30.0,
        pauseAfterRound: const Duration(seconds: 2),
        startPadding: 10.0,
        accelerationDuration: const Duration(seconds: 1),
        accelerationCurve: Curves.linear,
        decelerationDuration: const Duration(milliseconds: 500),
        decelerationCurve: Curves.easeOut,
      ),
    ),
  );
}
