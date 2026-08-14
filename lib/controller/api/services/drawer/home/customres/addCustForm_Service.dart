// ignore_for_file: curly_braces_in_flow_control_structures, file_names

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/app_URL.dart';
import 'package:rukmini/view/utils/app_constants.dart';

class AddcustformServices {
  final String url = AppUrl.custAdd;
  final apiKey = AppUrl.apiKey;

  Future<http.Response> addcustformApi({
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
    final request = http.MultipartRequest('POST', Uri.parse(url));

    request.headers.addAll({
      AppString.apiKey: apiKey,
      AppString.logintokan: tokans,
      AppString.userid: userId,
    });

    // Prepare fields
    request.fields[AppString.name_Body] = name;
    request.fields[AppString.typeDel_Body] = typeDel;
    request.fields[AppString.address_Body] = address;
    request.fields[AppString.gender_Body] = gender;

    if (nName != null && nName.isNotEmpty)
      request.fields[AppString.nName_Body] = nName;
    if (nPhone != null && nPhone.isNotEmpty)
      request.fields[AppString.nPhone_Body] = nPhone;
    if (custRelation != null && custRelation.isNotEmpty)
      request.fields[AppString.custRelation_Body] = custRelation;
    if (gracePeriod != null && gracePeriod.isNotEmpty)
      request.fields[AppString.gracePeriod_Body] = gracePeriod;
    if (isProfile != null && isProfile.isNotEmpty)
      request.fields[AppString.isProfile_Body] = isProfile;

    // Handle Phone Numbers - Pass as JSON array of objects: [{"Phone": "...", "IsDefault": "1"}]
    if (phones != null && phones.isNotEmpty) {
      List<Map<String, String>> phoneData = [];
      for (int i = 0; i < phones.length; i++) {
        phoneData.add({
          'Phone': phones[i],
          'IsDefault': i == 0 ? '1' : '0',
        });
      }
      request.fields[AppString.phoneDel_Body] = jsonEncode(phoneData);
    } else if (phoneDel.isNotEmpty) {
      request.fields[AppString.phoneDel_Body] = phoneDel;
    }

    // Profile and Proof names
    if (profileNames != null && profileNames.isNotEmpty) {
      for (int i = 0; i < profileNames.length; i++) {
        if (profileNames[i].isNotEmpty) {
          request.fields['ProfileName[$i]'] = profileNames[i];
        }
      }
    }
    if (proofNames != null && proofNames.isNotEmpty) {
      for (int i = 0; i < proofNames.length; i++) {
        if (proofNames[i].isNotEmpty) {
          request.fields['PName[$i]'] = proofNames[i];
        }
      }
    }

    // Add Profile Images
    if (profileImages != null) {
      for (var image in profileImages) {
        if (image != null) {
          request.files.add(
            await http.MultipartFile.fromPath('Profile[]', image.path),
          );
        }
      }
    }

    // Add Proof Images
    if (proofImages != null) {
      for (var image in proofImages) {
        if (image != null) {
          request.files.add(
            await http.MultipartFile.fromPath('Proof[]', image.path),
          );
        }
      }
    }

    if (kDebugMode) {
      print('--- Add Customer Multipart Request ---');
      print('URL: $url');
      print('Fields: ${request.fields}');
      print('--- Add Customer Multipart Request ---');
    }

    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }
}
