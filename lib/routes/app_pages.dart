import 'package:get/get.dart';
import 'package:rukmini/view/screen/home/home.dart';
import '../view/screen/splash/splash.dart';
import '../view/screen/credentials/login.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    GetPage(name: _Paths.splash, page: () => Splash()),
    GetPage(name: _Paths.login, page: () => Login()),
    GetPage(name: _Paths.home, page: () => Home()),
  ];
}
