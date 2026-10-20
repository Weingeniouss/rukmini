import 'package:get/get.dart';
import 'package:rukmini/controller/api/controllers/credentials/login_controller.dart';
import 'package:rukmini/view/utils/widget/main_layout_screen.dart';
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

    //Drawer & Authenticated App Routes (Wrapped in MainLayoutScreen persistent shell)
    GetPage(
      name: _Paths.allMaster,
      page: () => const MainLayoutScreen(initialRoute: _Paths.allMaster),
    ),
    GetPage(
      name: _Paths.productInLocker,
      page: () => const MainLayoutScreen(initialRoute: _Paths.productInLocker),
    ),
    GetPage(
      name: _Paths.home,
      page: () => const MainLayoutScreen(initialRoute: _Paths.home),
    ),
    GetPage(
      name: _Paths.custList,
      page: () => const MainLayoutScreen(initialRoute: _Paths.custList),
    ),
    GetPage(
      name: _Paths.custDetail,
      page: () => const MainLayoutScreen(initialRoute: _Paths.custDetail),
    ),
    GetPage(
      name: _Paths.addCustForm,
      page: () => const MainLayoutScreen(initialRoute: _Paths.addCustForm),
    ),
    GetPage(
      name: _Paths.updateCustForm,
      page: () => const MainLayoutScreen(initialRoute: _Paths.updateCustForm),
    ),
    GetPage(
      name: _Paths.giriviList,
      page: () => const MainLayoutScreen(initialRoute: _Paths.giriviList),
    ),
    GetPage(
      name: _Paths.giriviadd,
      page: () => const MainLayoutScreen(initialRoute: _Paths.giriviadd),
    ),
    GetPage(
      name: _Paths.AddProduct,
      page: () => const MainLayoutScreen(initialRoute: _Paths.AddProduct),
    ),
    GetPage(
      name: _Paths.giriviDetail,
      page: () => const MainLayoutScreen(initialRoute: _Paths.giriviDetail),
    ),
    GetPage(
      name: _Paths.pendingProduct,
      page: () => const MainLayoutScreen(initialRoute: _Paths.pendingProduct),
    ),
    GetPage(
      name: _Paths.returnProduct,
      page: () => const MainLayoutScreen(initialRoute: _Paths.returnProduct),
    ),
    GetPage(
      name: _Paths.karkitProduct,
      page: () => const MainLayoutScreen(initialRoute: _Paths.karkitProduct),
    ),
    GetPage(
      name: _Paths.soldProduct,
      page: () => const MainLayoutScreen(initialRoute: _Paths.soldProduct),
    ),
    GetPage(
      name: _Paths.dueGirvi,
      page: () => const MainLayoutScreen(initialRoute: _Paths.dueGirvi),
    ),
    GetPage(
      name: _Paths.dueOverGirvi,
      page: () => const MainLayoutScreen(initialRoute: _Paths.dueOverGirvi),
    ),
    GetPage(
      name: _Paths.metalMaster,
      page: () => const MainLayoutScreen(initialRoute: _Paths.metalMaster),
    ),
    GetPage(
      name: _Paths.categoryMaster,
      page: () => const MainLayoutScreen(initialRoute: _Paths.categoryMaster),
    ),
    GetPage(
      name: _Paths.customerTypeMaster,
      page: () => const MainLayoutScreen(initialRoute: _Paths.customerTypeMaster),
    ),
    GetPage(
      name: _Paths.lockerCodeMaster,
      page: () => const MainLayoutScreen(initialRoute: _Paths.lockerCodeMaster),
    ),
    GetPage(
      name: _Paths.addLockerCode,
      page: () => const MainLayoutScreen(initialRoute: _Paths.addLockerCode),
    ),
    GetPage(
      name: _Paths.metalTouch,
      page: () => const MainLayoutScreen(initialRoute: _Paths.metalTouch),
    ),
    GetPage(
      name: _Paths.yearMaster,
      page: () => const MainLayoutScreen(initialRoute: _Paths.yearMaster),
    ),
    GetPage(
      name: _Paths.addYearMaster,
      page: () => const MainLayoutScreen(initialRoute: _Paths.addYearMaster),
    ),
    GetPage(
      name: _Paths.productInLockerDetail,
      page: () => const MainLayoutScreen(initialRoute: _Paths.productInLockerDetail),
    ),
    GetPage(
      name: _Paths.changeTheLocker,
      page: () => const MainLayoutScreen(initialRoute: _Paths.changeTheLocker),
    ),
    GetPage(
      name: _Paths.lockerTransaction,
      page: () => const MainLayoutScreen(initialRoute: _Paths.lockerTransaction),
    ),
    GetPage(
      name: _Paths.lockerTransationDetail,
      page: () => const MainLayoutScreen(initialRoute: _Paths.lockerTransationDetail),
    ),
    GetPage(
      name: _Paths.report,
      page: () => const MainLayoutScreen(initialRoute: _Paths.report),
    ),
    GetPage(
      name: _Paths.exportContacts,
      page: () => const MainLayoutScreen(initialRoute: _Paths.exportContacts),
    ),
    GetPage(
      name: _Paths.reportView,
      page: () => const MainLayoutScreen(initialRoute: _Paths.reportView),
    ),
    GetPage(
      name: _Paths.profile,
      page: () => const MainLayoutScreen(initialRoute: _Paths.profile),
    ),
  ];
}
