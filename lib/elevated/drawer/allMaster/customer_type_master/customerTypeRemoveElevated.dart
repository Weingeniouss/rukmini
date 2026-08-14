// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../controller/api/services/drawer/all_master/customer_type_master/customerType_service.dart';
import '../../../../modal/drawer/allMaster/customer_type_master/customer_type_remove_modal.dart';
import '../../../../view/utils/widget/pop.dart';

Future<CustomerTypeRemoveModal?> postCustomerTypeRemove({
  required String typeId,
}) async {
  final CustomerTypeServices service = CustomerTypeServices();
  final http.Response response = await service.customerTypeRemoveApi(
    typeId: typeId,
  );
  final decoded = jsonDecode(response.body);
  if (decoded is Map<String, dynamic>) {
    final model = CustomerTypeRemoveModal.fromJson(decoded);
    if (response.statusCode == 200) {
      if (model.status == true) {
        ToastificationSuccess.Success(model.message ?? 'Removed successfully');
        return model;
      }
      ToastificationError.Error(model.message ?? 'Failed to remove');
    } else {
      ToastificationError.Error('Server Error: ${response.statusCode}');
    }
  }
  return null;
}
