// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/api/services/drawer/home/customres/addCustForm_Service.dart';
import 'package:rukmini/modal/drawer/home/customer/add_customer_model.dart';

class AddcustformController extends GetxController {
  final AddcustformServices _AddcustformServices = AddcustformServices();
  var isLoading = false.obs;
  var addCustdData = AddCustomerModel().obs;

  Future<http.Response?> addCustForm({
    required String name,
    required String typeDel,
    required String phoneDel,
    required String address,
    required String gender,
    String? nName,
    String? nPhone,
    String? custRelation,
    String? gracePeriod,
    String? isProfile,
    String? profileName,
    List<String>? profile,
    List<String>? proof,
  }) async {
    try {
      isLoading.value = true;
      final http.Response response = await _AddcustformServices.addcustformApi(
        name: name,
        typeDel: typeDel,
        phoneDel: phoneDel,
        address: address,
        gender: gender,
        nName: nName ?? '',
        nPhone: nPhone ?? '',
        custRelation: custRelation ?? '',
        gracePeriod: gracePeriod ?? '',
        isProfile: isProfile ?? '',
        profileName: profileName ?? '',
        profile: profile ?? [],
        proof: proof ?? [],
      );
      if (kDebugMode) {
        print('AddCustForm Response: ${response.body}');
      }
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          addCustdData.value = AddCustomerModel.fromJson(decoded);
        }
      }
      return response;
    } catch (e) {
      if (kDebugMode) print('AddCustData Error: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
