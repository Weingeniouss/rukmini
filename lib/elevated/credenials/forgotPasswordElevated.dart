import 'package:get/get.dart';
import 'package:rukmini/controller/api/controllers/credentials/forgot_password_controller.dart';

Future<void> getForgotPassword() async {
  final ForgotPasswordController controller = Get.put(ForgotPasswordController());
  await controller.forgotPassword();
}
