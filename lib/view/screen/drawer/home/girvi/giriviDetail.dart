// ignore_for_file: file_names, strict_top_level_inference, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/drawer/home/girvi/giriviDetail_Controller.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:rukmini/view/utils/widget/horizontalPadding.dart';
import 'package:url_launcher/url_launcher.dart';

class GiriviDetail extends StatefulWidget {
  const GiriviDetail({super.key});

  @override
  State<GiriviDetail> createState() => _GiriviDetailState();
}

class _GiriviDetailState extends State<GiriviDetail> {
  final giriviDetailController = Get.put(GiriviDetailController());
  late String girviId;
  final ScrollController _girviScrollController = ScrollController();
  final ScrollController _custScrollController = ScrollController();

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
  void dispose() {
    _girviScrollController.dispose();
    _custScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Fullscreen(
        isPadding: false,
        backGroundcolor: AppColor.backgroundColor,
        appBar: appBar(
          centerTitle: true,
          title: Obx(() {
            final data = giriviDetailController.giriviDetailData.value.data;
            bool isOpen = data?.isClosed != "1";
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Text(
                //   AppString.girviDetail.toUpperCase(),
                //   style: TextStyle(
                //     color: AppColor.black,
                //     fontSize: AppSize.titleText,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                SizedBox(width: AppSize.p8),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.p10,
                    vertical: AppSize.p4,
                  ),
                  decoration: BoxDecoration(
                    color: isOpen
                        ? AppColor.activeColor.withOpacity(0.1)
                        : AppColor.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSize.p10),
                  ),
                  child: Text(
                    isOpen ? AppString.open : AppString.closed,
                    style: TextStyle(
                      color: isOpen ? AppColor.activeColor : AppColor.red,
                      fontSize: AppSize.size12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          }),
          back: true,
          edit: true,
          close: true,
          remove: true,
          editOnPressed: () => Get.toNamed('/giriviadd'),
          closeOnPressed: () => CallApi.callCloseGirvie(girviId: girviId),
          deletOnPressed: () => CallApi.callRemoveGirvie(girviId: girviId),
        ),
        child: Obx(() {
          if (giriviDetailController.isLoading.value) {
            return _shimmerLoading();
          }

          final data = giriviDetailController.giriviDetailData.value.data;

          if (data == null) {
            return Center(child: Text(AppString.noDataFound));
          }

          return Column(
            children: [
              horizontalPadding(
                child: Column(
                  children: [
                    _buildTopHeader(data),
                    SizedBox(height: AppSize.p16),
                    _buildActionButtons(data),
                    SizedBox(height: AppSize.p16),
                  ],
                ),
              ),
              TabBar(
                labelColor: AppColor.goldColor,
                unselectedLabelColor: AppColor.textColor,
                indicatorColor: AppColor.goldColor,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: AppColor.grey300.withOpacity(0.5),
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                tabs: [
                  Tab(
                    child: Text(
                      AppString.girviDetails.toUpperCase(),
                      style: TextStyle(
                        fontSize: AppSize.size12 * 1.2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      AppString.productDetail.toUpperCase(),
                      style: TextStyle(
                        fontSize: AppSize.size12 * 1.2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      AppString.customerDetails.toUpperCase(),
                      style: TextStyle(
                        fontSize: AppSize.size12 * 1.2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildGirviDetailsTab(data),
                    _buildProductDetailTab(data),
                    _buildCustomerDetailsTab(data),
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
    return Container(
      margin: EdgeInsets.only(top: AppSize.p16),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              label: AppString.girviId,
              value: data.uniqueId ?? 'N/A',
              icon: AppIcon.badge,
            ),
          ),
          SizedBox(width: AppSize.p12),
          Expanded(
            child: _buildSummaryCard(
              label: AppString.pendingAmt,
              value: data.balance?.toString() ?? '0',
              icon: AppIcon.rupee,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(AppSize.p16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(AppSize.p20),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.05),
            blurRadius: AppSize.p10,
            offset: Offset(0, AppSize.p4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSize.p10),
            decoration: BoxDecoration(
              color: AppColor.whiteOrang.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColor.goldColor, size: AppSize.p24),
          ),
          SizedBox(width: AppSize.p12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: AppSize.smallText,
                    color: AppColor.textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: AppSize.commonText,
                    fontWeight: FontWeight.bold,
                    color: AppColor.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(data) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppSize.p16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(AppSize.p20),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.05),
            blurRadius: AppSize.p10,
            offset: Offset(0, AppSize.p4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionButton(
            AppIcon.call,
            AppString.call,
            () => _makeCall(data.custPhone ?? ''),
          ),
          _buildActionButton(
            AppIcon.message,
            AppString.message,
            () => _sendSMS(data.custPhone ?? ''),
          ),
          _buildActionButton(
            AppIcon.whatsapp,
            AppString.whatsapp,
            () => _launchWhatsApp(data.custPhone ?? ''),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(AppSize.p12),
            decoration: BoxDecoration(
              color: AppColor.primaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColor.black.withOpacity(0.1),
                  blurRadius: AppSize.p4,
                  offset: Offset(0, AppSize.p4 / 2),
                ),
              ],
            ),
            child: Icon(icon, color: AppColor.goldColor, size: AppSize.p24),
          ),
          SizedBox(height: AppSize.p8),
          Text(
            label,
            style: TextStyle(
              fontSize: AppSize.mediumText,
              color: AppColor.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGirviDetailsTab(data) {
    return SingleChildScrollView(
      child: horizontalPadding(
        child: Scrollbar(
          controller: _girviScrollController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _girviScrollController,
            scrollDirection: Axis.horizontal,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: AppSize.p16),
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(AppSize.p20),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.black.withOpacity(0.05),
                    blurRadius: AppSize.p10,
                    offset: Offset(0, AppSize.p4),
                  ),
                ],
              ),
              child: Column(
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
                  _buildInfoRow(
                    AppIcon.rupee,
                    AppString.gvnAmt,
                    data.givenAmt ?? "",
                  ),
                  _buildInfoRow(
                    AppIcon.percent,
                    AppString.intRate,
                    "${data.interest}%",
                  ),
                  _buildInfoRow(
                    AppIcon.calendar,
                    AppString.duration,
                    "${data.givenMonth} ${AppString.month}",
                  ),
                  _buildInfoRow(
                    AppIcon.calendar,
                    AppString.dueDate,
                    data.dueDate ?? "",
                  ),
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
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppSize.p12,
            horizontal: AppSize.p16,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(AppSize.p8),
                decoration: BoxDecoration(
                  color: AppColor.whiteOrang.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: AppColor.goldColor,
                  size: AppSize.p20 - 2,
                ),
              ),
              SizedBox(width: AppSize.p16),
              SizedBox(
                width: AppSize.width * 0.35,
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppSize.commonText,
                    color: AppColor.black,
                  ),
                ),
              ),
              const Text(" : ", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(
                width: AppSize.width * 0.45,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: AppSize.commonText,
                    color: AppColor.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
          thickness: 0.5,
          color: AppColor.grey300.withOpacity(0.5),
          indent: AppSize.p16,
          endIndent: AppSize.p16,
        ),
      ],
    );
  }

  Widget _buildProductDetailTab(data) {
    if (data.productDetail == null || data.productDetail.isEmpty) {
      return Center(
        child: Text(
          AppString.noProductsFound,
          style: TextStyle(fontSize: AppSize.commonText),
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: AppSize.p16),
      itemCount: data.productDetail.length,
      itemBuilder: (context, index) {
        final product = data.productDetail[index];
        return horizontalPadding(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              margin: EdgeInsets.only(bottom: AppSize.p12),
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(AppSize.p20),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.black.withOpacity(0.05),
                    blurRadius: AppSize.p10,
                    offset: Offset(0, AppSize.p4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildInfoRow(
                    AppIcon.category,
                    AppString.proTyp,
                    product.prodType ?? "-",
                  ),
                  _buildInfoRow(
                    AppIcon.metal,
                    AppString.metal,
                    product.metalName ?? "-",
                  ),
                  _buildInfoRow(
                    AppIcon.weight,
                    AppString.pcs,
                    "${product.pieces ?? '0'} (${product.weight ?? '0'}gm)",
                  ),
                  _buildInfoRow(
                    AppIcon.rupee,
                    AppString.origPrice,
                    product.origAmount?.toString() ?? "0",
                  ),
                  _buildInfoRow(
                    AppIcon.trend,
                    AppString.rate,
                    product.todayRate?.toString() ?? "0",
                  ),
                  _buildInfoRow(
                    AppIcon.locker,
                    AppString.locker,
                    (product.lockerList != null &&
                            product.lockerList!.isNotEmpty)
                        ? product.lockerList!.first.lockerCode ?? '-'
                        : '-',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomerDetailsTab(data) {
    return SingleChildScrollView(
      child: Column(
        children: [
          horizontalPadding(
            child: Scrollbar(
              controller: _custScrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _custScrollController,
                scrollDirection: Axis.horizontal,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: AppSize.p16),
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(AppSize.p20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.black.withOpacity(0.05),
                        blurRadius: AppSize.p10,
                        offset: Offset(0, AppSize.p4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _sectionHeader(AppString.customerDetails, AppIcon.person),
                      Padding(
                        padding: EdgeInsets.all(AppSize.p16),
                        child: Column(
                          children: [
                            _buildInfoRowSimple(
                              AppIcon.person,
                              AppString.name,
                              data.custName ?? "-",
                            ),
                            _buildInfoRowSimple(
                              AppIcon.phone,
                              AppString.phoneNumbar,
                              data.custPhone ?? "-",
                            ),
                            _buildInfoRowSimple(
                              AppIcon.location,
                              AppString.address,
                              data.address ?? "-",
                            ),
                          ],
                        ),
                      ),
                      _sectionHeader(AppString.nomineeDetail, AppIcon.person),
                      Padding(
                        padding: EdgeInsets.all(AppSize.p16),
                        child: Column(
                          children: [
                            _buildInfoRowSimple(
                              AppIcon.person,
                              AppString.name,
                              "-",
                            ),
                            _buildInfoRowSimple(
                              AppIcon.phone,
                              AppString.phoneNumbar,
                              "-",
                            ),
                            _buildInfoRowSimple(
                              AppIcon.verifiedUser,
                              AppString.customerRelation,
                              "-",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRowSimple(IconData icon, String label, String value) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: AppSize.p8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColor.goldColor, size: AppSize.iconSmall),
              SizedBox(width: AppSize.p16),
              SizedBox(
                width: AppSize.width * 0.35,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: AppSize.commonText,
                    color: AppColor.black,
                  ),
                ),
              ),
              const Text(" : ", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(
                width: AppSize.width * 0.45,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: AppSize.commonText,
                    color: AppColor.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
          thickness: 0.5,
          color: AppColor.grey300.withOpacity(0.5),
        ),
      ],
    );
  }

  Widget _sectionHeader(String title, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.p16,
        vertical: AppSize.p12,
      ),
      decoration: BoxDecoration(
        color: AppColor.whiteOrang.withOpacity(0.3),
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSize.p20)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSize.p8),
            decoration: BoxDecoration(
              color: AppColor.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColor.goldColor.withOpacity(0.1),
                  blurRadius: AppSize.p4,
                ),
              ],
            ),
            child: Icon(icon, color: AppColor.goldColor, size: AppSize.p20 - 2),
          ),
          SizedBox(width: AppSize.p12),
          Text(
            title,
            style: TextStyle(
              fontSize: AppSize.headingText,
              fontWeight: FontWeight.bold,
              color: AppColor.black,
            ),
          ),
          const Spacer(),
          Icon(
            AppIcon.leaf,
            color: AppColor.goldColor.withOpacity(0.1),
            size: AppSize.iconLarge,
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _buildTransactionDetailsTab(data) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(AppSize.p16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${AppString.givenAmt} : ${data.givenAmt}(${data.interest}%)",
                    style: TextStyle(fontSize: AppSize.commonText),
                  ),
                  Text(
                    "${AppString.totint} : ${data.tillInterest}(${data.tillMonth} mon.)",
                    style: TextStyle(fontSize: AppSize.commonText),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  data.tillDate ?? "",
                  style: TextStyle(
                    fontSize: AppSize.smallText,
                    color: AppColor.grey300,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${AppString.paidAmt} : ${data.totalPaidAmt}",
                    style: TextStyle(fontSize: AppSize.commonText),
                  ),
                  Text(
                    "${AppString.paidint} : ${data.paidInterset}",
                    style: TextStyle(fontSize: AppSize.commonText),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(color: AppColor.grey300.withOpacity(0.5)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.p16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppString.date,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppSize.smallText,
                ),
              ),
              Text(
                AppString.muddal,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppSize.smallText,
                ),
              ),
              Text(
                AppString.interest,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppSize.smallText,
                ),
              ),
              Text(
                AppString.recIntAmt,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppSize.smallText,
                ),
              ),
              Text(
                AppString.cr,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppSize.smallText,
                ),
              ),
            ],
          ),
        ),
        Divider(color: AppColor.grey300.withOpacity(0.5)),
        Center(
          child: Text(
            AppString.noTransactionHistory,
            style: TextStyle(fontSize: AppSize.commonText),
          ),
        ),
      ],
    );
  }

  Future<void> _makeCall(String phoneNumber) async {
    if (phoneNumber.isEmpty) return;
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    await launchUrl(launchUri);
  }

  Future<void> _sendSMS(String phoneNumber) async {
    if (phoneNumber.isEmpty) return;
    final Uri launchUri = Uri(scheme: 'sms', path: phoneNumber);
    await launchUrl(launchUri);
  }

  Future<void> _launchWhatsApp(String phoneNumber) async {
    if (phoneNumber.isEmpty) return;
    String cleanNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');
    if (!cleanNumber.startsWith('91') && cleanNumber.length == 10) {
      cleanNumber = '91$cleanNumber';
    }
    final String url = "https://wa.me/$cleanNumber";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  Widget _shimmerLoading() {
    return Shimmer.fromColors(
      baseColor: AppColor.grey300,
      highlightColor: AppColor.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Header Card Shimmer
            horizontalPadding(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: AppSize.p16),
                height: AppSize.height * 0.12,
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(AppSize.p20),
                ),
              ),
            ),
            // Actions Row Shimmer
            horizontalPadding(
              child: Container(
                height: AppSize.height * 0.1,
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(AppSize.p20),
                ),
              ),
            ),
            SizedBox(height: AppSize.p16),
            // TabBar Shimmer
            horizontalPadding(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  3,
                  (index) => Container(
                    width: AppSize.width * 0.25,
                    height: AppSize.p40 - 5,
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(AppSize.p8),
                    ),
                  ),
                ),
              ),
            ),
            // Content Card Shimmer
            horizontalPadding(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: AppSize.p16),
                height: AppSize.height * 0.5,
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(AppSize.p20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
