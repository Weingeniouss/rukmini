// ignore_for_file: strict_top_level_inference, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/home/customers/custDetail_Controller.dart';
import 'package:rukmini/modal/home/customer/customer_detail_model.dart';
import 'package:rukmini/modal/home/customer/customer_list_model.dart' as list;
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:rukmini/view/utils/widget/horizontalPadding.dart';
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
    CallApi.callCustDetail(custId: customer.custId);
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
        remove: true,
      ),
      child: DefaultTabController(
        length: 2,
        child: Obx(() {
          if (custDetailController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = custDetailController.custDetailData.value.data;

          if (data == null) {
            return const Center(child: Text('No Details Found'));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
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
              Expanded(
                child: tabBar(
                  address: data.address ?? '',
                  gender: data.gender ?? '',
                  status: data.status ?? '',
                  phone: data.phone ?? <Phone>[],
                  gracePeriod: data.gracePeriod ?? '',
                  custType: data.custType ?? <CustType>[],
                  nomineeName: data.nominee?.name ?? '',
                  nomineephoneNumbar: data.nominee?.phone ?? '',
                  nomineeRelation: data.nominee?.custRelation ?? '',
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget tabBarHedings(text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Get.height * 0.020),
      child: Text(
        text,
        style: TextStyle(
          fontSize: Get.width * 0.035,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget tabBar({
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
                      address: address,
                      gender: gender,
                      status: status,
                      gracePeriod: gracePeriod,
                      phone: phone,
                      custType: custType,
                      nomineeName: nomineeName,
                      nomineephoneNumbar: nomineephoneNumbar,
                      nomineeRelation: nomineeRelation,
                    ),
                  ],
                ),
              ),
              // Girvi Details Tab
              SingleChildScrollView(
                child: horizontalPadding(
                  child: Column(
                    children: [
                      SizedBox(height: Get.height * 0.02),
                      Center(child: Text('Girvi Details Coming Soon')),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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
        // Customer Details start
        Container(
          padding: EdgeInsets.all(Get.width * 0.04),
          decoration: BoxDecoration(color: AppColor.subHeadingContainerColor),
          width: Get.width,
          child: Text(
            AppString.customerDetail,
            style: TextStyle(
              fontSize: Get.width * 0.038,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        horizontalPadding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Get.height * 0.01),
              _detailItem(AppString.address, address, Icons.location_on),
              _detailItem(AppString.gender, gender, Icons.person),
              _detailItem(AppString.status, status, Icons.info_outline),
              _detailItem(
                AppString.gracePeriod,
                gracePeriod,
                Icons.calendar_month,
              ),
              if (custType.isNotEmpty) ...[
                SizedBox(height: Get.height * 0.02),
                Text(
                  AppString.customerTypes,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Get.width * 0.04,
                  ),
                ),
                ...custType.map(
                  (type) => ListTile(
                    title: Text(type.typeName ?? ''),
                    subtitle: Text(type.status ?? ''),
                    leading: Icon(Icons.category, color: Colors.green),
                  ),
                ),
              ],
              SizedBox(height: Get.height * 0.02),
              Text(
                AppString.phoneNumbar,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Get.width * 0.04,
                ),
              ),
              ...phone.map(
                (p) => ListTile(
                  title: Text(p.phone ?? ''),
                  subtitle: Text(p.isDefault == "1" ? "Default" : ""),
                  leading: Icon(Icons.phone, color: Colors.green),
                ),
              ),
            ],
          ),
        ),
        //Customer Details End

        //Nominee Details start
        Container(
          padding: EdgeInsets.all(Get.width * 0.04),
          decoration: BoxDecoration(color: AppColor.subHeadingContainerColor),
          width: Get.width,
          child: Text(
            AppString.nomineeDetail,
            style: TextStyle(
              fontSize: Get.width * 0.038,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Column(
          children: [
            SizedBox(height: Get.height * 0.01),
            _detailItem(AppString.name, nomineeName, Icons.location_on),
            _detailItem(
              AppString.phoneNumbar,
              nomineephoneNumbar,
              Icons.person,
            ),
            _detailItem(
              AppString.customerRelation,
              nomineeRelation,
              Icons.info_outline,
            ),
          ],
        ),
        //Nominee Details End
      ],
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
      padding: EdgeInsets.all(Get.width * 0.04),
      child: Row(
        children: [
          Container(
            width: Get.width * 0.2,
            height: Get.width * 0.4,
            decoration: BoxDecoration(
              color: AppColor.primaryColor,
              borderRadius: BorderRadius.circular(Get.width * 0.02),
              image: customer.imagePath != null
                  ? DecorationImage(
                      image: NetworkImage(customer.imagePath!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: customer.imagePath == null
                ? Icon(Icons.person, color: Colors.white, size: 40)
                : null,
          ),
          SizedBox(width: Get.width * 0.04),
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
                              fontSize: Get.width * 0.045,
                              fontWeight: FontWeight.bold,
                              color: AppColor.primaryColor,
                            ),
                          ),
                          Text(
                            custcode,
                            style: TextStyle(
                              fontSize: Get.width * 0.035,
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
                              Text(
                                '${AppString.gvnAmt}: ',
                                style: TextStyle(
                                  fontSize: Get.width * 0.035,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                totalGivenAmt,
                                style: TextStyle(fontSize: Get.width * 0.03),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                '${AppString.pendingAmt}: ',
                                style: TextStyle(
                                  fontSize: Get.width * 0.035,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                gracePeriod,
                                style: TextStyle(fontSize: Get.width * 0.03),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Get.height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        _contactIcon(
                          Icons.call,
                          Colors.green,
                          () => _makeCall(phone),
                        ),
                        SizedBox(height: Get.height * 0.003),
                        Text(
                          AppString.call,
                          style: TextStyle(fontSize: Get.height * 0.015),
                        ),
                      ],
                    ),
                    SizedBox(width: Get.width * 0.03),
                    Column(
                      children: [
                        _contactIcon(
                          Icons.message,
                          Colors.blue,
                          () => _sendSMS(phone),
                        ),
                        SizedBox(height: Get.height * 0.003),
                        Text(
                          AppString.message,
                          style: TextStyle(fontSize: Get.height * 0.015),
                        ),
                      ],
                    ),
                    SizedBox(width: Get.width * 0.03),
                    Column(
                      children: [
                        _contactIcon(
                          Icons.chat,
                          Colors.green,
                          () => _launchWhatsApp(phone),
                        ),
                        SizedBox(height: Get.height * 0.003),
                        Text(
                          AppString.whatsapp,
                          style: TextStyle(fontSize: Get.height * 0.015),
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
        padding: EdgeInsets.all(Get.width * 0.02),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: Get.width * 0.05),
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

  Widget _detailItem(String label, String? value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Get.height * 0.005),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: Get.width * 0.06, color: Colors.green),
          SizedBox(width: Get.width * 0.02),
          Expanded(
            flex: 3,
            child: Text(
              '$label :',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: Get.width * 0.035,
              ),
            ),
          ),
          Expanded(flex: 7, child: Text(value ?? 'N/A')),
        ],
      ),
    );
  }
}
