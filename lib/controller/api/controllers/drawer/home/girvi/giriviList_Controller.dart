// ignore_for_file: file_names

import 'package:rukmini/view/utils/app_String.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/api/services/drawer/home/girvi/giriviList_services.dart';
import 'package:rukmini/modal/drawer/home/girvi/girvi_list_model.dart';

class GiriviListController extends GetxController {
  final GiriviListServices _giriviListServices = GiriviListServices();
  var isLoading = false.obs;
  var isLoadMore = false.obs;
  var giriviListData = GirviListModel().obs;
  var giriviList = <GirviData>[].obs;
  
  var currentPage = 1;
  var hasMoreData = true.obs;

  var selectedYearId = '0'.obs;
  var selectedYearTitle = 'All Years'.obs;

  var selectedFilterType = 'All'.obs;
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();
  final searchTextController = TextEditingController();
  var isSearching = false.obs;

  @override
  void onClose() {
    fromDateController.dispose();
    toDateController.dispose();
    searchTextController.dispose();
    super.onClose();
  }

  Future<http.Response?> getGiriviList({
    bool isRefresh = false,
    bool isLoadMoreAction = false,
    String? search,
    String? filterType,
    String? yearId,
    String? formDate,
    String? toDate,
  }) async {
    try {
      if (isRefresh) {
        currentPage = 1;
        hasMoreData.value = true;
      } else if (isLoadMoreAction) {
        if (!hasMoreData.value) return null;
        isLoadMore.value = true;
      } else {
        isLoading.value = true;
        currentPage = 1;
        hasMoreData.value = true;
      }

      final http.Response response = await _giriviListServices.giriviListApi(
        page: currentPage.toString(),
        Search: search,
        FilterType: filterType,
        YearId: yearId,
        FormDate: formDate,
        ToDate: toDate,
      );

      if (kDebugMode) {
        print('GiriviList ${AppString.responseLog}${response.body}');
      }

      if (response.statusCode == 200) {
        String body = response.body;
        if (body.contains('{') && body.contains('}')) {
          body = body.substring(body.indexOf('{'), body.lastIndexOf('}') + 1);
        }
        final decoded = jsonDecode(body);
        if (decoded is Map<String, dynamic>) {
          final model = GirviListModel.fromJson(decoded);
          giriviListData.value = model;

          if (isRefresh || (!isLoadMoreAction && currentPage == 1)) {
            giriviList.assignAll(model.data ?? []);
          } else {
            giriviList.addAll(model.data ?? []);
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
      if (kDebugMode) print('GiriviList ${AppString.errorLog}$e');
      return null;
    } finally {
      isLoading.value = false;
      isLoadMore.value = false;
    }
  }
}
