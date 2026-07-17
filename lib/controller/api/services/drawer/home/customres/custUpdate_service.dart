// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/app_URL.dart';
import 'package:rukmini/view/utils/app_constants.dart';

class CustUpdateServices {
  final String url = AppUrl.custUpdate;
  final apiKey = AppUrl.apiKey;

  Future<http.Response> custUpdateApi({
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
    final request = http.MultipartRequest('POST', Uri.parse(url));

    request.headers.addAll({
      AppString.apiKey: apiKey,
      AppString.logintokan: tokans,
      AppString.userid: userId,
    });

    // Prepare fields
    request.fields[AppString.cusid] = custId;
    request.fields[AppString.name_Body] = name;
    request.fields[AppString.typeDel_Body] = typeDel;
    request.fields[AppString.address_Body] = address;
    request.fields[AppString.gender_Body] = gender;

    if (custDelId != null && custDelId.isNotEmpty)
      request.fields[AppString.custDelId_Body] = custDelId;
    if (nName != null && nName.isNotEmpty)
      request.fields[AppString.nName_Body] = nName;
    if (nPhone != null && nPhone.isNotEmpty)
      request.fields[AppString.nPhone_Body] = nPhone;
    if (nomineeId != null && nomineeId.isNotEmpty)
      request.fields[AppString.nomineeId_Body] = nomineeId;
    if (gracePeriod != null && gracePeriod.isNotEmpty)
      request.fields[AppString.gracePeriod_Body] = gracePeriod;
    if (custRelation != null && custRelation.isNotEmpty)
      request.fields[AppString.custRelation_Body] = custRelation;
    if (pName != null && pName.isNotEmpty)
      request.fields[AppString.pName_Body] = pName;
    if (isProfile != null && isProfile.isNotEmpty)
      request.fields[AppString.isProfile_Body] = isProfile;
    if (eProofId != null && eProofId.isNotEmpty)
      request.fields[AppString.eProofId_Body] = eProofId;
    if (eProfileId != null && eProfileId.isNotEmpty)
      request.fields[AppString.eProfileId_Body] = eProfileId;
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

    // IDs
    if (profileId != null && profileId.isNotEmpty) {
      List<String> ids = profileId.split(',');
      for (int i = 0; i < ids.length; i++) {
        request.fields['ProfileId[$i]'] = ids[i];
      }
    }
    if (proofId != null && proofId.isNotEmpty) {
      List<String> ids = proofId.split(',');
      for (int i = 0; i < ids.length; i++) {
        request.fields['ProofId[$i]'] = ids[i];
      }
    }
    if (phoneId != null && phoneId.isNotEmpty) {
      List<String> ids = phoneId.split(',');
      for (int i = 0; i < ids.length; i++) {
        request.fields['PhoneId[$i]'] = ids[i];
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
      print('--- Update Customer Multipart Request ---');
      print('URL: $url');
      print('Fields: ${request.fields}');
      print('--- Update Customer Multipart Request ---');
    }

    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }
}
