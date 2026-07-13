// ignore_for_file: file_names

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:rukmini/view/utils/app_String.dart';
import '../../../../controller/api/controllers/drawer/home/customers/addCustForm_Controller.dart';
import '../../../../modal/drawer/home/customer/add_customer_model.dart';
import '../../../../view/utils/widget/pop.dart';

Future<AddCustomerModel?> postAddCustomer({
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
  final AddcustformController addCustController = Get.put(
    AddcustformController(),
  );
  final http.Response? response = await addCustController.addCustForm(
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

  if (response != null) {
    String body = response.body;
    // If the response contains HTML (PHP Errors), extract only the JSON part
    if (body.contains('{') && body.contains('}')) {
      body = body.substring(body.indexOf('{'), body.lastIndexOf('}') + 1);
    }

    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) {
      final addCustomerModel = AddCustomerModel.fromJson(decoded);
      if (response.statusCode == 200) {
        if (addCustomerModel.status == true) {
          ToastificationSuccess.Success(
            addCustomerModel.message ?? AppString.customeraddedsuccessfully,
          );
          return addCustomerModel;
        } else {
          ToastificationError.Error(
            addCustomerModel.message ?? AppString.failedtoaddcustomer,
          );
        }
      } else {
        ToastificationError.Error('${addCustomerModel.message}');
      }
    } else {
      ToastificationError.Error(AppString.invalidserverresponseformat);
    }
  }
  return null;
}
