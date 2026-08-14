// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rukmini/view/utils/app_String.dart';
import '../../controller/api/services/metal/metalRemove_service.dart';
import '../../modal/metal/metalAdd_modal.dart';
import '../../view/utils/widget/pop.dart';

Future<MetalAddModal?> postMetalRemove({required String metalId}) async {
  final MetalRemoveServices service = MetalRemoveServices();
  final http.Response response = await service.metalRemoveApi(metalId: metalId);

  final decoded = jsonDecode(response.body);
  if (decoded is Map<String, dynamic>) {
    final model = MetalAddModal.fromJson(decoded);
    if (response.statusCode == 200) {
      if (model.status == true) {
        ToastificationSuccess.Success(model.message ?? 'Metal details removed successfully');
        return model;
      } else {
        ToastificationError.Error(model.message ?? AppString.failedToRemoveMetal);
      }
    } else {
      ToastificationError.Error('${AppString.serverError}${response.statusCode}');
    }
  } else {
    ToastificationError.Error('Invalid server response format');
  }
  return null;
}
