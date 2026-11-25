import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/view/utils/app_string.dart';
import 'package:rukmini/controller/api/services/drawer/productInLocker/cust_product_service.dart';
import 'package:rukmini/modal/drawer/productInLocker/cust_product_model.dart';

class CustProductController extends GetxController {
  final CustProductService _custProductService = CustProductService();
  var isLoading = false.obs;
  var custProductData = CustProductModel().obs;
  var custList = <CustList>[].obs;
  var productList = <ProductList>[].obs;
  var filteredProductList = <ProductList>[].obs;
  var selectedProducts = <ProductList>[].obs;

  var searchQuery = "".obs;
  var selectedLockerCode = "".obs;
  var selectedCustId = "".obs;
  var selectedCustName = AppString.selectCustomer.obs;

  var isSearching = false.obs;
  final searchController = TextEditingController();

  void toggleSelection(ProductList item) {
    if (selectedProducts.contains(item)) {
      selectedProducts.remove(item);
    } else {
      selectedProducts.add(item);
    }
  }

  void clearSelection() {
    selectedProducts.clear();
  }

  void updateSearch(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void toggleSearch() {
    isSearching.value = true;
  }

  void closeSearch() {
    isSearching.value = false;
    searchController.clear();
    updateSearch("");
  }

  void filterByLocker(String lockerCode) {
    selectedLockerCode.value = lockerCode;
    applyFilters();
  }

  void filterByCustomer(String custId, String name) {
    selectedCustId.value = custId;
    selectedCustName.value = name;
    applyFilters();
  }

  void resetLockerFilter() {
    selectedLockerCode.value = "";
    applyFilters();
  }

  void clearCustomerFilter() {
    selectedCustId.value = "";
    selectedCustName.value = AppString.selectCustomer;
    applyFilters();
  }

  void applyFilters() {
    var list = productList.where((p) {
      bool matchesSearch =
          searchQuery.value.isEmpty ||
          (p.custName?.toLowerCase().contains(
                searchQuery.value.toLowerCase(),
              ) ??
              false) ||
          (p.uniqueId?.contains(searchQuery.value) ?? false);

      bool matchesLocker =
          selectedLockerCode.value.isEmpty ||
          p.lockerCode?.toUpperCase() == selectedLockerCode.value.toUpperCase();

      bool matchesCust =
          selectedCustId.value.isEmpty || p.custId == selectedCustId.value;

      return matchesSearch && matchesLocker && matchesCust;
    }).toList();

    filteredProductList.assignAll(list);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<http.Response?> getCustProduct({bool forceLoading = false}) async {
    try {
      if (productList.isEmpty || forceLoading) {
        isLoading.value = true;
      }
      final http.Response response = await _custProductService.custProductApi();

      if (kDebugMode) {
        print('CustProduct ${AppString.responseLog}${response.body}');
      }

      if (response.statusCode == 200) {
        String body = response.body;
        if (body.contains('{') && body.contains('}')) {
          body = body.substring(body.indexOf('{'), body.lastIndexOf('}') + 1);
        }
        final decoded = jsonDecode(body);
        if (decoded is Map<String, dynamic>) {
          final model = CustProductModel.fromJson(decoded);
          custProductData.value = model;
          if (model.data != null) {
            custList.assignAll(model.data?.custList ?? []);

            List<ProductList> allProducts = [];
            Set<String> seenKeys = {};

            void addProductIfNew(ProductList p) {
              String key = (p.prodLockerId != null && p.prodLockerId!.trim().isNotEmpty)
                  ? p.prodLockerId!.trim()
                  : (p.productId != null && p.productId!.trim().isNotEmpty)
                      ? p.productId!.trim()
                      : (p.uniqueId != null && p.uniqueId!.trim().isNotEmpty)
                          ? p.uniqueId!.trim()
                          : '${p.custName}_${p.code}_${p.weight}';
              if (!seenKeys.contains(key)) {
                seenKeys.add(key);
                allProducts.add(p);
              }
            }

            if (model.data?.productList != null && model.data!.productList!.isNotEmpty) {
              for (var p in model.data!.productList!) {
                addProductIfNew(p);
              }
            }

            if (custList.isNotEmpty) {
              for (var cust in custList) {
                if (cust.productList != null && cust.productList!.isNotEmpty) {
                  for (var p in cust.productList!) {
                    if ((p.custName == null || p.custName!.trim().isEmpty) && cust.name != null) {
                      p.custName = cust.name;
                    }
                    if ((p.custId == null || p.custId!.trim().isEmpty) && cust.custId != null) {
                      p.custId = cust.custId;
                    }
                    addProductIfNew(p);
                  }
                }
              }
            }

            productList.assignAll(allProducts);
            applyFilters(); // Apply filters to initial data
          }
        }
      }
      return response;
    } catch (e) {
      if (kDebugMode) print('CustProduct ${AppString.errorLog}$e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
