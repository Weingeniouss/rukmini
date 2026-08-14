// ignore_for_file: file_names

class ProductTypeAddModal {
  bool? status;
  String? message;

  ProductTypeAddModal({this.status, this.message});

  ProductTypeAddModal.fromJson(Map<String, dynamic> json) {
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
