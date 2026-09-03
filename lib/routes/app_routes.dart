// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  //Splash
    static const splash = _Paths.splash;

  //Credentials
    //Login
      static const login = _Paths.login;

  //Drawer
    static const allMaster = _Paths.allMaster;
    static const productInLocker = _Paths.productInLocker;
    // Home
      // Customer
        static const home = _Paths.home;
        static const custList = _Paths.custList;
        static const custDetail = _Paths.custDetail;
        static const addCustForm = _Paths.addCustForm;
        static const updateCustForm = _Paths.updateCustForm;
      // Girivi
        static const giriviList = _Paths.giriviList;
        static const giriviadd = _Paths.giriviadd;
        static const AddProduct = _Paths.AddProduct;
        static const giriviDetail = _Paths.giriviDetail;
      // Pending Product
        static const pendingProduct = _Paths.pendingProduct;
      // Return Product
        static const returnProduct = _Paths.returnProduct;
      // Karkit Product
        static const karkitProduct = _Paths.karkitProduct;
      // Sold Product
        static const soldProduct = _Paths.soldProduct;
      // Due Girvi
        static const dueGirvi = _Paths.dueGirvi;
      // Due Over Girvi
        static const dueOverGirvi = _Paths.dueOverGirvi;
    // Home

    //All Mastart
      // Metal Master
        static const metalMaster = _Paths.metalMaster;
      // Category Master
        static const categoryMaster = _Paths.categoryMaster;
      // Customer Type Master
        static const customerTypeMaster = _Paths.customerTypeMaster;
      //Locker Code Master
        static const lockerCodeMaster = _Paths.lockerCodeMaster;
        static const addLockerCode = _Paths.addLockerCode;
      //Metal Touch
        static const metalTouch = _Paths.metalTouch;
      //Year Master
        static const yearMaster = _Paths.yearMaster;
      //Add Year Master
        static const addYearMaster = _Paths.addYearMaster;
    //All Mastart

    //Product In Locker
        static const productInLockerDetail = _Paths.productInLockerDetail;
        static const changeTheLocker = _Paths.changeTheLocker;
    //Product In Locker

    //Locker Transaction
        static const lockerTransaction = _Paths.lockerTransaction;
        static const lockerTransationDetail = _Paths.lockerTransationDetail;
    //Locker Transaction

    //Report
        static const report = _Paths.report;
        static const exportContacts = _Paths.exportContacts;
        static const reportView = _Paths.reportView;
    //Report
    //Profile
        static const profile = _Paths.profile;
    //Profile
  //Drawer
}

abstract class _Paths {
  //Splash
  static const splash = '/splash';

  //Credentials
    //Login
     static const login = '/login';

  //Drawer
  static const allMaster = '/allMaster';
  static const productInLocker = '/productInLocker';
    // Home
      // Customer
        static const home = '/home';
        static const custList = '/custList';
        static const custDetail = '/custDetail';
        static const addCustForm = '/addCustForm';
        static const updateCustForm = '/updateCustForm';
     // Girivi
        static const giriviList = '/giriviList';
        static const giriviadd = '/giriviadd';
        static const AddProduct = '/AddProduct';
        static const giriviDetail = '/giriviDetail';
     // Pending Product
        static const pendingProduct = '/pendingProduct';
     // Return Product
        static const returnProduct = '/returnProduct';
     // Karkit Product
        static const karkitProduct = '/karkitProduct';
     // Sold Product
        static const soldProduct = '/soldProduct';
     // Due Girvi
        static const dueGirvi = '/dueGirvi';
     // Due Over Girvi
        static const dueOverGirvi = '/dueOverGirvi';
    // Home

    //All Mastart
        // Metal Master
          static const metalMaster = '/metalMaster';
        // Category Master
          static const categoryMaster = '/categoryMaster';
        // Customer Type Master
          static const customerTypeMaster = '/customerTypeMaster';
        //Locker Code Master
          static const lockerCodeMaster = '/lockerCodeMaster';
          static const addLockerCode = '/addLockerCode';
       //Metal Touch
          static const metalTouch = '/metalTouch';
       //Year Master
          static const yearMaster = '/yearMaster';
          static const addYearMaster = '/addYearMaster';
    //All Mastart

    //Product In Locker
          static const productInLockerDetail = '/productInLockerDetail';
          static const changeTheLocker = '/changeTheLocker';
    //Product In Locker

    //Locker Transaction
          static const lockerTransaction = '/lockerTransaction';
          static const lockerTransationDetail = '/lockerTransationDetail';
    //Locker Transaction

    //Report
          static const report = '/report';
          static const exportContacts = '/exportContacts';
          static const reportView = '/reportView';
    //Report
    //Profile
          static const profile = '/profile';
    //Profile
  //Drawer
}
