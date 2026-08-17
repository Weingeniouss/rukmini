import 'package:rukmini/view/utils/app_String.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/api/services/drawer/home/pendingTransaction/pending_transaction_service.dart';
import 'package:rukmini/modal/drawer/home/pendingTransaction/pending_transaction_model.dart';

class PendingTransactionController extends GetxController {
  final PendingTransactionServices _pendingTransactionServices = PendingTransactionServices();
  var isLoading = false.obs;
  var isLoadMore = false.obs;
  var pendingTransactionData = PendingTransactionModel().obs;
  var pendingTransactionList = <PendingTransactionData>[].obs;

  var currentPage = 1;
  var hasMoreData = true.obs;

  final searchTextController = TextEditingController();
  var isSearching = false.obs;
  var currentFilter = RxnString();

  final localityTextController = TextEditingController();
  var isLocalitySearching = false.obs;

  @override
  void onClose() {
    searchTextController.dispose();
    localityTextController.dispose();
    super.onClose();
  }

  Future<http.Response?> pendingTransaction({
    bool isRefresh = false,
    bool isLoadMoreAction = false,
    String? search,
    String? isFilterer,
    String? locality,
  }) async {
    try {
      if (isRefresh) {
        currentPage = 1;
        hasMoreData.value = true;
        pendingTransactionList.clear();
        isLoading.value = true;
      } else if (isLoadMoreAction) {
        if (!hasMoreData.value) return null;
        isLoadMore.value = true;
      } else {
        isLoading.value = true;
        currentPage = 1;
        hasMoreData.value = true;
        pendingTransactionList.clear();
      }

      final http.Response response = await _pendingTransactionServices.pendingTransactionApi(
        page: currentPage.toString(),
        search: search,
        isFilterer: isFilterer,
        locality: locality,
      );

      if (kDebugMode) {
        print('PendingTransaction ${AppString.responseLog}${response.body}');
      }

      if (response.statusCode == 200) {
        String body = response.body;
        if (body.contains('{') && body.contains('}')) {
          body = body.substring(body.indexOf('{'), body.lastIndexOf('}') + 1);
        }
        final decoded = jsonDecode(body);
        if (decoded is Map<String, dynamic>) {
          final model = PendingTransactionModel.fromJson(decoded);
          pendingTransactionData.value = model;

          if (isRefresh || (!isLoadMoreAction && currentPage == 1)) {
            pendingTransactionList.assignAll(model.data ?? []);
          } else {
            pendingTransactionList.addAll(model.data ?? []);
          }

          if (model.data == null || model.data!.isEmpty) {
            hasMoreData.value = false;
          } else {
            currentPage++;
          }
        }
      }
      return response;
    } catch (e) {
      if (kDebugMode) print('PendingTransaction ${AppString.errorLog}$e');
      return null;
    } finally {
      isLoading.value = false;
      isLoadMore.value = false;
    }
  }
}
