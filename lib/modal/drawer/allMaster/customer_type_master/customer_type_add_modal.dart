class CustomerTypeAddModal {
  bool? status;
  String? message;
  CustomerTypeAddData? data;

  CustomerTypeAddModal({this.status, this.message, this.data});

  CustomerTypeAddModal.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? CustomerTypeAddData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class CustomerTypeAddData {
  String? typeId;
  String? name;

  CustomerTypeAddData({this.typeId, this.name});

  CustomerTypeAddData.fromJson(Map<String, dynamic> json) {
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
