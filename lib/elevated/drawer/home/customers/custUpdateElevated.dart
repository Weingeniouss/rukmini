// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:rukmini/controller/api/controllers/drawer/home/customers/custUpdate_Controller.dart';
import 'package:rukmini/modal/drawer/home/customer/update_customer_model.dart';
import 'package:rukmini/view/utils/widget/pop.dart';

Future<UpdateCustomerModel?> postUpdateCustomer({
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
  final CustUpdateController updateController = Get.put(CustUpdateController());
  final http.Response? response = await updateController.updateCustomer(
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

  if (response != null) {
    if (kDebugMode) {
      print('--- Customer Update API Response ---');
      print('Body: ${response.body}');
      print('--- Customer Update API Response ---');
    }

    String body = response.body;
    if (body.contains('{') && body.contains('}')) {
      body = body.substring(body.indexOf('{'), body.lastIndexOf('}') + 1);
    }

    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) {
      final updateModel = UpdateCustomerModel.fromJson(decoded);
      if (response.statusCode == 200) {
        if (updateModel.status == true) {
          ToastificationSuccess.Success(
            updateModel.message ?? 'Customer updated successfully',
          );
          return updateModel;
        } else {
          ToastificationError.Error(
            updateModel.message ?? 'Failed to update customer',
          );
        }
      } else {
        ToastificationError.Error('${updateModel.message}');
      }
    } else {
      ToastificationError.Error('Invalid server response format');
    }
  }
  return null;
}
