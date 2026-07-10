import 'package:rukmini/elevated/credenials/loginElevated.dart';
import 'package:rukmini/elevated/drawer/home/customers/addCustElevated.dart';
import 'package:rukmini/elevated/drawer/home/customers/custDetailElevated.dart';
import 'package:rukmini/elevated/drawer/home/customers/custListElevated.dart';
import 'package:rukmini/elevated/drawer/home/dashboardElevated.dart';

class CallApi {
  // Credentials Login
  static Future<void> callLogin() async {
    await postLogin();
  }

  // Home Dashboard
  static Future<void> callDashboard() async {
    await getDashboard();
  }

  // Customer List
  static Future<void> callCustList({
    bool isRefresh = false,
    String? search,
  }) async {
    await getCustList(isRefresh: isRefresh, search: search);
  }

  // Customer Detail
  static Future<void> callCustDetail({String? custId}) async {
    await getCustDetail(custId: custId);
  }

  // Add Customer
  static Future<void> callAddCustomer({
    required String name,
    required String typeDel,
    required String phoneDel,
    required String address,
    required String gender,
    String? nName,
    String? nPhone,
    String? custRelation,
    String? gracePeriod,
    String? isProfile,
    String? profileName,
    List<String>? profile,
    List<String>? proof,
  }) async {
    await postAddCustomer(
      name: name,
      typeDel: typeDel,
      phoneDel: phoneDel,
      address: address,
      gender: gender,
      nName: nName,
      nPhone: nPhone,
      custRelation: custRelation,
      gracePeriod: gracePeriod,
      isProfile: isProfile,
      profileName: profileName,
      profile: profile,
      proof: proof,
    );
  }
}
