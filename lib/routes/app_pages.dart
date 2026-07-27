import 'package:get/get.dart';
import 'package:rukmini/view/screen/drawer/home/customer/addCustForm.dart';
import 'package:rukmini/view/screen/drawer/home/customer/custDetail.dart';
import 'package:rukmini/view/screen/drawer/home/customer/custList.dart';
import 'package:rukmini/view/screen/drawer/home/customer/updateCustForm.dart';
import 'package:rukmini/view/screen/drawer/home/dueGirvi/dueGirvi.dart';
import 'package:rukmini/view/screen/drawer/home/girvi/addGirivi.dart';
import 'package:rukmini/view/screen/drawer/home/girvi/addProduct.dart';
import 'package:rukmini/view/screen/drawer/home/girvi/giriviDetail.dart';
import 'package:rukmini/view/screen/drawer/home/home.dart';
import 'package:rukmini/view/screen/drawer/home/pendingProduct/productDetail.dart';
import 'package:rukmini/view/screen/drawer/allMaster/allMaster.dart';
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
      GetPage(name: _Paths.allMaster, page: () => AllMaster()),
      // Home
        // Customer
            GetPage(name: _Paths.home, page: () => Home()),
            GetPage(name: _Paths.custList, page: () => Custlist()),
            GetPage(name: _Paths.custDetail, page: () => CustDetail()),
            GetPage(name: _Paths.addCustForm, page: () => AddCustForm()),
            GetPage(name: _Paths.updateCustForm, page: () => UpdateCustForm()),
        // Girivi
            GetPage(name: _Paths.giriviList, page: () => GiriviList()),
            GetPage(name: _Paths.giriviadd, page: () => Addgirivi()),
            GetPage(name: _Paths.AddProduct, page: () => AddProduct()),
            GetPage(name: _Paths.giriviDetail, page: () => GiriviDetail()),
        //Pending Product
            GetPage(name: _Paths.pendingProduct, page: () => productDetail()),
        // Return Product
            GetPage(name: _Paths.returnProduct, page: () => productDetail()),
        // total Karkit
            GetPage(name: _Paths.karkitProduct, page: () => productDetail()),
        // Sold Product
            GetPage(name: _Paths.soldProduct, page: () => productDetail()),
        // Due Girvi
            GetPage(name: _Paths.dueGirvi, page: () => DueGirvi()),
        // Due Over Girvi
            GetPage(name: _Paths.dueOverGirvi, page: () => DueGirvi()),
    // Home
  ];
}
