// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../controller/api/services/metal/metalAdd_service.dart';
import '../../modal/metal/metalAdd_modal.dart';
import 'package:rukmini/view/utils/app_String.dart';
import '../../view/utils/widget/pop.dart';

Future<MetalAddModal?> postMetalAdd({
  required String karat,
  required String goldContent,
  String? metalId,
}) async {
  final MetalAddServices service = MetalAddServices();
  final http.Response response = await service.metalAddApi(
    karat: karat,
    goldContent: goldContent,
    metalId: metalId,
  );

  final decoded = jsonDecode(response.body);
  if (decoded is Map<String, dynamic>) {
    final model = MetalAddModal.fromJson(decoded);
    if (response.statusCode == 200) {
      if (model.status == true) {
        ToastificationSuccess.Success(
          model.message ?? 'Metal details saved successfully',
        );
        return model;
      } else {
        ToastificationError.Error(
          model.message ?? AppString.failedToAddMetal,
        );
      }
    } else {
      ToastificationError.Error('${AppString.serverError}${response.statusCode}');
    }
  } else {
    ToastificationError.Error('Invalid server response format');
  }
  return null;
}
