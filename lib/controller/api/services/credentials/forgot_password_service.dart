import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../view/utils/app_String.dart';
import '../../../../view/utils/app_URL.dart';

class ForgotPasswordServices {
  final String url = AppUrl.forgetPassword;
  final apiKey = AppUrl.apiKey;

  Future<http.Response> forgotPasswordApi({
    required String email,
  }) async {
    final Map<String, String> headers = {
      AppString.apiKey: apiKey,
    };

    final Map<String, dynamic> body = {
      AppString.emailBody: email,
    };

    if (kDebugMode) {
      print('--- ForgotPassword API Request ---');
      print('URL: $url');
      print('Headers: $headers');
      print('Body: $body');
      print('--- ForgotPassword API Request ---');
    }
    return await http.post(Uri.parse(url), headers: headers, body: body);
  }
}
