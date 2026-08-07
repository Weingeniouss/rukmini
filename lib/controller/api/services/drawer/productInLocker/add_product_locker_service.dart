import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/app_URL.dart';
import 'package:rukmini/view/utils/app_constants.dart';

class AddProductLockerService {
  final String url = AppUrl.productInLockerDetail;
  final apiKey = AppUrl.apiKey;

  Future<http.Response> addProductLockerApi({
    required String lockerId,
    required String interestRate,
    required String lockerProdDel,
    required String lockerCode,
    required String lockerDate,
  }) async {
    final headers = {
      AppString.apiKey: apiKey,
      AppString.logintokan: tokans,
      AppString.userid: userId,
    };

    final body = {
      'LockerId': lockerId,
      'InterestRate': interestRate,
      'LockerProdDel': lockerProdDel,
      'LockerCode': lockerCode,
      'LockerDate': lockerDate,
    };

    if (kDebugMode) {
      print('--- AddProductLocker API Request ---');
      print('URL: $url');
      print('Headers: $headers');
      print('Body: $body');
      print('--- AddProductLocker API Request ---');
    }

    return await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
  }
}
