class GirviListModel {
  bool? status;
  String? search;
  int? custCount;
  String? message;
  List<GirviData>? data;

  GirviListModel({
    this.status,
    this.search,
    this.custCount,
    this.message,
    this.data,
  });

  GirviListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    search = json['Search'];
    custCount = json['CustCount'];
    message = json['message'];
    if (json['data'] != null) {
      data = <GirviData>[];
      json['data'].forEach((v) {
        data!.add(GirviData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['Search'] = search;
    data['CustCount'] = custCount;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GirviData {
  String? girviId;
  String? custName;
  String? custPhone;
  String? uniqueId;
  String? dueDate;
  String? girviDate;
  String? interest;
  String? givenAmt;
  String? totalCunt;
  String? balance;
  String? interestAmt;
  String? paidInterset;
  String? isClosed;
  String? isCarried;

  GirviData({
    this.girviId,
    this.custName,
    this.custPhone,
    this.uniqueId,
    this.dueDate,
    this.girviDate,
    this.interest,
    this.givenAmt,
    this.totalCunt,
    this.balance,
    this.interestAmt,
    this.paidInterset,
    this.isClosed,
    this.isCarried,
  });

  GirviData.fromJson(Map<String, dynamic> json) {
    girviId = json['GirviId'];
    custName = json['CustName'];
    custPhone = json['CustPhone'];
    uniqueId = json['UniqueId'];
    dueDate = json['DueDate'];
    girviDate = json['GirviDate'];
    interest = json['Interest'];
    givenAmt = json['GivenAmt'];
    totalCunt = json['TotalCunt'];
    balance = json['Balance'];
    interestAmt = json['InterestAmt'];
    paidInterset = json['PaidInterset'];
    isClosed = json['IsClosed'];
    isCarried = json['IsCarried'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['GirviId'] = girviId;
    data['CustName'] = custName;
    data['CustPhone'] = custPhone;
    data['UniqueId'] = uniqueId;
    data['DueDate'] = dueDate;
    data['GirviDate'] = girviDate;
    data['Interest'] = interest;
    data['GivenAmt'] = givenAmt;
    data['TotalCunt'] = totalCunt;
    data['Balance'] = balance;
    data['InterestAmt'] = interestAmt;
    data['PaidInterset'] = paidInterset;
    data['IsClosed'] = isClosed;
    data['IsCarried'] = isCarried;
    return data;
  }
}
