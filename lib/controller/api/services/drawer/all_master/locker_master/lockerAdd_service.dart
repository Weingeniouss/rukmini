// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../../../view/utils/app_String.dart';
import '../../../../../../view/utils/app_URL.dart';
import '../../../../../../view/utils/app_constants.dart';

class LockerAddServices {
  final String url = AppUrl.lockerAdd;
  final apiKey = AppUrl.apiKey;

  Future<http.Response> lockerAddApi({
    required String lockerCode,
    required String comName,
    required String comAddress,
    required String personName,
    required String personPhone,
    required String interestRate,
    required String isDefault,
    String? lockerId,
  }) async {
    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll({
      AppString.apiKey: apiKey,
      AppString.logintokan: tokans,
      AppString.userid: userId,
    });

    request.fields['LockerCode'] = lockerCode;
    request.fields['ComName'] = comName;
    request.fields['ComAddress'] = comAddress;
    request.fields['PersonName'] = personName;
    request.fields['PersonPhone'] = personPhone;
    request.fields['InterestRate'] = interestRate;
    request.fields['IsDefault'] = isDefault;

    if (lockerId != null && lockerId.isNotEmpty) {
      request.fields['LockerId'] = lockerId;
    }

    if (kDebugMode) {
      print('--- Locker Add API Request ---');
      print('URL: $url');
      print('Fields: ${request.fields}');
      print('--- Locker Add API Request ---');
    }

    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }
}
