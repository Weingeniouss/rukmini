// ignore_for_file: deprecated_member_use, strict_top_level_inference, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/drawer/home/customers/custDetail_Controller.dart';
import 'package:rukmini/modal/drawer/home/customer/customer_detail_model.dart';
import 'package:rukmini/modal/drawer/home/customer/customer_list_model.dart'
    as list;
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:rukmini/view/utils/widget/headingContainer.dart';
import 'package:rukmini/view/utils/widget/horizontalPadding.dart';
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

  @override
  void initState() {
    super.initState();
    customer = Get.arguments as list.CustomerData;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CallApi.callCustDetail(custId: customer.custId);
    });
  }

  @override
  void dispose() {
    custDetailController.dispose();
    super.dispose();
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
            Get.toNamed('/updateCustForm', arguments: data);
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
              Get.back();
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

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              horizontalPadding(
                child: heddingData(
                  name: data.name ?? '',
                  custcode: data.custCode ?? '',
                  totalGivenAmt: data.totalGivenAmt.toString(),
                  gracePeriod: data.gracePeriod.toString(),
                  phone: (data.phone != null && data.phone!.isNotEmpty)
                      ? data.phone!.first.phone ?? ''
                      : '',
                ),
              ),
              Expanded(child: tabBar(data)),
            ],
          );
        }),
      ),
    );
  }

  Widget tabBarHedings(String text, {bool showDivider = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSize.p8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: AppSize.size14,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (showDivider) ...[
            SizedBox(width: AppSize.p12),
            Container(height: AppSize.p20, width: 1, color: AppColor.grey300),
          ],
        ],
      ),
    );
  }

  Widget tabBar(CustomerDetailData data) {
    return Column(
      children: [
        horizontalPadding(
          child: TabBar(
            labelColor: AppColor.goldColor,
            unselectedLabelColor: AppColor.textColor,
            indicatorColor: AppColor.goldColor,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: AppColor.grey300,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(
                child: tabBarHedings(
                  AppString.customerDetails,
                  showDivider: true,
                ),
              ),
              Tab(
                child: tabBarHedings(AppString.girviDetails, showDivider: true),
              ),
              Tab(
                child: tabBarHedings(
                  AppString.transactionDetails,
                  showDivider: true,
                ),
              ),
              Tab(
                child: tabBarHedings(
                  AppString.identiyProof,
                  showDivider: false,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            children: [
              // Customer Details Tab
              SingleChildScrollView(
                child: horizontalPadding(
                  child: customerDetails(
                    address: data.address ?? '',
                    gender: data.gender ?? '',
                    status: data.status ?? '',
                    gracePeriod: data.gracePeriod ?? '',
                    phone: data.phone ?? <Phone>[],
                    custType: data.custType ?? <CustType>[],
                    nomineeName: data.nominee?.name ?? '',
                    nomineephoneNumbar: data.nominee?.phone ?? '',
                    nomineeRelation: data.nominee?.custRelation ?? '',
                  ),
                ),
              ),
              // Girvi Details
              SingleChildScrollView(
                child: horizontalPadding(
                  child: Container(
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
                    child: Column(
                      children: [
                        if (data.girviList == null || data.girviList!.isEmpty)
                          Padding(
                            padding: EdgeInsets.all(AppSize.p20),
                            child: Center(
                              child: Text(AppString.noGirviRecordsFound),
                            ),
                          )
                        else
                          ...data.girviList!.map(
                            (girvi) => girviDetail(girvi: girvi),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              //Transaction Details
              SingleChildScrollView(
                child: horizontalPadding(
                  child: Container(
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
                    child: Column(
                      children: [
                        if (data.girviList == null || data.girviList!.isEmpty)
                          Padding(
                            padding: EdgeInsets.all(AppSize.p20),
                            child: Center(
                              child: Text(AppString.noGirviRecordsFound),
                            ),
                          )
                        else
                          ...data.girviList!.map(
                            (girvi) => translationDetail(girvi: girvi),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              //Identity Proof Tab
              horizontalPadding(child: identityProofTab(data)),
            ],
          ),
        ),
      ],
    );
  }

  Widget identityProofTab(CustomerDetailData data) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (data.proof != null && data.proof!.isNotEmpty) ...[
            headingContainer(AppString.identiyProof),
            ...data.proof!.map(
              (proof) => Card(
                color: AppColor.white,
                margin: EdgeInsets.symmetric(vertical: AppSize.p4),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(proof.name ?? ''),
                      subtitle: Text(proof.status ?? ''),
                      leading: const Icon(
                        AppIcon.verifiedUser,
                        color: AppColor.activeColor,
                      ),
                    ),
                    if (proof.imagePath != null)
                      GestureDetector(
                        onTap: () {
                          _showFullScreenImage(
                            context,
                            proof.imagePath!,
                            proof.name ?? AppString.proofImage,
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.all(AppSize.p8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppSize.p8),
                            child: Image.network(
                              proof.imagePath!,
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
              ),
            ),
          ],
          if (data.profile != null && data.profile!.isNotEmpty) ...[
            headingContainer(AppString.profilePhotos),
            ...data.profile!.map(
              (profile) => Card(
                color: AppColor.white,
                margin: EdgeInsets.symmetric(vertical: AppSize.p4),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(profile.name ?? ''),
                      subtitle: Text(profile.status ?? ''),
                      leading: const Icon(
                        AppIcon.personPin,
                        color: AppColor.activeColor,
                      ),
                    ),
                    if (profile.imagePath != null)
                      GestureDetector(
                        onTap: () => _showFullScreenImage(
                          context,
                          profile.imagePath!,
                          profile.name ?? AppString.profileImage,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(AppSize.p8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: AppSize.width * 0.25,
                                height: AppSize.width * 0.45,
                                decoration: BoxDecoration(
                                  color: AppColor.grey200,
                                  borderRadius: BorderRadius.circular(
                                    AppSize.p10,
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(profile.imagePath!),
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
                                        fontSize: AppSize.p16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: AppSize.p4),
                                    Text(
                                      profile.status ?? '',
                                      style: TextStyle(
                                        color: AppColor.textColor,
                                        fontSize: AppSize.size14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: AppSize.p4),
                                    Text(
                                      "${AppString.idColon}${profile.custId ?? ''}",
                                      style: TextStyle(
                                        color: AppColor.activeColor,
                                        fontSize: AppSize.size14,
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
              ),
            ),
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
              imageUrl,
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

  Widget customerDetails({
    required String address,
    required String gender,
    required String status,
    required String gracePeriod,
    required List<Phone> phone,
    required List<CustType> custType,
    required String nomineeName,
    required String nomineephoneNumbar,
    required String nomineeRelation,
  }) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(AppString.customerDetail),
          if (address.isNotEmpty)
            _detailRow(AppIcon.location, AppString.address, address),
          if (gender.isNotEmpty)
            _detailRow(AppIcon.person, AppString.gender, gender),
          if (status.isNotEmpty)
            _detailRow(
              AppIcon.status,
              AppString.status,
              status,
              valueColor: AppColor.activeColor,
            ),
          if (gracePeriod.isNotEmpty && gracePeriod != "0")
            _detailRow(AppIcon.calendar, AppString.gracePeriod, gracePeriod),

          if (custType.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSize.p16,
                AppSize.p16,
                AppSize.p16,
                8,
              ),
              child: Text(
                AppString.customerTypes,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppSize.headingText,
                ),
              ),
            ),
            ...custType.map(
              (type) => _customItemCard(
                AppIcon.category,
                type.typeName ?? '',
                type.status ?? '',
              ),
            ),
          ],

          if (phone.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSize.p16,
                AppSize.p16,
                AppSize.p16,
                8,
              ),
              child: Text(
                AppString.phoneNumbar,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppSize.headingText,
                ),
              ),
            ),
            ...phone.map(
              (p) => _phoneItemCard(p.phone ?? '', p.isDefault == "1"),
            ),
          ],
          if (nomineeName.isNotEmpty ||
              nomineephoneNumbar.isNotEmpty ||
              nomineeRelation.isNotEmpty) ...[
            _sectionHeader(AppString.nomineeDetail),
            if (nomineeName.isNotEmpty)
              _detailRow(AppIcon.person, AppString.name, nomineeName),
            if (nomineephoneNumbar.isNotEmpty)
              _detailRow(AppIcon.phone, AppString.phone, nomineephoneNumbar),
            if (nomineeRelation.isNotEmpty)
              _detailRow(
                AppIcon.verifiedUser,
                AppString.customerRelation,
                nomineeRelation,
              ),
          ],
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
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
            width: AppSize.p4,
            height: AppSize.p20,
            decoration: BoxDecoration(
              color: AppColor.goldColor,
              borderRadius: BorderRadius.circular(AppSize.p4 / 2),
            ),
          ),
          SizedBox(width: AppSize.p8),
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
            size: AppSize.iconLarge * 1.25,
          ),
        ],
      ),
    );
  }

  Widget _detailRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppSize.p12,
            horizontal: AppSize.p16,
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColor.goldColor, size: AppSize.iconMedium),
              SizedBox(width: AppSize.p16),
              Expanded(
                flex: 3,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: AppSize.commonText,
                    color: AppColor.black,
                  ),
                ),
              ),
              const Text(" : ", style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                flex: 5,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: AppSize.commonText,
                    color: valueColor ?? AppColor.black,
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
          color: AppColor.grey300,
          indent: AppSize.p16,
          endIndent: AppSize.p16,
        ),
      ],
    );
  }

  Widget _customItemCard(IconData icon, String title, String status) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSize.p16,
        vertical: AppSize.p8,
      ),
      padding: EdgeInsets.all(AppSize.p12),
      decoration: BoxDecoration(
        color: AppColor.backgroundColor,
        borderRadius: BorderRadius.circular(AppSize.p16 - 1),
        border: Border.all(color: AppColor.grey300),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSize.p8),
            decoration: BoxDecoration(
              color: AppColor.whiteOrang,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColor.goldColor),
          ),
          SizedBox(width: AppSize.p16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppSize.commonText,
                ),
              ),
              Text(
                status,
                style: TextStyle(
                  color: AppColor.activeColor,
                  fontSize: AppSize.mediumText * 1.1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _phoneItemCard(String phone, bool isDefault) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSize.p16,
        vertical: AppSize.p8,
      ),
      padding: EdgeInsets.all(AppSize.p12),
      decoration: BoxDecoration(
        color: AppColor.backgroundColor,
        borderRadius: BorderRadius.circular(AppSize.p16 - 1),
        border: Border.all(color: AppColor.grey300),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSize.p8),
            decoration: BoxDecoration(
              color: AppColor.whiteOrang,
              shape: BoxShape.circle,
            ),
            child: const Icon(AppIcon.phone, color: AppColor.goldColor),
          ),
          SizedBox(width: AppSize.p16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                phone,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppSize.commonText,
                ),
              ),
              if (isDefault)
                Text(
                  AppString.defaultLabel,
                  style: TextStyle(
                    color: AppColor.goldColor,
                    fontSize: AppSize.mediumText * 1.1,
                  ),
                ),
            ],
          ),
          const Spacer(),
          const Icon(AppIcon.rightArrow, color: AppColor.goldColor),
        ],
      ),
    );
  }

  Widget girviDetail({required Girvi girvi}) {
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
              Icon(icon, color: AppColor.goldColor, size: AppSize.iconSmall),
              SizedBox(width: AppSize.p4),
              Text(
                label,
                style: TextStyle(
                  fontSize: AppSize.extraSmallText,
                  color: AppColor.textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.p4),
          Text(
            value,
            style: TextStyle(
              fontSize: AppSize.commonText,
              fontWeight: FontWeight.bold,
              color: valueColor ?? AppColor.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget heddingData({
    required String name,
    required String custcode,
    required String totalGivenAmt,
    required String gracePeriod,
    required String phone,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: AppSize.p16),
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
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  if (customer.imagePath != null) {
                    _showFullScreenImage(
                      context,
                      customer.imagePath!,
                      customer.name ?? AppString.profileImage,
                    );
                  }
                },
                child: Container(
                  width: AppSize.width * 0.25,
                  height: AppSize.width * 0.35,
                  decoration: BoxDecoration(
                    color: AppColor.dashboardIconBg,
                    borderRadius: BorderRadius.circular(AppSize.p16),
                    border: Border(
                      bottom: BorderSide(
                        color: AppColor.goldColor,
                        width: AppSize.width * 0.008,
                      ),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSize.p16),
                    child: customer.imagePath != null
                        ? Image.network(customer.imagePath!, fit: BoxFit.cover)
                        : Icon(
                            AppIcon.person,
                            size: AppSize.iconLarge * 1.5,
                            color: AppColor.goldColor,
                          ),
                  ),
                ),
              ),
              SizedBox(width: AppSize.p16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: AppSize.headingText,
                        fontWeight: FontWeight.bold,
                        color: AppColor.black,
                      ),
                    ),
                    Text(
                      custcode,
                      style: TextStyle(
                        fontSize: AppSize.commonText,
                        color: AppColor.goldColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: AppSize.p8),
                    _amtRow(AppString.gvnAmtColon, totalGivenAmt),
                    _amtRow("${AppString.pendingAmt}: ", gracePeriod),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.p16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _actionButton(
                AppIcon.call,
                AppString.call,
                () => _makeCall(phone),
              ),
              _actionButton(
                AppIcon.message,
                AppString.message,
                () => _sendSMS(phone),
              ),
              _actionButton(
                AppIcon.whatsapp,
                AppString.whatsapp,
                () => _launchWhatsApp(phone),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _amtRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSize.p4 / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: AppSize.mediumText,
              color: AppColor.textColor,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: AppSize.commonText,
              fontWeight: FontWeight.bold,
              color: AppColor.goldColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(AppSize.p12),
            decoration: BoxDecoration(
              color: AppColor.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColor.goldColor.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: AppColor.black.withOpacity(0.05),
                  blurRadius: AppSize.p4,
                  offset: Offset(0, AppSize.p4 / 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: AppColor.goldColor,
              size: AppSize.iconMedium,
            ),
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
    baseColor: AppColor.grey300,
    highlightColor: AppColor.white,
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card Shimmer
          horizontalPadding(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: AppSize.p16),
              padding: EdgeInsets.all(AppSize.p16),
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(AppSize.p20),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: AppSize.width * 0.25,
                        height: AppSize.width * 0.35,
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(AppSize.p16),
                        ),
                      ),
                      SizedBox(width: AppSize.p16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 150,
                              height: 20,
                              color: AppColor.white,
                            ),
                            SizedBox(height: AppSize.p8),
                            Container(
                              width: 80,
                              height: 15,
                              color: AppColor.white,
                            ),
                            SizedBox(height: AppSize.p12),
                            Container(
                              width: double.infinity,
                              height: 12,
                              color: AppColor.white,
                            ),
                            SizedBox(height: 5),
                            Container(
                              width: double.infinity,
                              height: 12,
                              color: AppColor.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSize.p20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      3,
                      (index) => Column(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              color: AppColor.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(height: AppSize.p8),
                          Container(
                            width: 40,
                            height: 10,
                            color: AppColor.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // TabBar Shimmer
          horizontalPadding(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                3,
                (index) => Container(
                  width: AppSize.width * 0.25,
                  height: 35,
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(AppSize.p8),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: AppSize.p16),

          // Content Card Shimmer
          horizontalPadding(
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(AppSize.p20),
              ),
              child: Column(
                children: [
                  // Section Header Shimmer
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColor.white.withOpacity(0.3),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppSize.p20),
                      ),
                    ),
                  ),
                  // Detail Rows Shimmer
                  Padding(
                    padding: EdgeInsets.all(AppSize.p16),
                    child: Column(
                      children: List.generate(
                        5,
                        (index) => Padding(
                          padding: EdgeInsets.symmetric(vertical: AppSize.p12),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: const BoxDecoration(
                                  color: AppColor.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: AppSize.p16),
                              Container(
                                width: 80,
                                height: 15,
                                color: AppColor.white,
                              ),
                              const Spacer(),
                              Container(
                                width: 120,
                                height: 15,
                                color: AppColor.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
