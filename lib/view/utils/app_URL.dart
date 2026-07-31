// ignore_for_file: file_names

class AppUrl {
  //BaseURL
  static const baseURL = 'https://balaji.weingenious.in/';
  static const baseAPI = '${baseURL}api/v1/';
  static const apiKey = '0A2CDC5AFCFB7D91432684960959A84D';

  //Year
  static const yearList = '${baseAPI}years/yearsList';

  //metal
  static const metalList = '${baseAPI}metal_touch/metalList';

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
        static const lockerRemove = '${baseAPI}locker/LockerRemove';
}
