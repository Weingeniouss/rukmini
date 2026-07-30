// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/drawer/home/girvi/giriviDetail_Controller.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';

class GiriviDetail extends StatefulWidget {
  const GiriviDetail({super.key});

  @override
  State<GiriviDetail> createState() => _GiriviDetailState();
}

class _GiriviDetailState extends State<GiriviDetail> {
  final giriviDetailController = Get.put(GiriviDetailController());
  late String girviId;

  @override
  void initState() {
    super.initState();
    girviId = Get.arguments ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (girviId.isNotEmpty) {
        CallApi.callGiriviDetail(girviId: girviId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Fullscreen(
        isPadding: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Obx(() {
            final data = giriviDetailController.giriviDetailData.value.data;
            bool isOpen = data?.isClosed != "1";
            return appBar(
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppString.girviDetail,
                    style: TextStyle(
                      color: AppColor.fullScreenColor,
                      fontSize: Get.width * 0.045,
                    ),
                  ),
                  Text(
                    isOpen
                        ? ' ( ${AppString.open} )'
                        : ' ( ${AppString.closed} )',
                    style: TextStyle(
                      color: isOpen
                          ? AppColor.activeColor
                          : AppColor.errorColor,
                      fontSize: Get.width * 0.035,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              centerTitle: !isOpen,
              back: true,
              edit: isOpen,
              remove: true,
              close: isOpen,
              editOnPressed: () {
                Get.toNamed('/giriviadd');
              },
              deletOnPressed: () {
                CallApi.callRemoveGirvie(girviId: girviId);
              },
              closeOnPressed: () {
                CallApi.callCloseGirvie(girviId: girviId);
              },
            );
          }),
        ),
        child: Obx(() {
          if (giriviDetailController.isLoading.value) {
            return _shimmerLoading();
          }

          final data = giriviDetailController.giriviDetailData.value.data;

          if (data == null) {
            return Center(child: Text("No data found"));
          }

          return Column(
            children: [
              Container(
                decoration: BoxDecoration(color: AppColor.backgroundColor),
                child: Column(
                  children: [_buildTopHeader(data), _buildActionButtons()],
                ),
              ),
              TabBar(
                tabAlignment: TabAlignment.start,
                isScrollable: true,
                labelColor: AppColor.primaryColor,
                unselectedLabelColor: AppColor.boderSideColor,
                indicatorColor: AppColor.primaryColor,
                tabs: [
                  Tab(text: AppString.girviDetail),
                  Tab(text: AppString.productDetail),
                  Tab(text: AppString.customerDetail.toUpperCase()),
                  Tab(text: AppString.transactionDetail),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildGirviDetailsTab(data),
                    _buildProductDetailTab(data),
                    _buildCustomerDetailsTab(data),
                    _buildTransactionDetailsTab(data),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTopHeader(data) {
    return Padding(
      padding: EdgeInsets.all(Get.width * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${AppString.girviId}: ${data.uniqueId}",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: Get.width * 0.04,
            ),
          ),
          Text(
            "${AppString.pendingAmt}: ${data.balance}",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: Get.width * 0.04,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(AppIcon.call, AppString.call),
          _buildActionButton(AppIcon.message, AppString.message),
          _buildActionButton(AppIcon.message, AppString.whatsapp),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: Get.width * 0.06,
          backgroundColor: AppColor.primaryColor,
          child: Icon(
            icon,
            color: AppColor.fullScreenColor,
            size: Get.width * 0.06,
          ),
        ),
        SizedBox(height: Get.height * 0.005),
        Text(label, style: TextStyle(fontSize: Get.width * 0.03)),
      ],
    );
  }

  Widget _buildGirviDetailsTab(data) {
    return ListView(
      padding: EdgeInsets.all(Get.width * 0.04),
      children: [
        _buildInfoRow(
          AppIcon.category,
          AppString.totProd,
          data.totalCunt ?? "0",
        ),
        _buildInfoRow(
          AppIcon.calendar,
          AppString.girviDate,
          data.girviDate ?? "",
        ),
        _buildInfoRow(AppIcon.rupee, AppString.gvnAmt, data.givenAmt ?? ""),
        _buildInfoRow(AppIcon.percent, AppString.intRate, "${data.interest}%"),
        _buildInfoRow(
          AppIcon.calendar,
          AppString.duration,
          "${data.givenMonth} ${AppString.month}",
        ),
        _buildInfoRow(AppIcon.calendar, AppString.dueDate, data.dueDate ?? ""),
        _buildInfoRow(
          AppIcon.calendar,
          AppString.gracePeriod,
          "${data.gracePeriod} ${AppString.days}",
        ),
        _buildInfoRow(
          AppIcon.calendar,
          AppString.carryforwrdDt,
          data.actualDate ?? "",
        ),
        _buildInfoRow(
          AppIcon.rupee,
          AppString.carryforwrdAmt,
          data.actualAmt ?? "",
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Get.height * 0.015),
      child: Row(
        children: [
          Icon(icon, color: AppColor.activeColor, size: Get.width * 0.05),
          SizedBox(width: Get.width * 0.04),
          Text(
            "$label :",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Get.width * 0.035,
            ),
          ),
          SizedBox(width: Get.width * 0.02),
          Text(value, style: TextStyle(fontSize: Get.width * 0.035)),
        ],
      ),
    );
  }

  Widget _buildProductDetailTab(data) {
    if (data.productDetail == null || data.productDetail.isEmpty) {
      return Center(
        child: Text(
          "No products found",
          style: TextStyle(fontSize: Get.width * 0.04),
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.all(Get.width * 0.04),
      itemCount: data.productDetail.length,
      itemBuilder: (context, index) {
        final product = data.productDetail[index];
        return Card(
          child: Padding(
            padding: EdgeInsets.all(Get.width * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${AppString.proTyp} : ${product.prodType}",
                      style: TextStyle(fontSize: Get.width * 0.035),
                    ),
                    Text(
                      "${AppString.metal} : ${product.metalName}",
                      style: TextStyle(fontSize: Get.width * 0.035),
                    ),
                  ],
                ),
                SizedBox(height: Get.height * 0.005),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${AppString.pcs} : ${product.pieces}(${product.weight}gm)",
                      style: TextStyle(fontSize: Get.width * 0.035),
                    ),
                    Text(
                      "${AppString.origPrice} : ${product.origAmount}",
                      style: TextStyle(fontSize: Get.width * 0.035),
                    ),
                  ],
                ),
                SizedBox(height: Get.height * 0.005),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${AppString.gvnAmt} : ${product.givenAmount}",
                      style: TextStyle(fontSize: Get.width * 0.035),
                    ),
                    Text(
                      "${AppString.rate} : ${product.todayRate}",
                      style: TextStyle(fontSize: Get.width * 0.035),
                    ),
                  ],
                ),
                SizedBox(height: Get.height * 0.005),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${AppString.locker} : ${(product.lockerList != null && product.lockerList!.isNotEmpty) ? product.lockerList!.first.lockerCode : '-'}(${product.productStatus})",
                      style: TextStyle(fontSize: Get.width * 0.035),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Icon(
                            AppIcon.edit.icon,
                            color: AppColor.activeColor,
                            size: Get.width * 0.05,
                          ),
                        ),
                        SizedBox(width: Get.width * 0.02),
                        IconButton(
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Icon(
                            AppIcon.delete.icon,
                            color: AppColor.errorColor,
                            size: Get.width * 0.05,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomerDetailsTab(data) {
    return ListView(
      padding: EdgeInsets.all(Get.width * 0.04),
      children: [
        Center(
          child: CircleAvatar(
            radius: Get.width * 0.12,
            child: Icon(AppIcon.person, size: Get.width * 0.12),
          ),
        ),
        SizedBox(height: Get.height * 0.02),
        _buildCustomerInfoRow(AppIcon.person, AppString.name, data.custName),
        _buildCustomerInfoRow(
          AppIcon.call,
          AppString.phoneNumbar,
          data.custPhone,
        ),
        _buildCustomerInfoRow(
          AppIcon.location,
          AppString.address,
          data.address,
        ),
        SizedBox(height: Get.height * 0.02),
        Container(
          color: AppColor.lightBlue.withOpacity(0.5),
          padding: EdgeInsets.all(Get.width * 0.02),
          child: Text(
            AppString.nomineeDetail,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Get.width * 0.035,
            ),
          ),
        ),
        _buildCustomerInfoRow(AppIcon.person, AppString.name, "-"),
        _buildCustomerInfoRow(AppIcon.call, AppString.phoneNumbar, "-"),
        _buildCustomerInfoRow(AppIcon.flag, AppString.relation, "-"),
      ],
    );
  }

  Widget _buildCustomerInfoRow(IconData icon, String label, String? value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
      child: Row(
        children: [
          Icon(icon, color: AppColor.activeColor, size: Get.width * 0.05),
          SizedBox(width: Get.width * 0.02),
          Text(
            "$label :",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Get.width * 0.035,
            ),
          ),
          SizedBox(width: Get.width * 0.02),
          Expanded(
            child: Text(
              value ?? "-",
              style: TextStyle(fontSize: Get.width * 0.035),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionDetailsTab(data) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(Get.width * 0.04),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${AppString.givenAmt} : ${data.givenAmt}(${data.interest}%)",
                    style: TextStyle(fontSize: Get.width * 0.035),
                  ),
                  Text(
                    "${AppString.totint} : ${data.tillInterest}(${data.tillMonth} mon.)",
                    style: TextStyle(fontSize: Get.width * 0.035),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  data.tillDate ?? "",
                  style: TextStyle(
                    fontSize: Get.width * 0.025,
                    color: AppColor.boderSideColor,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${AppString.paidAmt} : ${data.totalPaidAmt}",
                    style: TextStyle(fontSize: Get.width * 0.035),
                  ),
                  Text(
                    "${AppString.paidint} : ${data.paidInterset}",
                    style: TextStyle(fontSize: Get.width * 0.035),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppString.date,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Get.width * 0.03,
                ),
              ),
              Text(
                AppString.muddal,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Get.width * 0.03,
                ),
              ),
              Text(
                AppString.interest,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Get.width * 0.03,
                ),
              ),
              Text(
                AppString.recIntAmt,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Get.width * 0.03,
                ),
              ),
              Text(
                AppString.cr,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Get.width * 0.03,
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        Center(
          child: Text(
            "No transaction history",
            style: TextStyle(fontSize: Get.width * 0.035),
          ),
        ),
      ],
    );
  }

  Widget _shimmerLoading() {
    return Shimmer.fromColors(
      baseColor: AppColor.boderSideColor[300]!,
      highlightColor: AppColor.boderSideColor[100]!,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(Get.width * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: Get.width * 0.3,
                  height: 20,
                  color: AppColor.textField,
                ),
                Container(
                  width: Get.width * 0.3,
                  height: 20,
                  color: AppColor.textField,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                3,
                (index) => Column(
                  children: [
                    CircleAvatar(radius: Get.width * 0.06),
                    SizedBox(height: 5),
                    Container(width: 40, height: 10, color: AppColor.textField),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
            child: Row(
              children: List.generate(
                4,
                (index) => Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    height: 30,
                    color: AppColor.textField,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(Get.width * 0.04),
              itemCount: 12,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Container(
                        width: Get.width * 0.06,
                        height: Get.width * 0.06,
                        color: AppColor.textField,
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Container(height: 15, color: AppColor.textField),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
