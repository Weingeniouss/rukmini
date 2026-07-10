// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:rukmini/view/utils/app_Color.dart';

class AppIcon {
  // Login Assets
  static const user = 'asset/appImage/icon/user.png';
  static const padlock = 'asset/appImage/icon/padlock.png';
  static const btLogin = 'asset/appImage/icon/bt_login.png';

  // Home Assets
  static const openMenu = 'asset/appImage/icon/Open_Menu.svg';

  // AppBar Icons
  static Icon search = Icon(Icons.search, color: AppColor.fullScreenColor);
  static Icon edit = Icon(Icons.edit, color: AppColor.fullScreenColor);
  static Icon delete = Icon(Icons.delete, color: AppColor.fullScreenColor);
  static Icon back = Icon(Icons.keyboard_arrow_left, color: AppColor.backgroundColor, size: 30);

  // Common Icons (IconData)
  static const IconData add = Icons.add;
  static const IconData person = Icons.person;
  static const IconData personPin = Icons.person_pin;
  static const IconData verifiedUser = Icons.verified_user;
  static const IconData brokenImage = Icons.broken_image;
  static const IconData location = Icons.location_on;
  static const IconData status = Icons.info_outline;
  static const IconData calendar = Icons.calendar_month;
  static const IconData category = Icons.category;
  static const IconData phone = Icons.phone;
  static const IconData fingerprint = Icons.fingerprint;
  static const IconData date = Icons.calendar_today;
  static const IconData rupee = Icons.currency_rupee;
  static const IconData wallet = Icons.account_balance_wallet;
  static const IconData payment = Icons.payments_outlined;
  static const IconData trend = Icons.trending_up;
  static const IconData checkCircle = Icons.check_circle_outline;
  static const IconData camera = Icons.camera_enhance_outlined;

  // Contact Icons
  static const IconData call = Icons.call;
  static const IconData message = Icons.message;
  static const IconData chat = Icons.chat;

  // Drawer Icons
  static const IconData home = Icons.home_outlined;
  static const IconData settings = Icons.settings_suggest_outlined;
  static const IconData personOutline = Icons.person_pin_outlined;
  static const IconData bank = Icons.account_balance_outlined;
  static const IconData grid = Icons.grid_view_outlined;
  static const IconData lockPerson = Icons.lock_person_outlined;
  static const IconData pending = Icons.pending_actions_outlined;
  static const IconData lockReset = Icons.lock_reset_outlined;
  static const IconData description = Icons.description_outlined;
  static const IconData contact = Icons.contact_mail_outlined;
  static const IconData logout = Icons.logout;

  // Input Icons
  static const IconData visibilityOff = Icons.visibility_off_outlined;
  static const IconData visibilityOn = Icons.visibility_outlined;
}
