import 'package:rukmini/elevated/credenials/loginElevated.dart';
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
}
