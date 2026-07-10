// ignore_for_file: file_names, unused_local_variable

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/app_URL.dart';

import '../../../../../../view/utils/app_constants.dart';

class AddcustformServices {
  final String url = AppUrl.custAdd;
  final apiKey = AppUrl.apiKey;

  Future<http.Response> addcustformApi({
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
    final queryParameters = {
      AppString.apiKey: apiKey,
      AppString.logintokan: tokans,
      AppString.userid: userId,
    };

    final body = {
      AppString.name_Body: name,
      AppString.typeDel_Body: typeDel,
      AppString.phoneDel_Body: phoneDel,
      AppString.address_Body: address,
      AppString.gender_Body: gender,
      AppString.nName_Body: nName ?? '',
      AppString.nPhone_Body: nPhone ?? '',
      AppString.custRelation_Body: custRelation ?? '',
      AppString.gracePeriod_Body: gracePeriod ?? '',
      AppString.isProfile_Body: isProfile ?? '',
      AppString.profileName_Body: profileName ?? '',
      AppString.profile_Body: (profile ?? []).join(','),
      AppString.proof_Body: (proof ?? []).join(','),
    };

    if (kDebugMode) {
      print('--- Add Customer Form API Request ---');
      print('URL: $url');
      print('Headers: $queryParameters');
      print('Body: $body');
      print('--- Add Customer Form API Request ---');
    }

    return await http.post(
      Uri.parse(url),
      headers: queryParameters,
      body: body,
    );
  }
}
