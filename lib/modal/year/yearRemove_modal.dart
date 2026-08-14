// ignore_for_file: file_names

class YearRemoveModal {
  bool? status;
  dynamic message;

  YearRemoveModal({this.status, this.message});

  YearRemoveModal.fromJson(Map<String, dynamic> json) {
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
