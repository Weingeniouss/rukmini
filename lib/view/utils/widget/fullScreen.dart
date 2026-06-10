// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:rukmini/view/utils/app_Color.dart';

class Fullscreen extends StatelessWidget {
  final Widget child;
  String? backgroundImage;

  //All Screen Background All Over Screnn Effict !

  Fullscreen({super.key, required this.child, this.backgroundImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: AppColor.fullScreenColor,
          image: backgroundImage != null
              ? DecorationImage(
                  image: AssetImage(backgroundImage!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: SafeArea(child: child),
      ),
    );
  }
}
