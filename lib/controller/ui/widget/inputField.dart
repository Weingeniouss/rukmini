// ignore_for_file: file_names

import 'package:get/get.dart';

class InputFieldController extends GetxController {
  var obscureText = false.obs;

  void obscureTextClick() {
    obscureText.value = !obscureText.value;
  }
}
