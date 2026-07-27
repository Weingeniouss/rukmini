import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
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
      return PendingTransactionModel.fromJson(decoded);
    }
  }
  return null;
}
