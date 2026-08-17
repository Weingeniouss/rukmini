// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/controller/api/services/drawer/home/customres/custUpdate_service.dart';
import 'package:rukmini/modal/drawer/home/customer/update_customer_model.dart';

class CustUpdateController extends GetxController {
  final CustUpdateServices _custUpdateServices = CustUpdateServices();
  var isLoading = false.obs;
  var updateData = UpdateCustomerModel().obs;

  Future<http.Response?> updateCustomer({
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
    try {
      isLoading.value = true;
      final http.Response response = await _custUpdateServices.custUpdateApi(
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

      if (kDebugMode) {
        print('CustUpdate ${AppString.responseLog}${response.body}');
      }

      if (response.statusCode == 200) {
        String body = response.body;
        if (body.contains('{') && body.contains('}')) {
          body = body.substring(body.indexOf('{'), body.lastIndexOf('}') + 1);
        }
        final decoded = jsonDecode(body);
        if (decoded is Map<String, dynamic>) {
          updateData.value = UpdateCustomerModel.fromJson(decoded);
        }
      }
      return response;
    } catch (e) {
      if (kDebugMode) print('CustUpdate ${AppString.errorLog}$e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
