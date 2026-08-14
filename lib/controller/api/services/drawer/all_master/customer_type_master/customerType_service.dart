// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../../../view/utils/app_String.dart';
import '../../../../../../view/utils/app_URL.dart';
import '../../../../../../view/utils/app_constants.dart';

class CustomerTypeServices {
  final String listUrl = AppUrl.custTypeList;
  final String addUrl = AppUrl.custTypeAdd;
  final String removeUrl = AppUrl.custTypeRemove;
  final apiKey = AppUrl.apiKey;

  Future<http.Response> customerTypeListApi() async {
    final Map<String, String> headers = {
      AppString.apiKey: apiKey,
      AppString.logintokan: tokans,
      AppString.userid: userId,
    };
    final uri = Uri.parse(listUrl);
    if (kDebugMode) {
      print('--- CustomerType List API Request ---');
      print('URL: $uri');
      print('--- CustomerType List API Request ---');
    }
    return await http.get(uri, headers: headers);
  }

  Future<http.Response> customerTypeAddApi({required String name, String? typeId}) async {
    final request = http.MultipartRequest('POST', Uri.parse(addUrl));
    request.headers.addAll({
      AppString.apiKey: apiKey,
      AppString.logintokan: tokans,
      AppString.userid: userId,
    });
    request.fields[AppString.customerType_Name] = name;
    if (typeId != null && typeId.isNotEmpty) {
      request.fields[AppString.customerType_Id] = typeId;
    }
    if (kDebugMode) {
      print('--- CustomerType Add API Request ---');
      print('URL: $addUrl');
      print('Fields: ${request.fields}');
      print('--- CustomerType Add API Request ---');
    }
    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  Future<http.Response> customerTypeRemoveApi({required String typeId}) async {
    final Map<String, String> headers = {
      AppString.apiKey: apiKey,
      AppString.logintokan: tokans,
      AppString.userid: userId,
    };
    final Map<String, String> queryParameters = {
      AppString.customerType_Id: typeId,
    };
    final uri = Uri.parse(removeUrl).replace(queryParameters: queryParameters);
    if (kDebugMode) {
      print('--- CustomerType Remove API Request ---');
      print('URL: $uri');
      print('--- CustomerType Remove API Request ---');
    }
    return await http.get(uri, headers: headers);
  }
}
