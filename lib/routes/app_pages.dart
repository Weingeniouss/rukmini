import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/controllers/credentials/login_controller.dart';
import 'package:rukmini/view/utils/app_constants.dart';
import 'package:rukmini/view/utils/widget/main_layout_screen.dart';
import '../view/screen/splash/splash.dart';
import '../view/screen/credentials/login.dart';

part 'app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (!islogin || tokans.isEmpty) {
      return const RouteSettings(name: Routes.login);
    }
    return null;
  }
}

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
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.productInLocker,
      page: () => const MainLayoutScreen(initialRoute: _Paths.productInLocker),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.home,
      page: () => const MainLayoutScreen(initialRoute: _Paths.home),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.custList,
      page: () => const MainLayoutScreen(initialRoute: _Paths.custList),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.custDetail,
      page: () => const MainLayoutScreen(initialRoute: _Paths.custDetail),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.addCustForm,
      page: () => const MainLayoutScreen(initialRoute: _Paths.addCustForm),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.updateCustForm,
      page: () => const MainLayoutScreen(initialRoute: _Paths.updateCustForm),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.giriviList,
      page: () => const MainLayoutScreen(initialRoute: _Paths.giriviList),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.giriviadd,
      page: () => const MainLayoutScreen(initialRoute: _Paths.giriviadd),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.AddProduct,
      page: () => const MainLayoutScreen(initialRoute: _Paths.AddProduct),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.giriviDetail,
      page: () => const MainLayoutScreen(initialRoute: _Paths.giriviDetail),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.pendingProduct,
      page: () => const MainLayoutScreen(initialRoute: _Paths.pendingProduct),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.returnProduct,
      page: () => const MainLayoutScreen(initialRoute: _Paths.returnProduct),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.karkitProduct,
      page: () => const MainLayoutScreen(initialRoute: _Paths.karkitProduct),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.soldProduct,
      page: () => const MainLayoutScreen(initialRoute: _Paths.soldProduct),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.dueGirvi,
      page: () => const MainLayoutScreen(initialRoute: _Paths.dueGirvi),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.dueOverGirvi,
      page: () => const MainLayoutScreen(initialRoute: _Paths.dueOverGirvi),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.metalMaster,
      page: () => const MainLayoutScreen(initialRoute: _Paths.metalMaster),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.categoryMaster,
      page: () => const MainLayoutScreen(initialRoute: _Paths.categoryMaster),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.customerTypeMaster,
      page: () => const MainLayoutScreen(initialRoute: _Paths.customerTypeMaster),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.lockerCodeMaster,
      page: () => const MainLayoutScreen(initialRoute: _Paths.lockerCodeMaster),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.addLockerCode,
      page: () => const MainLayoutScreen(initialRoute: _Paths.addLockerCode),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.metalTouch,
      page: () => const MainLayoutScreen(initialRoute: _Paths.metalTouch),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.yearMaster,
      page: () => const MainLayoutScreen(initialRoute: _Paths.yearMaster),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.addYearMaster,
      page: () => const MainLayoutScreen(initialRoute: _Paths.addYearMaster),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.productInLockerDetail,
      page: () => const MainLayoutScreen(initialRoute: _Paths.productInLockerDetail),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.changeTheLocker,
      page: () => const MainLayoutScreen(initialRoute: _Paths.changeTheLocker),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.lockerTransaction,
      page: () => const MainLayoutScreen(initialRoute: _Paths.lockerTransaction),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.lockerTransationDetail,
      page: () => const MainLayoutScreen(initialRoute: _Paths.lockerTransationDetail),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.report,
      page: () => const MainLayoutScreen(initialRoute: _Paths.report),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.exportContacts,
      page: () => const MainLayoutScreen(initialRoute: _Paths.exportContacts),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.reportView,
      page: () => const MainLayoutScreen(initialRoute: _Paths.reportView),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.profile,
      page: () => const MainLayoutScreen(initialRoute: _Paths.profile),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
