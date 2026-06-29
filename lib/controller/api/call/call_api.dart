import 'package:rukmini/elevated/credenials/loginElevated.dart';
import 'package:rukmini/elevated/home/customers/custListElevated.dart';
import 'package:rukmini/elevated/home/dashboardElevated.dart';

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
  static Future<void> callCustList({bool isRefresh = false}) async {
    await getCustList(isRefresh: isRefresh);
  }
}
