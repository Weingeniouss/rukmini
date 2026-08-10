import 'package:get/get.dart';
import 'package:rukmini/view/screen/drawer/allMaster/customerTypeMaster/customerTypeMaster.dart';
import 'package:rukmini/view/screen/drawer/allMaster/lockerCodeMaster/addLockerCode.dart';
import 'package:rukmini/view/screen/drawer/allMaster/lockerCodeMaster/lockerCodeMaster.dart';
import 'package:rukmini/view/screen/drawer/allMaster/year_Master/add_Year_Master.dart';
import 'package:rukmini/view/screen/drawer/allMaster/year_Master/year_Master.dart';
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
import 'package:rukmini/view/screen/drawer/allMaster/categoryMataer/categoryMaster.dart';
import 'package:rukmini/view/screen/drawer/allMaster/metalTouch/metalTouch.dart';
import 'package:rukmini/view/screen/drawer/lockerTransaction/lockerTransationDetail/lockerTransationDetail.dart';
import 'package:rukmini/view/screen/drawer/lockerTransaction/lockerTranstaion.dart';
import 'package:rukmini/view/screen/drawer/productInLocker/changeTheLocker/changeTheLocker.dart';
import 'package:rukmini/view/screen/drawer/productInLocker/productInLocker.dart';
import 'package:rukmini/view/screen/drawer/productInLocker/productLockerDetail/productInLockerDetail.dart';
import '../view/screen/drawer/allMaster/metalMaster/metal_Master.dart';
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
      GetPage(name: _Paths.productInLocker, page: () => ProductInLocker()),
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

    //All Master
        // Metal Master
            GetPage(name: _Paths.metalMaster, page: () => MetalMaster()),
        // Category Master
            GetPage(name: _Paths.categoryMaster, page: () => CategoryMaster()),
        // Customer Type Master
            GetPage(name: _Paths.customerTypeMaster, page: () => CustomerTypeMaster()),
        //Locker Code Master
            GetPage(name: _Paths.lockerCodeMaster, page: () => LockerCodeMaster()),
            GetPage(name: _Paths.addLockerCode, page: () => AddLockerCode()),
        //Metal Touch
            GetPage(name: _Paths.metalTouch, page: () => MetalTouch()),
        //Year Master
            GetPage(name: _Paths.yearMaster, page: () => YearMaster()),
            GetPage(name: _Paths.addYearMaster, page: () => AddYearMaster()),
    //All Master

    //Product In Locker
        GetPage(name: _Paths.productInLockerDetail, page: () => ProductInLockerDetail()),
        GetPage(name: _Paths.changeTheLocker, page: () => ChangeTheLocker()),
    //Product In Locker

    //Locker Transaction
        GetPage(name: _Paths.lockerTransaction, page: () => LockerTranStaion()),
        GetPage(name: _Paths.lockerTransationDetail, page: () => LockerTransationDetail()),
    //Locker Transaction

  ];
}
