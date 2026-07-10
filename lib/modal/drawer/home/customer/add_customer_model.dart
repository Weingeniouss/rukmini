class AddCustomerModel {
  bool? status;
  String? message;

  AddCustomerModel({this.status, this.message});

  AddCustomerModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}
