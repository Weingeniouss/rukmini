// ignore_for_file: file_names, non_constant_identifier_names

import 'package:rukmini/view/utils/app_String.dart';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
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
    try {
      isLoading.value = true;
      final http.Response response = await _AddcustformServices.addcustformApi(
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
      if (kDebugMode) {
        print('AddCustForm ${AppString.responseLog}${response.body}');
      }
      if (response.statusCode == 200) {
        String body = response.body;
        // If the response contains HTML (PHP Errors), extract only the JSON part
        if (body.contains('{') && body.contains('}')) {
          body = body.substring(body.indexOf('{'), body.lastIndexOf('}') + 1);
        }
        final decoded = jsonDecode(body);
        if (decoded is Map<String, dynamic>) {
          addCustdData.value = AddCustomerModel.fromJson(decoded);
        }
      }
      return response;
    } catch (e) {
      if (kDebugMode) print('AddCustData ${AppString.errorLog}$e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
