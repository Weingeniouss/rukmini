class RemoveGirvie {
  bool? status;
  String? message;

  RemoveGirvie({this.status, this.message});

  RemoveGirvie.fromJson(Map<String, dynamic> json) {
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
