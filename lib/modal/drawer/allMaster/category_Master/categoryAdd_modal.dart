// ignore_for_file: file_names

class CategoryAddModal {
  bool? status;
  String? message;
  CategoryAddData? data;

  CategoryAddModal({this.status, this.message, this.data});

  CategoryAddModal.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? CategoryAddData.fromJson(json['data']) : null;
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

class CategoryAddData {
  String? categoryId;
  String? name;

  CategoryAddData({this.categoryId, this.name});

  CategoryAddData.fromJson(Map<String, dynamic> json) {
    categoryId = json['CategoryId'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CategoryId'] = categoryId;
    data['Name'] = name;
    return data;
  }
}
