import 'package:get/get.dart';

class InputFieldController extends GetxController {
  var obscureText = false.obs;

  void obscureTextClick() {
    obscureText.value = !obscureText.value;
  }
}
