// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../view/utils/app_String.dart';
import '../../../../view/utils/app_URL.dart';
import '../../../../view/utils/app_constants.dart';

class ProductListServices {
  final String url = AppUrl.productList;
  final apiKey = AppUrl.apiKey;

  Future<http.Response> productListApi({
    String? search,
    String? page,
    String? filterType,
    String? timezone,
  }) async {
    final Map<String, String> headers = {
      AppString.apiKey: apiKey,
      AppString.logintokan: tokans,
      AppString.userid: userId,
    };

    final Map<String, String> queryParameters = {
      AppString.Search: search ?? '',
      AppString.page: page ?? '1',
      AppString.FilterType: filterType ?? 'All',
      AppString.timezone: timezone ?? '',
    };

    final uri = Uri.parse(url).replace(queryParameters: queryParameters);

    if (kDebugMode) {
      print('--- ProductList API Request ---');
      print('URL: $uri');
      print('Headers: $headers');
      print('Params: $queryParameters');
      print('--- ProductList API Request ---');
    }
    return await http.get(uri, headers: headers);
  }
}
