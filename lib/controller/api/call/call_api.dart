import 'package:image_picker/image_picker.dart';
import 'package:rukmini/elevated/credenials/loginElevated.dart';
import 'package:rukmini/elevated/drawer/home/customers/addCustElevated.dart';
import 'package:rukmini/elevated/drawer/home/customers/custDetailElevated.dart';
import 'package:rukmini/elevated/drawer/home/customers/custListElevated.dart';
import 'package:rukmini/elevated/drawer/home/customers/custRemoveElevated.dart';
import 'package:rukmini/elevated/drawer/home/customers/custUpdateElevated.dart';
import 'package:rukmini/elevated/drawer/home/dashboardElevated.dart';
import 'package:rukmini/elevated/drawer/home/girvi/giriviAddElevated.dart';
import 'package:rukmini/elevated/drawer/home/girvi/giriviListElevated.dart';
import 'package:rukmini/elevated/metal/metalListElevated.dart' as metal;
import 'package:rukmini/elevated/product/productListElevated.dart' as product;
import 'package:rukmini/elevated/product/productTypeElevated.dart' as productType;
import 'package:rukmini/elevated/year/yearListElevated.dart';
import 'package:rukmini/modal/drawer/home/customer/add_customer_model.dart';
import 'package:rukmini/modal/drawer/home/customer/update_customer_model.dart';
import 'package:rukmini/modal/drawer/home/girvi/girivi_add_model.dart';
import 'package:rukmini/modal/drawer/home/girvi/girvi_list_model.dart';
import 'package:rukmini/modal/metal/metalList_Modal.dart';
import 'package:rukmini/modal/product/productList_Modal.dart';
import 'package:rukmini/modal/product/productTypeList_Modal.dart';
import 'package:rukmini/modal/year/year_modal.dart';

class CallApi {
  // Credentials Login
  static Future<void> callLogin() async {
    await postLogin();
  }

  //Drawar
    //Home
        // Home Dashboard
        static Future<void> callDashboard() async {
          await getDashboard();
        }

        // Customer List
        static Future<void> callCustList({
          bool isRefresh = false,
          String? search,
        }) async {
          await getCustList(isRefresh: isRefresh, search: search);
        }

        // Customer Detail
        static Future<void> callCustDetail({String? custId}) async {
          await getCustDetail(custId: custId);
        }

        // Remove Customer
        static Future<void> callCustRemove({required String custId}) async {
          await postRemoveCustomer(custId: custId);
        }

        // Update Customer
        static Future<UpdateCustomerModel?> callCustUpdate({
          required String custId,
          required String name,
          required String typeDel,
          required String phoneDel,
          required String address,
          required String gender,
          List<String>? phones,
          String? custDelId,
          String? nName,
          String? nPhone,
          String? nomineeId,
          String? gracePeriod,
          String? custRelation,
          String? pName,
          String? isProfile,
          String? profileName,
          String? profileId,
          String? proofId,
          String? phoneId,
          String? eProofId,
          String? eProfileId,
          List<String>? profileNames,
          List<String>? proofNames,
          List<XFile?>? profileImages,
          List<XFile?>? proofImages,
        }) async {
          return await postUpdateCustomer(
            custId: custId,
            name: name,
            typeDel: typeDel,
            phoneDel: phoneDel,
            phones: phones,
            address: address,
            gender: gender,
            custDelId: custDelId,
            nName: nName,
            nPhone: nPhone,
            nomineeId: nomineeId,
            gracePeriod: gracePeriod,
            custRelation: custRelation,
            pName: pName,
            isProfile: isProfile,
            profileName: profileName,
            profileId: profileId,
            proofId: proofId,
            phoneId: phoneId,
            eProofId: eProofId,
            eProfileId: eProfileId,
            profileNames: profileNames,
            proofNames: proofNames,
            profileImages: profileImages,
            proofImages: proofImages,
          );
        }

        // Add Customer
        static Future<AddCustomerModel?> callAddCustomer({
          required String name,
          required String typeDel,
          required String phoneDel,
          required String address,
          required String gender,
          List<String>? phones,
          String? nName,
          String? nPhone,
          String? custRelation,
          String? gracePeriod,
          String? isProfile,
          String? profileName,
          List<String>? profileNames,
          List<String>? proofNames,
          List<XFile?>? profileImages,
          List<XFile?>? proofImages,
        }) async {
          return await postAddCustomer(
            name: name,
            typeDel: typeDel,
            phoneDel: phoneDel,
            phones: phones,
            address: address,
            gender: gender,
            nName: nName,
            nPhone: nPhone,
            custRelation: custRelation,
            gracePeriod: gracePeriod,
            isProfile: isProfile,
            profileName: profileName,
            profileNames: profileNames,
            proofNames: proofNames,
            profileImages: profileImages,
            proofImages: proofImages,
          );
        }

        // Girivi List
        static Future<GirviListModel?> callGiriviList({
          bool isRefresh = false,
          bool isLoadMoreAction = false,
          String? search,
          String? filterType,
          String? yearId,
          String? formDate,
          String? toDate,
        }) async {
          return await getGiriviList(
            isRefresh: isRefresh,
            isLoadMoreAction: isLoadMoreAction,
            search: search,
            filterType: filterType,
            yearId: yearId,
            formDate: formDate,
            toDate: toDate,
          );
        }

        // Add Girivi
        static Future<GiriviAddModel?> callAddGirivi({
          String? custId,
          String? girviDate,
          String? givenMonth,
          String? dueDate,
          String? interest,
          String? givenAmt,
          String? address,
          String? productDel,
          XFile? image_i,
        }) async {
          return await postAddGirivi(
            custId: custId,
            girviDate: girviDate,
            givenMonth: givenMonth,
            dueDate: dueDate,
            interest: interest,
            givenAmt: givenAmt,
            address: address,
            productDel: productDel,
            image_i: image_i,
          );
        }

        // Year List
        static Future<YearModel?> callYearList() async {
          return await getYearList();
        }

        // Metal List
        static Future<MetalListModal?> callMetalList() async {
          return await metal.getMetalList();
        }

        // Product Type List
        static Future<ProductTypeListModal?> callProductTypeList() async {
          return await productType.getProductTypeList();
        }

        // Product List
        static Future<ProductListModal?> callProductList({
          bool isRefresh = false,
          String? search,
        }) async {
          return await product.getProductList(
            isRefresh: isRefresh,
            search: search,
          );
        }
}
