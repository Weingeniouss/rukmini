class CustomerTypeMaster {
  bool? status;
  String? message;
  List<CustomerTypeData>? data;

  CustomerTypeMaster({this.status, this.message, this.data});

  CustomerTypeMaster.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CustomerTypeData>[];
      json['data'].forEach((v) {
        data!.add(CustomerTypeData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomerTypeData {
  String? typeId;
  String? name;

  CustomerTypeData({this.typeId, this.name});

  CustomerTypeData.fromJson(Map<String, dynamic> json) {
    typeId = json['TypeId'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TypeId'] = typeId;
    data['Name'] = name;
    return data;
  }
}
