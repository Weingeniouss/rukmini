import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../../../view/utils/app_String.dart';
import '../../../../../../view/utils/app_URL.dart';
import '../../../../../../view/utils/app_constants.dart';

class LockerServices {
  final String listUrl = AppUrl.lockerList;
  final String addUrl = AppUrl.lockerAdd;
  final String removeUrl = AppUrl.lockerRemove;
  final apiKey = AppUrl.apiKey;

  Future<http.Response> lockerListApi() async {
    final Map<String, String> headers = {
      AppString.apiKey: apiKey,
      AppString.logintokan: tokans,
      AppString.userid: userId,
    };
    final uri = Uri.parse(listUrl);
    if (kDebugMode) {
      print('--- Locker List API Request ---');
      print('URL: $uri');
      print('--- Locker List API Request ---');
    }
    return await http.get(uri, headers: headers);
  }

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
    final request = http.MultipartRequest('POST', Uri.parse(addUrl));
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
      print('URL: $addUrl');
      print('Fields: ${request.fields}');
      print('--- Locker Add API Request ---');
    }

    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }
}
