part of 'app_pages.dart';

abstract class Routes {
  static const splash = _Paths.splash;
  static const login = _Paths.login;
  static const home = _Paths.home;
  static const custList = _Paths.custList;
  static const custDetail = _Paths.custDetail;
}

abstract class _Paths {
  static const splash = '/splash';
  static const login = '/login';
  static const home = '/home';
  static const custList = '/custList';
  static const custDetail = '/custDetail';
}
