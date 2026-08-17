import 'package:get/get.dart';
import 'package:rukmini/controller/api/controllers/credentials/login_controller.dart';
import 'package:rukmini/controller/api/controllers/drawer/all_master/locker_master/lockerList_Controller.dart';
import 'package:rukmini/controller/api/controllers/drawer/productInLocker/cust_product_controller.dart';
import 'package:rukmini/controller/ui/home/allMaster/locker_master/lockerMaster_ControllerUI.dart';
import 'package:rukmini/controller/ui/home/allMaster/year_Master/yearMaster_ControllerUI.dart';
import 'package:rukmini/controller/ui/home/customer/addCustForm_controller.dart';
import 'package:rukmini/controller/ui/home/customer/updateCustForm_controller.dart';
import 'package:rukmini/controller/ui/home/locker/locker_trans_ui_controller.dart';
import 'package:rukmini/controller/ui/home/productInLocker/changeLocker_ControllerUI.dart';
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
import 'package:rukmini/view/screen/drawer/report/reports.dart';
import '../view/screen/drawer/allMaster/metalMaster/metal_Master.dart';
import '../view/screen/drawer/home/girvi/giriviList.dart';
import '../view/screen/splash/splash.dart';
import '../view/screen/credentials/login.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    //Splash
    GetPage(name: _Paths.splash, page: () => const Splash()),

    //Credentials
    //Login
    GetPage(
      name: _Paths.login,
      page: () => Login(loginAPI: Get.put(LoginControllerAPI())),
    ),

    //Drawer
    GetPage(name: _Paths.allMaster, page: () => const AllMaster()),
    GetPage(
      name: _Paths.productInLocker,
      page: () => ProductInLocker(
        custProductController: Get.put(CustProductController()),
        lockerListController: Get.put(LockerListController()),
      ),
    ),
    // Home
    // Customer
    GetPage(name: _Paths.home, page: () => const Home()),
    GetPage(name: _Paths.custList, page: () => const Custlist()),
    GetPage(name: _Paths.custDetail, page: () => const CustDetail()),
    GetPage(
      name: _Paths.addCustForm,
      page: () =>
          AddCustForm(addCustForomUI: Get.put(AddCustFormControllerUI())),
    ),
    GetPage(
      name: _Paths.updateCustForm,
      page: () =>
          UpdateCustForm(updateCustUI: Get.put(UpdateCustFormControllerUI())),
    ),
    // Girivi
    GetPage(name: _Paths.giriviList, page: () => const GiriviList()),
    GetPage(name: _Paths.giriviadd, page: () => const Addgirivi()),
    GetPage(name: _Paths.AddProduct, page: () => const AddProduct()),
    GetPage(name: _Paths.giriviDetail, page: () => const GiriviDetail()),
    //Pending Product
    GetPage(name: _Paths.pendingProduct, page: () => const productDetail()),
    // Return Product
    GetPage(name: _Paths.returnProduct, page: () => const productDetail()),
    // total Karkit
    GetPage(name: _Paths.karkitProduct, page: () => const productDetail()),
    // Sold Product
    GetPage(name: _Paths.soldProduct, page: () => const productDetail()),
    // Due Girvi
    GetPage(name: _Paths.dueGirvi, page: () => const DueGirvi()),
    // Due Over Girvi
    GetPage(name: _Paths.dueOverGirvi, page: () => const DueGirvi()),
    // Home

    //All Master
    // Metal Master
    GetPage(name: _Paths.metalMaster, page: () => const MetalMaster()),
    // Category Master
    GetPage(name: _Paths.categoryMaster, page: () => const CategoryMaster()),
    // Customer Type Master
    GetPage(
      name: _Paths.customerTypeMaster,
      page: () => const CustomerTypeMaster(),
    ),
    //Locker Code Master
    GetPage(
      name: _Paths.lockerCodeMaster,
      page: () => const LockerCodeMaster(),
    ),
    GetPage(
      name: _Paths.addLockerCode,
      page: () =>
          AddLockerCode(uiController: Get.put(LockerMasterControllerUI())),
    ),
    //Metal Touch
    GetPage(name: _Paths.metalTouch, page: () => const MetalTouch()),
    //Year Master
    GetPage(name: _Paths.yearMaster, page: () => const YearMaster()),
    GetPage(
      name: _Paths.addYearMaster,
      page: () =>
          AddYearMaster(uiController: Get.put(YearMasterControllerUI())),
    ),
    //All Master

    //Product In Locker
    GetPage(
      name: _Paths.productInLockerDetail,
      page: () => const ProductInLockerDetail(),
    ),
    GetPage(
      name: _Paths.changeTheLocker,
      page: () => ChangeTheLocker(
        uiController: Get.put(ChangeLockerControllerUI()),
        custProductController: Get.find<CustProductController>(),
      ),
    ),
    //Product In Locker

    //Locker Transaction
    GetPage(
      name: _Paths.lockerTransaction,
      page: () =>
          LockerTranStaion(uiController: Get.put(LockerTransUIController())),
    ),
    GetPage(
      name: _Paths.lockerTransationDetail,
      page: () => const LockerTransationDetail(),
    ),
    //Locker Transaction

    //Report
    GetPage(name: _Paths.report, page: () => Reports()),
    //Report
    //Drawer
  ];
}
