// ignore_for_file: avoid_print, file_names

import 'package:shared_preferences/shared_preferences.dart';

import '../../view/utils/app_constants.dart';

class LocalDatabase {
  //load and unload the data !
  Future loadLocalData() async {
    pref = await SharedPreferences.getInstance();

    emailStrore = pref!.getString('email') ?? '';
    passwordStrore = pref!.getString('password') ?? '';

    tokans = pref!.getString('tokan') ?? '';

    islogin = pref!.getBool('login') ?? false;

    userId = pref!.getString('UserId') ?? '';

    print('Email $emailStrore');
    print('Password $passwordStrore');

    print('islogin :- $islogin');
    print('tokans :- $tokans');
    print('userId :- $userId');
  }

  //Save Login Start
  Future loginSaveData({
    String? email,
    String? password,
    String? uId,
  }) async {
    pref!.setString('email', email!);
    pref!.setString('password', password!);
    pref!.setString('tokan', tokans);
    pref!.setString('UserId', uId!);

    emailStrore = pref!.getString('email')!;
    passwordStrore = pref!.getString('password')!;
    tokans = pref!.getString('tokan')!;
    userId = pref!.getString('UserId')!;

    print('emailStrore :- $emailStrore');
    print('passwordStrore :- $passwordStrore');
    print('tokans :- $tokans');
    print('userId :- $userId');

    pref!.setBool('login', true);
    islogin = pref!.getBool('login')!;
    print('islogin :- $islogin');
  }
}
