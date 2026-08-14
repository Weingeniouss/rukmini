// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/app_URL.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/view/utils/app_constants.dart';

class ProductTypeAddServices {
  final String url = AppUrl.productTypeAdd;
  final apiKey = AppUrl.apiKey;

  Future<http.Response> productTypeAddApi({
    required String name,
    String? productTypeId,
    required String rate,
  }) async {
    final request = http.MultipartRequest('POST', Uri.parse(url));

    request.headers.addAll({
      AppString.apiKey: apiKey,
      AppString.logintokan: tokans,
      AppString.userid: userId,
    });

    request.fields[AppString.productType_Name] = name;
    request.fields[AppString.productType_Rate] = rate;

    if (productTypeId != null && productTypeId.isNotEmpty) {
      request.fields[AppString.productType_Id] = productTypeId;
    }

    if (kDebugMode) {
      print('--- ProductTypeADD API Request ---');
      print('URL: $url');
      print('Fields: ${request.fields}');
      print('--- ProductTypeADD API Request ---');
    }

    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }
}
