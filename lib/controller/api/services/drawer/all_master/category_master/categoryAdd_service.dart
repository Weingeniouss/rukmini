import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../../../view/utils/app_String.dart';
import '../../../../../../view/utils/app_URL.dart';
import '../../../../../../view/utils/app_constants.dart';

class CategoryAddServices {
  final String url = AppUrl.categoryAdd;
  final apiKey = AppUrl.apiKey;

  Future<http.Response> categoryAddApi({
    required String name,
    String? categoryId,
  }) async {
    final request = http.MultipartRequest('POST', Uri.parse(url));

    request.headers.addAll({
      AppString.apiKey: apiKey,
      AppString.logintokan: tokans,
      AppString.userid: userId,
    });

    request.fields[AppString.category_Name] = name;
    if (categoryId != null && categoryId.isNotEmpty) {
      request.fields[AppString.category_Id] = categoryId;
    }

    if (kDebugMode) {
      print('--- CategoryAdd API Request ---');
      print('URL: $url');
      print('Fields: ${request.fields}');
      print('--- CategoryAdd API Request ---');
    }

    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }
}
