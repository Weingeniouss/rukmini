class YearModel {
  bool? status;
  String? message;
  List<YearData>? data;

  YearModel({this.status, this.message, this.data});

  YearModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <YearData>[];
      json['data'].forEach((v) {
        data!.add(YearData.fromJson(v));
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

class YearData {
  String? yearId;
  String? title;
  String? formDate;
  String? toDate;
  String? isCurrent;

  YearData({this.yearId, this.title, this.formDate, this.toDate, this.isCurrent});

  YearData.fromJson(Map<String, dynamic> json) {
    yearId = json['YearId'];
    title = json['Title'];
    formDate = json['FormDate'];
    toDate = json['ToDate'];
    isCurrent = json['IsCurrent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['YearId'] = yearId;
    data['Title'] = title;
    data['FormDate'] = formDate;
    data['ToDate'] = toDate;
    data['IsCurrent'] = isCurrent;
    return data;
  }
}