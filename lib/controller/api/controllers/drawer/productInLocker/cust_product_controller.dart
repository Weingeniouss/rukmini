import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/view/utils/app_String.dart';
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

  Future<http.Response?> getCustProduct() async {
    try {
      isLoading.value = true;
      final http.Response response = await _custProductService.custProductApi();

      if (kDebugMode) {
        print('CustProduct Response: ${response.body}');
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
            productList.assignAll(model.data?.productList ?? []);
            applyFilters(); // Apply filters to initial data
          }
        }
      }
      return response;
    } catch (e) {
      if (kDebugMode) print('CustProduct Error: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
