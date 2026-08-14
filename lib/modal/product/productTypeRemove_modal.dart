// ignore_for_file: file_names

class ProductTypeRemoveModal {
  bool? status;
  String? message;

  ProductTypeRemoveModal({this.status, this.message});

  ProductTypeRemoveModal.fromJson(Map<String, dynamic> json) {
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
