// ignore_for_file: deprecated_member_use, strict_top_level_inference

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/app_background.dart';
import 'package:rukmini/view/utils/app_constants.dart';
import 'package:rukmini/view/utils/app_logo.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    // Auto-navigation after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (islogin) {
        Get.offAllNamed('/home');
      } else {
        Get.offAllNamed('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Fullscreen(
      backgroundImage: AppBackground.backgroundImage,
      child: Column(
        children: [
          //Logo
          logo(AppLogo.rukminiLogo),
          SizedBox(height: AppSize.size20),

          //quote
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                const QuoteWidget(
                  quote: AppString.napoleonHill,
                  author: AppString.authorNapoleonHill,
                  goldColor: AppColor.goldColor,
                ),
                QuoteWidget(
                  quote: AppString.andyRooney,
                  author: AppString.andyRooneyJournalist,
                  goldColor: AppColor.goldColor,
                  onTap: () {
                    islogin ? Get.toNamed('/home') : Get.toNamed('/login');
                  },
                ),
                const QuoteWidget(
                  quote: AppString.williamGeorge,
                  author: AppString.williamGeorgeJordan,
                  goldColor: AppColor.goldColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget logo(logo) => Image.asset(logo, scale: 2);

class QuoteWidget extends StatelessWidget {
  final String quote;
  final String author;
  final Color goldColor;
  final void Function()? onTap;

  const QuoteWidget({
    super.key,
    required this.quote,
    required this.author,
    required this.goldColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            quote,
            style: TextStyle(
              color: goldColor.withOpacity(0.9),
              fontSize: AppSize.headingText,
              height: 1.4,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: context.height * 0.005),
          GestureDetector(
            onTap: onTap,
            child: Text(
              author,
              style: TextStyle(
                color: goldColor.withOpacity(0.7),
                fontSize: AppSize.largeText,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
