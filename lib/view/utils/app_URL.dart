// ignore_for_file: file_names

class AppUrl {
  //BaseURL
  static const baseURL = 'https://balaji.weingenious.in/';
  static const baseAPI = '${baseURL}api/v1/';
  static const apiKey = '0A2CDC5AFCFB7D91432684960959A84D';

  //Year
  static const yearList = '${baseAPI}years/yearsList';
  static const yearAdd = '${baseAPI}years/yearsAdd';
  static const yearsRemove = '${baseAPI}years/yearsRemove';

  //metal
  static const metalList = '${baseAPI}metal_touch/metalList';
  static const metalAdd = '${baseAPI}metal_touch/metalAdd';
  static const metalRemove = '${baseAPI}metal_touch/metalRemove';

  //productType
  static const productTypeList = '${baseAPI}product/ProductTypeList';
  static const productTypeAdd = '${baseAPI}product/ProductTypeAdd';
  static const productTypeRemove = '${baseAPI}product/ProductTypeRemove';

  //product
  static const productList = '${baseAPI}girvi_master/ProductList';

  //Credentials
  static const login = '${baseAPI}user/login';
  static const forgetPassword = '${baseAPI}user/forgotPassword';

  //home
    static const dashboard = '${baseAPI}user/Dashboard';
      //customer
        static const custList = '${baseAPI}customer/CustList';
        static const custDetail = '${baseAPI}customer/CustDetail';
        static const custAdd = '${baseAPI}customer/CustAdd';
        static const custRemove = '${baseAPI}customer/CustRemove';
        static const custUpdate = '${baseAPI}customer/CustUpdate';
     //Girvi
        static const giriviList = '${baseAPI}girvi_master/GirviList';
        static const girviAdd = '${baseAPI}girvi_master/GirviAdd';
        static const girviDetail = '${baseAPI}girvi_master/GirviDetail';
        static const removeGirvie = '${baseAPI}girvi_master/RemoveGirvie';
        static const closeGirvie = '${baseAPI}girvi_master/CloseGirvi';
     //PendingTranscation
        static const pendingTranscation = '${baseAPI}girvi_master/PendingTranscation';
   //home

   //All Master
      //Metal Master
        static const categoryList = '${baseAPI}category/CategoryList';
        static const categoryRemove = '${baseAPI}category/CategoryRemove';
        static const categoryAdd = '${baseAPI}category/CategoryAdd';
      //Product Type Master
        static const customerTypeList = '${baseAPI}customer/CustomerTypeList';
        static const customerTypeAdd = '${baseAPI}customer/CustomerTypeAdd';
        static const customerTypeRemove = '${baseAPI}customer/CustomerTypeRemove';
      //Customer Type Master
        static const custTypeList = '${baseAPI}customer/CustTypeList';
        static const custTypeAdd = '${baseAPI}customer/CustTypeAdd';
        static const custTypeRemove = '${baseAPI}customer/CustTypeRemove';
      //Locker Master
        static const lockerList = '${baseAPI}locker/lockerList';
        static const lockerAdd = '${baseAPI}locker/lockerAdd';
        static const lockerRemove = '${baseAPI}locker/lockerRemove';
   //All Master

   //Product In Locker
        static const productInLocker = '${baseAPI}girvi_master/CustProduct';
        static const productInLockerDetail = '${baseAPI}girvi_master/AddProductLocker';
   //Product In Locker

   //LockerListTrans
        static const lockerListTrans = '${baseAPI}locker/lockerListTrans';
        static const lockerWiseDel = '${baseAPI}locker/lockerWiseDel';
        static const lockerDetail = '${baseAPI}locker/LockerDetail';
        static const lockerTrans = '${baseAPI}locker/LockerTrans';
   //LockerListTrans

   //Report
       static const customerReport = '${baseAPI}customer/CustReport';
   //Report
}
