// ignore_for_file: deprecated_member_use, strict_top_level_inference, file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/ui/widget/drawerControllerUI.dart';
import 'package:rukmini/controller/api/controllers/drawer/home/customers/custDetail_Controller.dart';
import 'package:rukmini/modal/drawer/home/customer/customer_detail_model.dart';
import 'package:rukmini/modal/drawer/home/customer/customer_list_model.dart'
    as list;
import 'package:rukmini/view/utils/app_color.dart';
import 'package:rukmini/view/utils/app_icon.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/app_string.dart';
import 'package:rukmini/view/utils/app_url.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:rukmini/view/utils/widget/headingContainer.dart';
import 'package:rukmini/view/utils/widget/rukmini_alert_box.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class CustDetail extends StatefulWidget {
  const CustDetail({super.key});

  @override
  State<CustDetail> createState() => _CustDetailState();
}

class _CustDetailState extends State<CustDetail> {
  final custDetailController = Get.put(CustdetailController());
  late list.CustomerData customer;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final args = NavDrawerController.getRouteArguments(context);
      if (args is list.CustomerData) {
        customer = args;
        CallApi.callCustDetail(custId: customer.custId);
      }
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    custDetailController.dispose();
    super.dispose();
  }

  String? _getImageUrl(String? path, [String? fallbackPath]) {
    String? p = path;
    if (p == null || p == "null" || p.trim().isEmpty) {
      p = fallbackPath;
    }
    if (p == null || p == "null" || p.trim().isEmpty) {
      return null;
    }

    p = p.trim();
    if (p.startsWith('http://') || p.startsWith('https://')) {
      return p;
    }

    final String base = AppUrl.baseURL;
    if (base.endsWith('/') && p.startsWith('/')) {
      return "${base.substring(0, base.length - 1)}$p";
    } else if (!base.endsWith('/') && !p.startsWith('/')) {
      return "$base/$p";
    } else {
      return "$base$p";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Fullscreen(
      isPadding: false,
      backGroundcolor: AppColor.backgroundColor,
      appBar: appBar(
        back: true,
        title: AppString.customerDetail,
        edit: true,
        editOnPressed: () {
          final data = custDetailController.custDetailData.value.data;
          if (data != null) {
            NavDrawerController.toNamed('/updateCustForm', arguments: data);
          }
        },
        remove: true,
        deletOnPressed: () {
          RukminiAlertBox.show(
            icon: AppIcon.deleteIcon,
            iconColor: AppColor.deleteColor,
            title: AppString.deleteCustomer,
            message: AppString.deleteMessage,
            confirmText: AppString.delete,
            onConfirm: () async {
              await CallApi.callCustRemove(custId: customer.custId!);
              await CallApi.callCustList(isRefresh: true);
              NavDrawerController.back();
            },
          );
        },
      ),
      child: DefaultTabController(
        length: 4,
        child: Obx(() {
          if (custDetailController.isLoading.value) {
            return loadingState();
          }

          final data = custDetailController.custDetailData.value.data;

          if (data == null) {
            return Center(child: Text(AppString.noDetailsFound));
          }

          if (AppSize.isDesktop || AppSize.isTablet) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 360,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildProfileCard(data),
                        const SizedBox(height: 16),
                        _buildAccountSummaryCard(data),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 16,
                      right: 16,
                      bottom: 16,
                    ),
                    child: _buildRightTabsContent(data),
                  ),
                ),
              ],
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileCard(data),
                const SizedBox(height: 16),
                _buildAccountSummaryCard(data),
                const SizedBox(height: 16),
                SizedBox(height: 600, child: _buildRightTabsContent(data)),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildProfileCard(CustomerDetailData data) {
    final phoneStr = (data.phone != null && data.phone!.isNotEmpty)
        ? data.phone!.first.phone ?? ''
        : '';

    String? fullUrl = _getImageUrl(data.imagePath);
    fullUrl ??= _getImageUrl(customer.imagePath);
    fullUrl ??= _getImageUrl(customer.image);

    if (fullUrl == null && data.profile != null && data.profile!.isNotEmpty) {
      for (var prof in data.profile!) {
        fullUrl = _getImageUrl(prof.imagePath) ?? _getImageUrl(prof.image);
        if (fullUrl != null) break;
      }
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor.border),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(AppColor.isDark ? 0.3 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColor.goldTagBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColor.goldTagDot.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(AppIcon.star, size: 12, color: AppColor.goldTagDot),
                  SizedBox(width: 4),
                  Text(
                    AppString.vip,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColor.goldTagText,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  if (fullUrl != null) {
                    _showFullScreenImage(
                      context,
                      fullUrl,
                      data.name ?? AppString.profileImage,
                    );
                  }
                },
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColor.dashboardGold,
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.dashboardGold.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: fullUrl != null
                        ? Image.network(
                            fullUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  AppIcon.person,
                                  size: 50,
                                  color: AppColor.dashboardGold,
                                ),
                          )
                        : const Icon(
                            AppIcon.person,
                            size: 50,
                            color: AppColor.dashboardGold,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                data.name ?? AppString.noName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColor.mainText,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () {
                  if (data.custCode != null && data.custCode!.isNotEmpty) {
                    Clipboard.setData(ClipboardData(text: data.custCode!));
                    Get.snackbar(
                      AppString.copied,
                      AppString.customerCodeCopied,
                      backgroundColor: AppColor.cardBg,
                      colorText: AppColor.mainText,
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 2),
                    );
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.goldTagBg.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        data.custCode ?? "-",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColor.goldTagText,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        AppIcon.copy,
                        size: 14,
                        color: AppColor.goldTagText,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _buildStatusBadge(data.status),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCircularActionButton(
                    icon: AppIcon.call,
                    bgColor: AppColor.goldTagBg,
                    iconColor: AppColor.dashboardGold,
                    label: AppString.call,
                    onTap: () => _makeCall(phoneStr),
                  ),
                  _buildCircularActionButton(
                    icon: AppIcon.message,
                    bgColor: AppColor.goldTagBg,
                    iconColor: AppColor.dashboardGold,
                    label: AppString.message,
                    onTap: () => _sendSMS(phoneStr),
                  ),
                  _buildCircularActionButton(
                    icon: AppIcon.phone,
                    bgColor: AppColor.greenTagBg,
                    iconColor: AppColor.greenText,
                    label: AppString.whatsapp,
                    onTap: () => _launchWhatsApp(phoneStr),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircularActionButton({
    required IconData icon,
    required Color bgColor,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: iconColor.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColor.mainText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSummaryCard(CustomerDetailData data) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColor.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor.border),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(AppColor.isDark ? 0.3 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(AppIcon.report, color: AppColor.dashboardGold, size: 22),
              const SizedBox(width: 8),
              Text(
                AppString.accountSummary,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColor.mainText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _summaryRow(
            icon: AppIcon.rupee,
            bgColor: AppColor.goldTagBg,
            iconColor: AppColor.dashboardGold,
            label: AppString.gvnAmt,
            value: "₹ ${data.totalGivenAmt ?? 0.00}",
          ),
          const SizedBox(height: 10),
          _summaryRow(
            icon: AppIcon.accessTime,
            bgColor: AppColor.orangeLightBg,
            iconColor: AppColor.orangeText,
            label: AppString.pendingAmt,
            value: "₹ ${data.gracePeriod ?? '0.00'}",
          ),
          const SizedBox(height: 10),
          _summaryRow(
            icon: AppIcon.receipt,
            bgColor: AppColor.blueTagBg,
            iconColor: AppColor.blueTagText,
            label: AppString.totalTransactions,
            value: "${data.girviList?.length ?? 0}",
          ),
        ],
      ),
    );
  }

  Widget _summaryRow({
    required IconData icon,
    required Color bgColor,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColor.tableBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.border),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: AppColor.subText,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColor.mainText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightTabsContent(CustomerDetailData data) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor.border),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(AppColor.isDark ? 0.3 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColor.tableBg,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              border: Border(bottom: BorderSide(color: AppColor.border)),
            ),
            child: TabBar(
              labelColor: AppColor.dashboardGold,
              unselectedLabelColor: AppColor.subText,
              indicatorColor: AppColor.dashboardGold,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: AppColor.transparent,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              tabs: const [
                Tab(
                  child: Row(
                    children: [
                      Icon(AppIcon.person, size: 18),
                      SizedBox(width: 6),
                      Text(
                        AppString.customerDetails,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    children: [
                      Icon(AppIcon.balance, size: 18),
                      SizedBox(width: 6),
                      Text(
                        AppString.girviDetails,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    children: [
                      Icon(AppIcon.swap, size: 18),
                      SizedBox(width: 6),
                      Text(
                        AppString.transactionDetails,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    children: [
                      Icon(AppIcon.description, size: 18),
                      SizedBox(width: 6),
                      Text(
                        AppString.identiyProof,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _buildCustomerDetailsTab(data),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _buildGirviDetailsTab(data),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _buildTransactionDetailsTab(data),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: identityProofTab(data),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerDetailsTab(CustomerDetailData data) {
    final custTypes = data.custType ?? [];
    final phones = data.phone ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCardSection(
          icon: AppIcon.person,
          title: AppString.basicInformation,
          child: Column(
            children: [
              _buildInfoRowPair(
                icon1: AppIcon.badge,
                label1: AppString.custCode,
                value1: data.custCode ?? "-",
                isCopyable1: true,
                icon2: AppIcon.location,
                label2: AppString.branch,
                value2: "Pandesara",
              ),
              Divider(height: 1, color: AppColor.border),
              _buildInfoRowPair(
                icon1: AppIcon.person,
                label1: AppString.name,
                value1: data.name ?? "-",
                icon2: AppIcon.group,
                label2: AppString.type,
                value2: custTypes.isNotEmpty
                    ? custTypes.first.typeName ?? "Regular"
                    : "Regular",
              ),
              Divider(height: 1, color: AppColor.border),
              _buildInfoRowPair(
                icon1: AppIcon.wc,
                label1: AppString.gender,
                value1: data.gender ?? "Male",
                icon2: AppIcon.calendar,
                label2: AppString.createdOn,
                value2: "24 Nov 2026",
              ),
              Divider(height: 1, color: AppColor.border),
              _buildInfoRowPair(
                icon1: AppIcon.checkCircle,
                label1: AppString.status,
                value1Widget: _buildStatusBadge(data.status),
                icon2: AppIcon.calendar,
                label2: AppString.updatedOn,
                value2: "24 Nov 2026",
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        if (data.address != null && data.address!.isNotEmpty) ...[
          _buildCardSection(
            icon: AppIcon.location,
            title: AppString.address,
            child: Row(
              children: [
                const Icon(
                  AppIcon.location,
                  color: AppColor.dashboardGold,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    data.address!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColor.mainText,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColor.goldTagBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    AppIcon.map,
                    color: AppColor.dashboardGold,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        _buildCardSection(
          icon: AppIcon.phone,
          title: AppString.phoneNumbar,
          child: Column(
            children: [
              if (phones.isEmpty)
                Text(
                  AppString.noPhoneNumbersAvailable,
                  style: TextStyle(color: AppColor.subText),
                )
              else
                ...phones.map(
                  (p) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColor.goldTagBg,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            AppIcon.phone,
                            color: AppColor.dashboardGold,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          p.phone ?? "-",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColor.mainText,
                          ),
                        ),
                        const SizedBox(width: 10),
                        if (p.isDefault == "1")
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColor.goldTagBg,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              AppString.defaultLabel,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColor.goldTagText,
                              ),
                            ),
                          ),
                        const Spacer(),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            AppIcon.add,
                            size: 14,
                            color: AppColor.dashboardGold,
                          ),
                          label: const Text(
                            AppString.addNumber,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColor.dashboardGold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: AppColor.dashboardGold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
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
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        if (custTypes.isNotEmpty) ...[
          _buildCardSection(
            icon: AppIcon.group,
            title: AppString.customerTypes,
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: custTypes.map((t) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.cardBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColor.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        AppIcon.group,
                        size: 16,
                        color: AppColor.dashboardGold,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        t.typeName ?? "Regular",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColor.mainText,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildStatusBadge(t.status),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
        ],

        if (data.nominee != null) ...[
          _buildCardSection(
            icon: AppIcon.verifiedUser,
            title: AppString.nomineeInformation,
            child: Column(
              children: [
                _buildInfoRowPair(
                  icon1: AppIcon.person,
                  label1: AppString.nomineeName,
                  value1: data.nominee!.name ?? "-",
                  icon2: AppIcon.group,
                  label2: AppString.customerRelation,
                  value2: data.nominee!.custRelation ?? "-",
                ),
                if (data.nominee!.phone != null) ...[
                  Divider(height: 1, color: AppColor.border),
                  _buildInfoRowPair(
                    icon1: AppIcon.phone,
                    label1: AppString.phone,
                    value1: data.nominee!.phone!,
                    label2: "",
                    value2: "",
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        _buildCardSection(
          icon: AppIcon.editNote,
          title: AppString.notes,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  AppString.defaultNotes,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColor.mainText,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  AppIcon.editIcon,
                  color: AppColor.dashboardGold,
                  size: 18,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGirviDetailsTab(CustomerDetailData data) {
    final girviList = data.girviList ?? [];
    if (girviList.isEmpty) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        child: Text(
          AppString.noGirviRecordsFound,
          style: TextStyle(fontSize: 15, color: AppColor.grey500),
        ),
      );
    }

    return Column(
      children: girviList.map((girvi) => girviDetail(girvi: girvi)).toList(),
    );
  }

  Widget _buildTransactionDetailsTab(CustomerDetailData data) {
    final girviList = data.girviList ?? [];
    if (girviList.isEmpty) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        child: Text(
          AppString.noGirviRecordsFound,
          style: TextStyle(fontSize: 15, color: AppColor.grey500),
        ),
      );
    }

    return Column(
      children: girviList
          .map((girvi) => translationDetail(girvi: girvi))
          .toList(),
    );
  }

  Widget _buildCardSection({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColor.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColor.dashboardGold, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColor.mainText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRowPair({
    IconData? icon1,
    required String label1,
    String? value1,
    Widget? value1Widget,
    bool isCopyable1 = false,
    IconData? icon2,
    required String label2,
    String? value2,
    Widget? value2Widget,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (icon1 != null) ...[
                      Icon(icon1, size: 15, color: AppColor.dashboardGold),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      label1,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColor.subText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                value1Widget ??
                    Row(
                      children: [
                        Text(
                          value1 ?? "-",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColor.mainText,
                          ),
                        ),
                        if (isCopyable1 &&
                            value1 != null &&
                            value1.isNotEmpty) ...[
                          const SizedBox(width: 6),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: value1));
                              Get.snackbar(
                                AppString.copied,
                                "$label1 copied to clipboard",
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            },
                            child: const Icon(
                              AppIcon.copy,
                              size: 14,
                              color: AppColor.dashboardGold,
                            ),
                          ),
                        ],
                      ],
                    ),
              ],
            ),
          ),
          if (label2.isNotEmpty)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (icon2 != null) ...[
                        Icon(icon2, size: 15, color: AppColor.dashboardGold),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        label2,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColor.subText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  value2Widget ??
                      Text(
                        value2 ?? "-",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColor.mainText,
                        ),
                      ),
                ],
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(AppIcon.checkCircle, size: 13, color: textColor),
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

  Widget identityProofTab(CustomerDetailData data) {
    final bool isDesktopOrTablet = AppSize.isDesktop || AppSize.isTablet;
    return SingleChildScrollView(
      child: Column(
        children: [
          if (data.proof != null && data.proof!.isNotEmpty) ...[
            headingContainer(AppString.identiyProof),
            ...data.proof!.map((proof) {
              final proofUrl = _getImageUrl(proof.imagePath, proof.image);
              return Card(
                color: AppColor.white,
                margin: EdgeInsets.symmetric(vertical: AppSize.p4),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        proof.name ?? '',
                        style: TextStyle(
                          fontSize: isDesktopOrTablet
                              ? 15.0
                              : AppSize.commonText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        proof.status ?? '',
                        style: TextStyle(
                          fontSize: isDesktopOrTablet
                              ? 13.0
                              : AppSize.smallText,
                        ),
                      ),
                      leading: const Icon(
                        AppIcon.verifiedUser,
                        color: AppColor.activeColor,
                      ),
                    ),
                    if (proofUrl != null)
                      GestureDetector(
                        onTap: () {
                          _showFullScreenImage(
                            context,
                            proofUrl,
                            proof.name ?? AppString.proofImage,
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.all(AppSize.p8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppSize.p8),
                            child: Image.network(
                              proofUrl,
                              width: double.infinity,
                              height: AppSize.height * 0.25,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  AppIcon.brokenImage,
                                  size: AppSize.iconLarge * 1.5,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ],
          if (data.profile != null && data.profile!.isNotEmpty) ...[
            headingContainer(AppString.profilePhotos),
            ...data.profile!.map((profile) {
              final profileUrl = _getImageUrl(profile.imagePath, profile.image);
              return Card(
                color: AppColor.white,
                margin: EdgeInsets.symmetric(vertical: AppSize.p4),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        profile.name ?? '',
                        style: TextStyle(
                          fontSize: isDesktopOrTablet
                              ? 15.0
                              : AppSize.commonText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        profile.status ?? '',
                        style: TextStyle(
                          fontSize: isDesktopOrTablet
                              ? 13.0
                              : AppSize.smallText,
                        ),
                      ),
                      leading: const Icon(
                        AppIcon.personPin,
                        color: AppColor.activeColor,
                      ),
                    ),
                    if (profileUrl != null)
                      GestureDetector(
                        onTap: () => _showFullScreenImage(
                          context,
                          profileUrl,
                          profile.name ?? AppString.profileImage,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(AppSize.p8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: isDesktopOrTablet
                                    ? 100
                                    : AppSize.width * 0.25,
                                height: isDesktopOrTablet
                                    ? 140
                                    : AppSize.width * 0.45,
                                decoration: BoxDecoration(
                                  color: AppColor.grey200,
                                  borderRadius: BorderRadius.circular(
                                    AppSize.p10,
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(profileUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(width: AppSize.p16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      profile.name ?? '',
                                      style: TextStyle(
                                        fontSize: isDesktopOrTablet
                                            ? 15.0
                                            : AppSize.p16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: AppSize.p4),
                                    Text(
                                      profile.status ?? '',
                                      style: TextStyle(
                                        color: AppColor.textColor,
                                        fontSize: isDesktopOrTablet
                                            ? 13.0
                                            : AppSize.size14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: AppSize.p4),
                                    Text(
                                      "${AppString.idColon}${profile.custId ?? ''}",
                                      style: TextStyle(
                                        color: AppColor.activeColor,
                                        fontSize: isDesktopOrTablet
                                            ? 13.0
                                            : AppSize.size14,
                                        fontWeight: FontWeight.w600,
                                      ),
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
            }),
          ],
          if ((data.proof == null || data.proof!.isEmpty) &&
              (data.profile == null || data.profile!.isEmpty))
            Container(
              margin: EdgeInsets.symmetric(vertical: AppSize.p16),
              padding: EdgeInsets.all(AppSize.p8),
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
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSize.p20),
                  child: Text(AppString.noIdentityProofsFound),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showFullScreenImage(
    BuildContext context,
    String imageUrl,
    String title,
  ) {
    final fullUrl = _getImageUrl(imageUrl) ?? imageUrl;
    Get.to(
      () => Scaffold(
        backgroundColor: AppColor.black,
        appBar: AppBar(
          backgroundColor: AppColor.black,
          iconTheme: const IconThemeData(color: AppColor.white),
          title: Text(title, style: const TextStyle(color: AppColor.white)),
        ),
        body: Center(
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 0.5,
            maxScale: 4.0,
            child: Image.network(
              fullUrl,
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(
                  AppIcon.brokenImage,
                  color: AppColor.white,
                  size: 100,
                ),
              ),
            ),
          ),
        ),
      ),
      fullscreenDialog: true,
    );
  }

  Widget girviDetail({required Girvi girvi}) {
    return Card(
      elevation: 0,
      color: AppColor.cardBg,
      margin: EdgeInsets.only(bottom: AppSize.p8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.p16 - 1),
        side: BorderSide(color: AppColor.border),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(AppSize.p12),
        child: Row(
          children: [
            _horizontalDetailBlock(
              AppIcon.fingerprint,
              AppString.uniqueId,
              girvi.uniqueId ?? '',
            ),
            _horizontalDetailBlock(
              AppIcon.date,
              AppString.girviDate,
              girvi.girviDate ?? '',
            ),
            _horizontalDetailBlock(
              AppIcon.rupee,
              AppString.givenAmt,
              girvi.givenAmt ?? '',
            ),
            _horizontalDetailBlock(
              AppIcon.wallet,
              AppString.balance,
              girvi.balance?.toString() ?? '',
            ),
            _horizontalDetailBlock(
              AppIcon.person,
              AppString.name,
              girvi.custName ?? '',
            ),
            _horizontalDetailBlock(
              AppIcon.phone,
              AppString.phone,
              girvi.custPhone ?? '',
            ),
          ],
        ),
      ),
    );
  }

  Widget translationDetail({required Girvi girvi}) {
    return Card(
      elevation: 0,
      color: AppColor.white,
      margin: EdgeInsets.only(bottom: AppSize.p8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.p16 - 1),
        side: BorderSide(color: AppColor.grey300),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(AppSize.p12),
        child: Row(
          children: [
            _horizontalDetailBlock(
              AppIcon.fingerprint,
              AppString.uniqueId,
              girvi.uniqueId ?? '',
            ),
            _horizontalDetailBlock(
              AppIcon.rupee,
              AppString.givenAmt,
              girvi.givenAmt ?? '',
            ),
            _horizontalDetailBlock(
              AppIcon.payment,
              AppString.paidAmt,
              girvi.totalPaidAmt?.toString() ?? '',
            ),
            _horizontalDetailBlock(
              AppIcon.trend,
              AppString.totint,
              girvi.tillInterest?.toString() ?? '',
            ),
            _horizontalDetailBlock(
              AppIcon.checkCircle,
              AppString.paidInt,
              girvi.paidInterset ?? '',
            ),
          ],
        ),
      ),
    );
  }

  Widget _horizontalDetailBlock(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    final bool isDesktopOrTablet = AppSize.isDesktop || AppSize.isTablet;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSize.p12),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: AppColor.grey300,
            width: AppSize.width * 0.0012,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColor.goldColor,
                size: isDesktopOrTablet ? 16.0 : AppSize.iconSmall,
              ),
              SizedBox(width: AppSize.p4),
              Text(
                label,
                style: TextStyle(
                  fontSize: isDesktopOrTablet ? 12.0 : AppSize.extraSmallText,
                  color: AppColor.textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.p4),
          Text(
            value,
            style: TextStyle(
              fontSize: isDesktopOrTablet ? 14.0 : AppSize.commonText,
              fontWeight: FontWeight.bold,
              color: valueColor ?? AppColor.mainText,
            ),
          ),
        ],
      ),
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
}

Widget loadingState() {
  return Shimmer.fromColors(
    baseColor: AppColor.isDark ? const Color(0xFF1E293B) : AppColor.grey300,
    highlightColor: AppColor.isDark ? const Color(0xFF334155) : AppColor.white,
    child: Padding(
      padding: EdgeInsets.all(AppSize.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: AppColor.cardBg,
              borderRadius: BorderRadius.circular(AppSize.p20),
            ),
          ),
          SizedBox(height: AppSize.p16),
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: AppColor.cardBg,
              borderRadius: BorderRadius.circular(AppSize.p10),
            ),
          ),
          SizedBox(height: AppSize.p16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.cardBg,
                borderRadius: BorderRadius.circular(AppSize.p20),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
