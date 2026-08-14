// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../controller/api/services/drawer/all_master/customer_type_master/customerType_service.dart';
import '../../../../modal/drawer/allMaster/customer_type_master/customer_type_add_modal.dart';
import 'package:rukmini/view/utils/app_String.dart';
import '../../../../view/utils/widget/pop.dart';

Future<CustomerTypeAddModal?> postCustomerTypeAdd({
  required String name,
  String? typeId,
}) async {
  final CustomerTypeServices service = CustomerTypeServices();
  final http.Response response = await service.customerTypeAddApi(
    name: name,
    typeId: typeId,
  );
  final decoded = jsonDecode(response.body);
  if (decoded is Map<String, dynamic>) {
    final model = CustomerTypeAddModal.fromJson(decoded);
    if (response.statusCode == 200) {
      if (model.status == true) {
        ToastificationSuccess.Success(model.message ?? 'Saved successfully');
        return model;
      }
      ToastificationError.Error(model.message ?? AppString.failedToAddCustomerType);
    } else {
      ToastificationError.Error('${AppString.serverError}${response.statusCode}');
    }
  }
  return null;
}
