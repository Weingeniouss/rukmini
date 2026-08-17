// ignore_for_file: strict_top_level_inference, file_names

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
          Get.defaultDialog(
            title: AppString.deleteCustomer,
            middleText: AppString.deleteMessage,
            titleStyle: TextStyle(
              fontSize: AppSize.size20,
              fontWeight: FontWeight.bold,
            ),
            middleTextStyle: TextStyle(fontSize: AppSize.size14),
            contentPadding: EdgeInsets.all(AppSize.p16),
            confirm: Container(
              width: AppSize.width * 0.3,
              decoration: BoxDecoration(
                color: AppColor.deleteColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () async {
                  await CallApi.callCustRemove(custId: customer.custId!);
                  await CallApi.callCustList(isRefresh: true);
                  Get.back();
                  Get.back();
                },
                child: const Text(
                  AppString.delete,
                  style: TextStyle(color: AppColor.white),
                ),
              ),
            ),
            cancel: Container(
              width: AppSize.width * 0.3,
              decoration: BoxDecoration(
                color: AppColor.baseColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  AppString.cancel,
                  style: TextStyle(color: AppColor.primaryColor),
                ),
              ),
            ),
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
              Container(
                decoration: const BoxDecoration(
                  color: AppColor.subHeadingContainerColor,
                ),
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

  Widget tabBarHedings(text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppSize.p20),
      child: Text(
        text,
        style: TextStyle(
          fontSize: AppSize.size14,
          fontWeight: FontWeight.w500,
          color: AppColor.dark,
        ),
      ),
    );
  }

  Widget tabBar(CustomerDetailData data) {
    return Column(
      children: [
        TabBar(
          labelColor: AppColor.primaryColor,
          unselectedLabelColor: AppColor.textColor,
          indicatorColor: AppColor.primaryColor,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: [
            tabBarHedings(AppString.customerDetails),
            tabBarHedings(AppString.girviDetails),
            tabBarHedings(AppString.transactionDetails),
            tabBarHedings(AppString.identiyProof),
          ],
        ),
        Expanded(
          child: TabBarView(
            children: [
              // Customer Details Tab
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Customer Details
                    customerDetails(
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
                  ],
                ),
              ),
              // Girvi Details
              SingleChildScrollView(
                child: horizontalPadding(
                  child: Column(
                    children: [
                      SizedBox(height: AppSize.p8),
                      if (data.girviList == null || data.girviList!.isEmpty)
                        Center(child: Text(AppString.noGirviRecordsFound))
                      else
                        ...data.girviList!.map(
                          (girvi) => girviDetail(girvi: girvi),
                        ),
                    ],
                  ),
                ),
              ),

              //Transaction Details
              SingleChildScrollView(
                child: horizontalPadding(
                  child: Column(
                    children: [
                      SizedBox(height: AppSize.p8),
                      if (data.girviList == null || data.girviList!.isEmpty)
                        Center(child: Text(AppString.noGirviRecordsFound))
                      else
                        ...data.girviList!.map(
                          (girvi) => translationDetail(girvi: girvi),
                        ),
                    ],
                  ),
                ),
              ),

              //Identity Proof Tab
              identityProofTab(data),
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
                color: AppColor.backgroundColor,
                margin: EdgeInsets.symmetric(
                  horizontal: AppSize.p16,
                  vertical: AppSize.p4,
                ),
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
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              proof.imagePath!,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(AppIcon.brokenImage, size: 50);
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
                color: AppColor.backgroundColor,
                margin: EdgeInsets.symmetric(
                  horizontal: AppSize.p16,
                  vertical: AppSize.p4,
                ),
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
                                  borderRadius: BorderRadius.circular(10),
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
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(AppString.noIdentityProofsFound),
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
    return Column(
      children: [
        headingContainer(AppString.customerDetail),
        horizontalPadding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSize.p4),
              _detailItem(AppString.address, address, AppIcon.location),
              _detailItem(AppString.gender, gender, AppIcon.person),
              _detailItem(AppString.status, status, AppIcon.status),
              _detailItem(AppString.gracePeriod, gracePeriod, AppIcon.calendar),
              if (custType.isNotEmpty) ...[
                SizedBox(height: AppSize.p8),
                Text(
                  AppString.customerTypes,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppSize.largeText,
                  ),
                ),
                ...custType.map(
                  (type) => ListTile(
                    title: Text(type.typeName ?? ''),
                    subtitle: Text(type.status ?? ''),
                    leading: const Icon(
                      AppIcon.category,
                      color: AppColor.activeColor,
                    ),
                  ),
                ),
              ],
              SizedBox(height: AppSize.p8),
              Text(
                AppString.phoneNumbar,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppSize.largeText,
                ),
              ),
              ...phone.map(
                (p) => ListTile(
                  title: Text(p.phone ?? ''),
                  subtitle: Text(
                    p.isDefault == "1" ? AppString.defaultLabel : "",
                  ),
                  leading: const Icon(
                    AppIcon.phone,
                    color: AppColor.activeColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        //Customer Details End

        //Nominee Details start
        headingContainer(AppString.nomineeDetail),
        horizontalPadding(
          child: Column(
            children: [
              SizedBox(height: AppSize.p4),
              _detailItem(AppString.name, nomineeName, AppIcon.location),
              _detailItem(
                AppString.phoneNumbar,
                nomineephoneNumbar,
                AppIcon.person,
              ),
              _detailItem(
                AppString.customerRelation,
                nomineeRelation,
                AppIcon.status,
              ),
            ],
          ),
        ),
        //Nominee Details End
      ],
    );
  }

  Widget girviDetail({required Girvi girvi}) {
    return Card(
      borderOnForeground: true,
      color: AppColor.backgroundColor,
      margin: EdgeInsets.only(bottom: AppSize.p4),
      child: Padding(
        padding: EdgeInsets.all(AppSize.p12),
        child: Column(
          children: [
            _detailItem(
              AppString.name,
              girvi.custName,
              AppIcon.person,
              valueColor: AppColor.activeColor,
              fontWeight: FontWeight.w500,
            ),
            _detailItem(AppString.phone, girvi.custPhone, AppIcon.phone),
            _detailItem(
              AppString.uniqueId,
              girvi.uniqueId,
              AppIcon.fingerprint,
            ),
            _detailItem(AppString.girviDate, girvi.girviDate, AppIcon.date),
            _detailItem(AppString.givenAmt, girvi.givenAmt, AppIcon.rupee),
            _detailItem(
              AppString.balance,
              girvi.balance?.toString(),
              AppIcon.wallet,
            ),
          ],
        ),
      ),
    );
  }

  Widget translationDetail({required Girvi girvi}) {
    return Card(
      borderOnForeground: true,
      color: AppColor.backgroundColor,
      margin: EdgeInsets.only(bottom: AppSize.p4),
      child: Padding(
        padding: EdgeInsets.all(AppSize.p12),
        child: Column(
          children: [
            _detailItem(
              AppString.uniqueId,
              girvi.uniqueId,
              AppIcon.fingerprint,
            ),
            _detailItem(AppString.givenAmt, girvi.givenAmt, AppIcon.rupee),
            _detailItem(
              AppString.paidAmt,
              girvi.totalPaidAmt?.toString(),
              AppIcon.payment,
            ),
            _detailItem(
              AppString.totint,
              girvi.tillInterest?.toString(),
              AppIcon.trend,
            ),
            _detailItem(
              AppString.paidint,
              girvi.paidInterset,
              AppIcon.checkCircle,
            ),
          ],
        ),
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
    return Padding(
      padding: EdgeInsets.all(AppSize.p16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              _showFullScreenImage(
                context,
                customer.imagePath!,
                customer.name ?? AppString.profileImage,
              );
            },
            child: Container(
              width: AppSize.width * 0.2,
              height: AppSize.width * 0.4,
              decoration: BoxDecoration(
                color: AppColor.primaryColor,
                borderRadius: BorderRadius.circular(AppSize.p8),
                image: customer.imagePath != null
                    ? DecorationImage(
                        image: NetworkImage(customer.imagePath!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: customer.imagePath == null
                  ? const Icon(AppIcon.person, color: AppColor.white, size: 40)
                  : null,
            ),
          ),
          SizedBox(width: AppSize.p16),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: AppSize.size18,
                              fontWeight: FontWeight.bold,
                              color: AppColor.primaryColor,
                            ),
                          ),
                          Text(
                            custcode,
                            style: TextStyle(
                              fontSize: AppSize.size14,
                              color: AppColor.textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  '${AppString.gvnAmt}: ',
                                  style: TextStyle(
                                    fontSize: AppSize.size14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Text(
                                totalGivenAmt,
                                style: TextStyle(
                                  fontSize: AppSize.size18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${AppString.pendingAmt}: ',
                                  style: TextStyle(
                                    fontSize: AppSize.size14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Text(
                                gracePeriod,
                                style: TextStyle(
                                  fontSize: AppSize.size18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSize.p8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        _contactIcon(
                          AppIcon.call,
                          AppColor.activeColor,
                          () => _makeCall(phone),
                        ),
                        SizedBox(height: AppSize.p4),
                        Text(
                          AppString.call,
                          style: TextStyle(fontSize: AppSize.p12),
                        ),
                      ],
                    ),
                    SizedBox(width: AppSize.p12),
                    Column(
                      children: [
                        _contactIcon(
                          AppIcon.message,
                          AppColor.blue,
                          () => _sendSMS(phone),
                        ),
                        SizedBox(height: AppSize.p4),
                        Text(
                          AppString.message,
                          style: TextStyle(fontSize: AppSize.p12),
                        ),
                      ],
                    ),
                    SizedBox(width: AppSize.p12),
                    Column(
                      children: [
                        _contactIcon(
                          AppIcon.chat,
                          AppColor.activeColor,
                          () => _launchWhatsApp(phone),
                        ),
                        SizedBox(height: AppSize.p4),
                        Text(
                          AppString.whatsapp,
                          style: TextStyle(fontSize: AppSize.p12),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactIcon(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSize.p8),
        decoration: BoxDecoration(
          color: AppColor.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColor.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: AppSize.p20),
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

  Widget _detailItem(
    String label,
    String? value,
    IconData icon, {
    Color? valueColor,
    String? fontFamily,
    FontWeight? fontWeight,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSize.p4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: AppSize.p24, color: AppColor.activeColor),
          SizedBox(width: AppSize.p8),
          Expanded(
            flex: 3,
            child: Text(
              '$label :',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: AppSize.size14,
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Text(
              value ?? AppString.na,
              style: TextStyle(
                color: valueColor,
                fontFamily: fontFamily,
                fontWeight: fontWeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget loadingState() {
  return Shimmer.fromColors(
    baseColor: AppColor.baseColor,
    highlightColor: AppColor.highlightColor,
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Shimmer
          Container(
            padding: EdgeInsets.all(AppSize.p16),
            child: Row(
              children: [
                Container(
                  width: AppSize.width * 0.2,
                  height: AppSize.width * 0.4,
                  decoration: BoxDecoration(
                    color: AppColor.textField,
                    borderRadius: BorderRadius.circular(AppSize.p8),
                  ),
                ),
                SizedBox(width: AppSize.p16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 20,
                        color: AppColor.textField,
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: AppSize.width * 0.3,
                        height: AppSize.p8,
                        color: AppColor.textField,
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(
                          3,
                          (index) => Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColor.textField,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // TabBar Shimmer
          Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: AppSize.p16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                4,
                (index) => Container(
                  width: AppSize.width * 0.2,
                  height: 20,
                  color: AppColor.textField,
                ),
              ),
            ),
          ),

          // Content Shimmer
          Padding(
            padding: EdgeInsets.all(AppSize.p16),
            child: Column(
              children: List.generate(
                8,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: AppColor.textField,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: Get.width * 0.4,
                              height: AppSize.p8,
                              color: AppColor.textField,
                            ),
                            SizedBox(height: 5),
                            Container(
                              width: double.infinity,
                              height: 12,
                              color: AppColor.textField,
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
    ),
  );
}
