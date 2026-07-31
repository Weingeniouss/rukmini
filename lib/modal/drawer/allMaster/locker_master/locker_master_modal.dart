class LockerMasterModal {
  bool? status;
  String? message;
  List<LockerData>? data;

  LockerMasterModal({this.status, this.message, this.data});

  LockerMasterModal.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <LockerData>[];
      json['data'].forEach((v) {
        data!.add(LockerData.fromJson(v));
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

class LockerData {
  String? lockerId;
  String? comName;
  String? comAddress;
  String? personName;
  String? personPhone;
  String? lockerCode;
  String? interestRate;
  String? isDefault;

  LockerData({
    this.lockerId,
    this.comName,
    this.comAddress,
    this.personName,
    this.personPhone,
    this.lockerCode,
    this.interestRate,
    this.isDefault,
  });

  LockerData.fromJson(Map<String, dynamic> json) {
    lockerId = json['LockerId'];
    comName = json['ComName'];
    comAddress = json['ComAddress'];
    personName = json['PersonName'];
    personPhone = json['PersonPhone'];
    lockerCode = json['LockerCode'];
    interestRate = json['InterestRate'];
    isDefault = json['IsDefault'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['LockerId'] = lockerId;
    data['ComName'] = comName;
    data['ComAddress'] = comAddress;
    data['PersonName'] = personName;
    data['PersonPhone'] = personPhone;
    data['LockerCode'] = lockerCode;
    data['InterestRate'] = interestRate;
    data['IsDefault'] = isDefault;
    return data;
  }
}
