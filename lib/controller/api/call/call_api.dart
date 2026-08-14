// ignore_for_file: non_constant_identifier_names, library_prefixes

import 'package:image_picker/image_picker.dart';
import 'package:rukmini/elevated/credenials/loginElevated.dart';
import 'package:rukmini/elevated/drawer/allMaster/category_Master/categoryElevated.dart' as category;
import 'package:rukmini/elevated/drawer/allMaster/category_Master/categoryRemoveElevated.dart';
import 'package:rukmini/elevated/drawer/home/customers/addCustElevated.dart';
import 'package:rukmini/elevated/drawer/home/customers/custDetailElevated.dart';
import 'package:rukmini/elevated/drawer/home/customers/custListElevated.dart';
import 'package:rukmini/elevated/drawer/home/customers/custRemoveElevated.dart';
import 'package:rukmini/elevated/drawer/home/customers/custUpdateElevated.dart';
import 'package:rukmini/elevated/drawer/home/dashboardElevated.dart';
import 'package:rukmini/elevated/drawer/locker/locker_detail_elevated.dart';
import 'package:rukmini/elevated/drawer/locker/locker_trans_elevated.dart';
import 'package:rukmini/elevated/drawer/locker/locker_wise_del_elevated.dart';
import 'package:rukmini/elevated/drawer/productInLocker/addProductLockerElevated.dart';
import 'package:rukmini/elevated/drawer/productInLocker/custProductElevated.dart';
import 'package:rukmini/elevated/drawer/home/girvi/giriviAddElevated.dart';
import 'package:rukmini/elevated/drawer/home/girvi/giriviDetailElevated.dart';
import 'package:rukmini/elevated/drawer/home/girvi/giriviListElevated.dart';
import 'package:rukmini/elevated/drawer/home/girvi/remove_girvie_elevated.dart';
import 'package:rukmini/elevated/drawer/home/girvi/close_girvie_elevated.dart';
import 'package:rukmini/elevated/drawer/home/pendingTransaction/pending_transaction_elevated.dart';
import 'package:rukmini/elevated/metal/metalListElevated.dart' as metal;
import 'package:rukmini/elevated/product/productListElevated.dart' as product;
import 'package:rukmini/elevated/product/productTypeElevated.dart' as productType;
import 'package:rukmini/elevated/product/productTypeAddElevated.dart';
import 'package:rukmini/elevated/metal/metalAddElevated.dart';
import 'package:rukmini/elevated/metal/metalRemoveElevated.dart';
import 'package:rukmini/elevated/drawer/allMaster/category_Master/categoryAddElevated.dart';
import 'package:rukmini/elevated/drawer/allMaster/customer_type_master/customerTypeElevated.dart' as customerType;
import 'package:rukmini/elevated/drawer/allMaster/customer_type_master/customerTypeAddElevated.dart';
import 'package:rukmini/elevated/drawer/allMaster/customer_type_master/customerTypeRemoveElevated.dart';
import 'package:rukmini/elevated/drawer/allMaster/locker_master/lockerElevated.dart' as locker;
import 'package:rukmini/elevated/drawer/allMaster/locker_master/lockerAddElevated.dart';
import 'package:rukmini/elevated/drawer/allMaster/locker_master/lockerRemoveElevated.dart';
import 'package:rukmini/elevated/product/productTypeRemoveElevated.dart';
import 'package:rukmini/elevated/year/yearListElevated.dart';
import 'package:rukmini/elevated/year/addYearElevated.dart';
import 'package:rukmini/elevated/year/yearRemoveElevated.dart';
import 'package:rukmini/modal/drawer/allMaster/category_Master/categoryAdd_modal.dart';
import 'package:rukmini/modal/drawer/allMaster/category_Master/categoryRemove_modal.dart';
import 'package:rukmini/modal/drawer/home/customer/add_customer_model.dart';
import 'package:rukmini/modal/drawer/home/customer/update_customer_model.dart';
import 'package:rukmini/modal/drawer/home/girvi/girivi_add_model.dart';
import 'package:rukmini/modal/drawer/home/girvi/girvi_detail_modal.dart';
import 'package:rukmini/modal/drawer/home/girvi/girvi_list_model.dart';
import 'package:rukmini/modal/drawer/home/girvi/remove_girvie_model.dart';
import 'package:rukmini/modal/drawer/home/girvi/close_girvie_model.dart';
import 'package:rukmini/modal/drawer/locker/locker_detail_modal.dart';
import 'package:rukmini/modal/drawer/locker/locker_trans_modal.dart';
import 'package:rukmini/modal/drawer/locker/locker_wise_del_modal.dart';
import 'package:rukmini/modal/drawer/productInLocker/add_product_locker_model.dart';
import 'package:rukmini/modal/drawer/productInLocker/cust_product_model.dart';
import 'package:rukmini/modal/drawer/home/pendingTransaction/pending_transaction_model.dart';
import 'package:rukmini/modal/metal/metalList_Modal.dart';
import 'package:rukmini/modal/product/productList_Modal.dart';
import 'package:rukmini/modal/product/productTypeList_Modal.dart';
import 'package:rukmini/modal/product/productTypeAdd_modal.dart';
import 'package:rukmini/modal/product/productTypeRemove_modal.dart';
import 'package:rukmini/modal/metal/metalAdd_modal.dart';
import 'package:rukmini/modal/drawer/allMaster/customer_type_master/customer_type_add_modal.dart';
import 'package:rukmini/modal/drawer/allMaster/customer_type_master/customer_type_master_modal.dart';
import 'package:rukmini/modal/drawer/allMaster/customer_type_master/customer_type_remove_modal.dart';
import 'package:rukmini/modal/drawer/allMaster/category_Master/categoryList_modal.dart';
import 'package:rukmini/modal/drawer/allMaster/locker_master/locker_add_modal.dart';
import 'package:rukmini/modal/drawer/allMaster/locker_master/locker_remove_modal.dart';
import 'package:rukmini/modal/drawer/allMaster/locker_master/locker_master_modal.dart';
import 'package:rukmini/modal/year/addYear_modal.dart';
import 'package:rukmini/modal/year/yearRemove_modal.dart';
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

        // Girivi Detail
        static Future<GiriviDetailModal?> callGiriviDetail({
          String? timezone,
          String? girviId,
        }) async {
          return await getGiriviDetail(timezone: timezone, girviId: girviId);
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

        // Remove Girvie
        static Future<RemoveGirvie?> callRemoveGirvie({
          required String girviId,
        }) async {
          return await postRemoveGirvie(girviId: girviId);
        }

        // Close Girvie
        static Future<CloseGirvie?> callCloseGirvie({
          required String girviId,
        }) async {
          return await postCloseGirvie(girviId: girviId);
        }

        // Cust Product In Locker
        static Future<CustProductModel?> callCustProduct() async {
          return await getCustProduct();
        }

        // Add Product Locker
        static Future<AddProductLockerModel?> callAddProductLocker({
          required String lockerId,
          required String interestRate,
          required String lockerProdDel,
          required String lockerCode,
          required String lockerDate,
        }) async {
          return await postAddProductLocker(
            lockerId: lockerId,
            interestRate: interestRate,
            lockerProdDel: lockerProdDel,
            lockerCode: lockerCode,
            lockerDate: lockerDate,
          );
        }

        // Locker List Trans
        static Future<LockerTransModal?> callLockerListTrans() async {
          return await getLockerTransList();
        }

        // Locker Wise Detail
        static Future<LockerWiseDelModal?> callLockerWiseDel({
          required String lockerId,
          String? page,
          String? search,
        }) async {
          return await getLockerWiseDel(
            lockerId: lockerId,
            page: page,
            search: search,
          );
        }

        // Locker Detail
        static Future<LockerDetailModal?> callLockerDetail({
          required String lockerId,
          required String code,
        }) async {
          return await getLockerDetail(
            lockerId: lockerId,
            code: code,
          );
        }

        // Pending Transaction
        static Future<PendingTransactionModel?> callPendingTransaction({
          bool isRefresh = false,
          bool isLoadMoreAction = false,
          String? search,
          String? isFilterer,
          String? locality,
        }) async {
          return await getPendingTransaction(
            isRefresh: isRefresh,
            isLoadMoreAction: isLoadMoreAction,
            search: search,
            isFilterer: isFilterer,
            locality: locality,
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

        // Product Type Add
        static Future<ProductTypeAddModal?> callProductTypeAdd({
          required String name,
          String? productTypeId,
          required String rate,
        }) async {
          return await postProductTypeAdd(
            name: name,
            productTypeId: productTypeId,
            rate: rate,
          );
        }

        // Product Type Remove
        static Future<ProductTypeRemoveModal?> callProductTypeRemove({
          required String productTypeId,
        }) async {
          return await postProductTypeRemove(productTypeId: productTypeId);
        }

        // Product List
        static Future<ProductListModal?> callProductList({
          bool isRefresh = false,
          String? search,
          String? filterType,
        }) async {
          return await product.getProductList(
            isRefresh: isRefresh,
            search: search,
            filterType: filterType,
          );
        }
    //Home

    //All Master
        //Category Master
            // Category List
                static Future<CategoryListModal?> callCategoryList() async {
                  return await category.getCategoryList();
                }

            // Category Remove
                static Future<CategoryRemoveModal?> callCategoryRemove({
                  required String categoryId,
                }) async {
                  return await postCategoryRemove(categoryId: categoryId);
                }

            // Category Add
                static Future<CategoryAddModal?> callCategoryAdd({
                  required String name,
                  String? categoryId,
                }) async {
                  return await postCategoryAdd(
                    name: name,
                    categoryId: categoryId,
                  );
                }

        //Customer Type Master
            // Customer Type List
                static Future<CustomerTypeMaster?> callCustomerTypeList() async {
                  return await customerType.getCustomerTypeList();
                }

            // Customer Type Add
                static Future<CustomerTypeAddModal?> callCustomerTypeAdd({
                  required String name,
                  String? typeId,
                }) async {
                  return await postCustomerTypeAdd(name: name, typeId: typeId);
                }

            // Customer Type Remove
                static Future<CustomerTypeRemoveModal?> callCustomerTypeRemove({
                  required String typeId,
                }) async {
                  return await postCustomerTypeRemove(typeId: typeId);
                }

        //Locker Master
            // Locker List
                static Future<LockerMasterModal?> callLockerList() async {
                  return await locker.getLockerList();
                }

            // Locker Add
                static Future<LockerAddModal?> callLockerAdd({
                  required String lockerCode,
                  required String comName,
                  required String comAddress,
                  required String personName,
                  required String personPhone,
                  required String interestRate,
                  required String isDefault,
                  String? lockerId,
                }) async {
                   await postLockerAdd(
                    lockerCode: lockerCode,
                    comName: comName,
                    comAddress: comAddress,
                    personName: personName,
                    personPhone: personPhone,
                    interestRate: interestRate,
                    isDefault: isDefault,
                    lockerId: lockerId,
                  );
                   return null;
                }

            // Locker Remove
                static Future<LockerRemoveModal?> callLockerRemove({required String lockerId}) async {
                  return await postLockerRemove(lockerId: lockerId);
                }

        //Metal Master
            // Metal Add
                static Future<MetalAddModal?> callMetalAdd({
                  required String karat,
                  required String goldContent,
                  String? metalId,
                }) async {
                  return await postMetalAdd(
                    karat: karat,
                    goldContent: goldContent,
                    metalId: metalId,
                  );
                }

            // Metal Remove
                static Future<MetalAddModal?> callMetalRemove({required String metalId}) async {
                  return await postMetalRemove(metalId: metalId);
                }

        //Year Master
            // Year Add
                static Future<AddYearModal?> callAddYear({
                  required String title,
                  required String fromDate,
                  required String toDate,
                  String? isCurrent,
                  String? yearId,
                }) async {
                  return await postAddYear(
                    title: title,
                    fromDate: fromDate,
                    toDate: toDate,
                    isCurrent: isCurrent,
                    yearId: yearId,
                  );
                }

            // Year Remove
                static Future<YearRemoveModal?> callYearRemove({
                  required String yearId,
                }) async {
                  return await postYearRemove(yearId: yearId);
                }

}
