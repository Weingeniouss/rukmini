import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/pop.dart';
import 'package:rukmini/controller/api/controllers/drawer/home/pendingTransaction/pending_transaction_controller.dart';
import 'package:rukmini/modal/drawer/home/pendingTransaction/pending_transaction_model.dart';

Future<PendingTransactionModel?> getPendingTransaction({
  bool isRefresh = false,
  bool isLoadMoreAction = false,
  String? search,
  String? isFilterer,
  String? locality,
}) async {
  final PendingTransactionController pendingTransactionController = Get.put(
    PendingTransactionController(),
  );

  final http.Response? response = await pendingTransactionController.pendingTransaction(
    isRefresh: isRefresh,
    isLoadMoreAction: isLoadMoreAction,
    search: search,
    isFilterer: isFilterer,
    locality: locality,
  );

  if (response != null) {
    String body = response.body;
    if (body.contains('{') && body.contains('}')) {
      body = body.substring(body.indexOf('{'), body.lastIndexOf('}') + 1);
    }

    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) {
      final model = PendingTransactionModel.fromJson(decoded);
      if (response.statusCode == 200) {
        if (model.status == true) return model;
        ToastificationError.Error(model.message ?? AppString.failedToLoadTransactions);
      } else {
        ToastificationError.Error('${AppString.serverError}${response.statusCode}');
      }
      return model;
    }
  } else {
    ToastificationError.Error(AppString.invalidserverresponseformat);
  }
  return null;
}
