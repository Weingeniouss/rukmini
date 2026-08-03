import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../view/utils/app_String.dart';
import '../../../../view/utils/app_URL.dart';
import '../../../../view/utils/app_constants.dart';

class MetalAddServices {
  final String url = AppUrl.metalAdd;
  final apiKey = AppUrl.apiKey;

  Future<http.Response> metalAddApi({
    required String karat,
    required String goldContent,
    String? metalId,
  }) async {
    final request = http.MultipartRequest('POST', Uri.parse(url));

    request.headers.addAll({
      AppString.apiKey: apiKey,
      AppString.logintokan: tokans,
      AppString.userid: userId,
    });

    request.fields[AppString.karat_Name] = karat;
    request.fields[AppString.gold_Content] = goldContent;

    if (metalId != null && metalId.isNotEmpty) {
      request.fields[AppString.metal_Id] = metalId;
    }

    if (kDebugMode) {
      print('--- MetalAdd API Request ---');
      print('URL: $url');
      print('Fields: ${request.fields}');
      print('--- MetalAdd API Request ---');
    }

    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }
}
