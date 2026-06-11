import 'package:get/get.dart';
import '../view/screen/splash/splash.dart';
import '../view/screen/credentials/login.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: _Paths.splash,
      page: () => const Splash(),
    ),
    GetPage(
      name: _Paths.login,
      page: () => const Login(),
    ),
  ];
}
