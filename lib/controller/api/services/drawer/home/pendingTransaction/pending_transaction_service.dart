import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/app_URL.dart';
import 'package:rukmini/view/utils/app_constants.dart';

class PendingTransactionServices {
  final String url = AppUrl.pendingTranscation;
  final apiKey = AppUrl.apiKey;

  Future<http.Response> pendingTransactionApi({
    String? timezone,
    String? page,
    String? search,
    String? isFilterer,
    String? locality,
  }) async {
    final headers = {
      AppString.apiKey: apiKey,
      AppString.logintokan: tokans,
      AppString.userid: userId,
    };

    final Map<String, String> queryParameters = {
      AppString.page: page ?? '1',
    };

    if (timezone != null && timezone.isNotEmpty) {
      queryParameters[AppString.timezone] = timezone;
    }
    if (search != null && search.isNotEmpty) {
      queryParameters[AppString.Search] = search;
    }
    if (isFilterer != null && isFilterer.isNotEmpty) {
      queryParameters[AppString.isFilterer] = isFilterer;
    }
    if (locality != null && locality.isNotEmpty) {
      queryParameters[AppString.locality] = locality;
    }

    final uri = Uri.parse(url).replace(queryParameters: queryParameters);

    if (kDebugMode) {
      print('--- PendingTransaction API Request ---');
      print('URL: $uri');
      print('Headers: $headers');
      print('--- PendingTransaction API Request ---');
    }

    return await http.get(
      uri,
      headers: headers,
    );
  }
}
