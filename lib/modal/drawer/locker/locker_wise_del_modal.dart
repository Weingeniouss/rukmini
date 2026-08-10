class LockerWiseDelModal {
  bool? status;
  String? search;
  String? lockerCnt;
  String? message;
  List<LockerWiseData>? data;

  LockerWiseDelModal(
      {this.status,
      this.search,
      this.lockerCnt,
      this.message,
      this.data});

  LockerWiseDelModal.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    search = json['Search'];
    lockerCnt = json['LockerCnt'];
    message = json['message'];
    if (json['data'] != null) {
      data = <LockerWiseData>[];
      json['data'].forEach((v) {
        data!.add(LockerWiseData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['Search'] = search;
    data['LockerCnt'] = lockerCnt;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LockerWiseData {
  String? prodLockerId;
  String? tatalProd;
  String? custName;
  String? uniqueId;
  String? lockerCode;
  String? code;
  String? totalAmt;
  String? girviId;
  String? custId;
  String? lockerId;
  String? balance;

  LockerWiseData(
      {this.prodLockerId,
      this.tatalProd,
      this.custName,
      this.uniqueId,
      this.lockerCode,
      this.code,
      this.totalAmt,
      this.girviId,
      this.custId,
      this.lockerId,
      this.balance});

  LockerWiseData.fromJson(Map<String, dynamic> json) {
    prodLockerId = json['ProdLockerId'];
    tatalProd = json['TatalProd'];
    custName = json['CustName'];
    uniqueId = json['UniqueId'];
    lockerCode = json['LockerCode'];
    code = json['Code'];
    totalAmt = json['TotalAmt'];
    girviId = json['GirviId'];
    custId = json['CustId'];
    lockerId = json['LockerId'];
    balance = json['Balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ProdLockerId'] = prodLockerId;
    data['TatalProd'] = tatalProd;
    data['CustName'] = custName;
    data['UniqueId'] = uniqueId;
    data['LockerCode'] = lockerCode;
    data['Code'] = code;
    data['TotalAmt'] = totalAmt;
    data['GirviId'] = girviId;
    data['CustId'] = custId;
    data['LockerId'] = lockerId;
    data['Balance'] = balance;
    return data;
  }
}
