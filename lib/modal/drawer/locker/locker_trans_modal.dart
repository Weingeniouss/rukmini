class LockerTransModal {
  bool? status;
  String? message;
  List<LockerTransData>? data;

  LockerTransModal({this.status, this.message, this.data});

  LockerTransModal.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <LockerTransData>[];
      json['data'].forEach((v) {
        data!.add(LockerTransData.fromJson(v));
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

class LockerTransData {
  String? lockerId;
  String? comName;
  String? lockerCode;
  String? isDefault;
  String? totalAmt;

  LockerTransData(
      {this.lockerId,
      this.comName,
      this.lockerCode,
      this.isDefault,
      this.totalAmt});

  LockerTransData.fromJson(Map<String, dynamic> json) {
    lockerId = json['LockerId'];
    comName = json['ComName'];
    lockerCode = json['LockerCode'];
    isDefault = json['IsDefault'];
    totalAmt = json['TotalAmt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['LockerId'] = lockerId;
    data['ComName'] = comName;
    data['LockerCode'] = lockerCode;
    data['IsDefault'] = isDefault;
    data['TotalAmt'] = totalAmt;
    return data;
  }
}
