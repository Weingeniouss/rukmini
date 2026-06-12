class LoginModel {
  bool? status;
  Data? data;
  String? message;

  LoginModel({this.status, this.data, this.message});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class Data {
  String? userId;
  String? email;
  String? phone;
  String? roleId;
  String? status;
  String? roleName;
  String? isSupper;
  String? isLogin;
  String? loginToken;

  Data(
      {this.userId,
      this.email,
      this.phone,
      this.roleId,
      this.status,
      this.roleName,
      this.isSupper,
      this.isLogin,
      this.loginToken});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
    email = json['Email'];
    phone = json['Phone'];
    roleId = json['RoleId'];
    status = json['Status'];
    roleName = json['RoleName'];
    isSupper = json['IsSupper'];
    isLogin = json['IsLogin'];
    loginToken = json['LoginToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserId'] = userId;
    data['Email'] = email;
    data['Phone'] = phone;
    data['RoleId'] = roleId;
    data['Status'] = status;
    data['RoleName'] = roleName;
    data['IsSupper'] = isSupper;
    data['IsLogin'] = isLogin;
    data['LoginToken'] = loginToken;
    return data;
  }
}
