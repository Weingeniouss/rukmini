class CustomerReportModel {
  bool? status;
  String? message;
  dynamic givenAmt;
  dynamic pendingAmt;
  List<CustomerReportData>? data;

  CustomerReportModel({
    this.status,
    this.message,
    this.givenAmt,
    this.pendingAmt,
    this.data,
  });

  CustomerReportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    givenAmt = json['GivenAmt'];
    pendingAmt = json['PendingAmt'];
    if (json['data'] != null) {
      data = <CustomerReportData>[];
      json['data'].forEach((v) {
        data!.add(CustomerReportData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['GivenAmt'] = givenAmt;
    data['PendingAmt'] = pendingAmt;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomerReportData {
  String? custId;
  String? name;
  String? custCode;
  String? address;
  String? gracePeriod;
  String? nomineeName;
  String? nomineePhone;
  String? custRelation;
  String? custPhone;
  String? custType;
  int? girviCnt;
  dynamic givenAmt;
  dynamic pendingAmt;

  CustomerReportData({
    this.custId,
    this.name,
    this.custCode,
    this.address,
    this.gracePeriod,
    this.nomineeName,
    this.nomineePhone,
    this.custRelation,
    this.custPhone,
    this.custType,
    this.girviCnt,
    this.givenAmt,
    this.pendingAmt,
  });

  CustomerReportData.fromJson(Map<String, dynamic> json) {
    custId = json['CustId'];
    name = json['Name'];
    custCode = json['CustCode'];
    address = json['Address'];
    gracePeriod = json['GracePeriod'];
    nomineeName = json['NomineeName'];
    nomineePhone = json['NomineePhone'];
    custRelation = json['CustRelation'];
    custPhone = json['CustPhone'];
    custType = json['CustType'];
    girviCnt = json['GirviCnt'];
    givenAmt = json['GivenAmt'];
    pendingAmt = json['PendingAmt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CustId'] = custId;
    data['Name'] = name;
    data['CustCode'] = custCode;
    data['Address'] = address;
    data['GracePeriod'] = gracePeriod;
    data['NomineeName'] = nomineeName;
    data['NomineePhone'] = nomineePhone;
    data['CustRelation'] = custRelation;
    data['CustPhone'] = custPhone;
    data['CustType'] = custType;
    data['GirviCnt'] = girviCnt;
    data['GivenAmt'] = givenAmt;
    data['PendingAmt'] = pendingAmt;
    return data;
  }
}
