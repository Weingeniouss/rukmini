part of 'app_pages.dart';

abstract class Routes {
  //Splash
    static const splash = _Paths.splash;

  //Credentials
    //Login
      static const login = _Paths.login;

  //Drawer
    // Home
      // Customer
        static const home = _Paths.home;
        static const custList = _Paths.custList;
        static const custDetail = _Paths.custDetail;
        static const addCustForm = _Paths.addCustForm;
}

abstract class _Paths {
  //Splash
  static const splash = '/splash';

  //Credentials
    //Login
     static const login = '/login';

  //Drawer
    // Home
      // Customer
        static const home = '/home';
        static const custList = '/custList';
        static const custDetail = '/custDetail';
        static const addCustForm = '/addCustForm';
}
