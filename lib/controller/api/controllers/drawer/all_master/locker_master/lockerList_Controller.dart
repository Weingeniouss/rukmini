// ignore_for_file: file_names

import 'package:rukmini/view/utils/app_String.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/api/services/drawer/all_master/locker_master/lockerList_service.dart';
import 'package:rukmini/modal/drawer/allMaster/locker_master/locker_master_modal.dart';

class LockerListController extends GetxController {
  final LockerListServices _services = LockerListServices();
  var isLoading = false.obs;
  var lockerList = <LockerData>[].obs;
  var filteredLockerList = <LockerData>[].obs;
  var isSearching = false.obs;
  final searchTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    searchTextController.addListener(() {
      filterLocker(searchTextController.text);
    });
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }

  Future<http.Response?> getLockerList() async {
    try {
      isLoading.value = true;
      final http.Response response = await _services.lockerListApi();
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          final model = LockerMasterModal.fromJson(decoded);
          lockerList.assignAll(model.data ?? []);
          filteredLockerList.assignAll(model.data ?? []);
        }
      }
      return response;
    } catch (e) {
      if (kDebugMode) print('LockerList ${AppString.errorLog}$e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  void filterLocker(String query) {
    if (query.isEmpty) {
      filteredLockerList.assignAll(lockerList);
    } else {
      filteredLockerList.assignAll(
        lockerList.where((locker) {
          return (locker.lockerCode?.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ??
                  false) ||
              (locker.comName?.toLowerCase().contains(query.toLowerCase()) ??
                  false) ||
              (locker.personName?.toLowerCase().contains(query.toLowerCase()) ??
                  false);
        }).toList(),
      );
    }
  }
}
