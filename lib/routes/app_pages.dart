import 'package:get/get.dart';
import 'package:rukmini/view/screen/drawer/home/customer/addCustForm.dart';
import 'package:rukmini/view/screen/drawer/home/customer/custDetail.dart';
import 'package:rukmini/view/screen/drawer/home/customer/custList.dart';
import 'package:rukmini/view/screen/drawer/home/customer/updateCustForm.dart';
import 'package:rukmini/view/screen/drawer/home/home.dart';
import '../view/screen/drawer/home/girvi/giriviList.dart';
import '../view/screen/splash/splash.dart';
import '../view/screen/credentials/login.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = [

    //Splash
    GetPage(name: _Paths.splash, page: () => Splash()),

    //Credentials
      //Login
          GetPage(name: _Paths.login, page: () => Login()),

    //Drawer
      // Home
        // Customer
            GetPage(name: _Paths.home, page: () => Home()),
            GetPage(name: _Paths.custList, page: () => Custlist()),
            GetPage(name: _Paths.custDetail, page: () => CustDetail()),
            GetPage(name: _Paths.addCustForm, page: () => AddCustForm()),
            GetPage(name: _Paths.updateCustForm, page: () => UpdateCustForm()),
        // Girivi
            GetPage(name: _Paths.giriviList, page: () => GiriviList()),
  ];
}
