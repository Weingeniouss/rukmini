// ignore_for_file: file_names

class CategoryRemoveModal {
  bool? status;
  String? message;

  CategoryRemoveModal({this.status, this.message});

  CategoryRemoveModal.fromJson(Map<String, dynamic> json) {
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
