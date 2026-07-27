class PendingTransactionModel {
  bool? status;
  String? search;
  int? totalCount;
  String? message;
  List<PendingTransactionData>? data;

  PendingTransactionModel({
    this.status,
    this.search,
    this.totalCount,
    this.message,
    this.data,
  });

  PendingTransactionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    search = json['Search'];
    totalCount = json['TotalCount'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PendingTransactionData>[];
      json['data'].forEach((v) {
        data!.add(PendingTransactionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['Search'] = search;
    data['TotalCount'] = totalCount;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PendingTransactionData {
  String? uniqueId;
  String? productCnt;
  String? girviId;
  String? givenAmt;
  String? dueDate;
  String? paidAmount;
  String? paidInterestAmt;
  String? tranDate;
  String? tillDate;
  String? girviDate;
  String? givenMonth;
  String? interest;
  String? month;
  num? balance;
  String? custName;
  String? isStartingCarry;
  num? tillInterest;
  num? monthInterset;
  int? tillMonth;

  PendingTransactionData({
    this.uniqueId,
    this.productCnt,
    this.girviId,
    this.givenAmt,
    this.dueDate,
    this.paidAmount,
    this.paidInterestAmt,
    this.tranDate,
    this.tillDate,
    this.girviDate,
    this.givenMonth,
    this.interest,
    this.month,
    this.balance,
    this.custName,
    this.isStartingCarry,
    this.tillInterest,
    this.monthInterset,
    this.tillMonth,
  });

  PendingTransactionData.fromJson(Map<String, dynamic> json) {
    uniqueId = json['UniqueId'];
    productCnt = json['ProductCnt'];
    girviId = json['GirviId'];
    givenAmt = json['GivenAmt'];
    dueDate = json['DueDate'];
    paidAmount = json['PaidAmount'];
    paidInterestAmt = json['PaidInterestAmt'];
    tranDate = json['TranDate'];
    tillDate = json['TillDate'];
    girviDate = json['GirviDate'];
    givenMonth = json['GivenMonth'];
    interest = json['Interest'];
    month = json['Month'];
    balance = json['Balance'];
    custName = json['CustName'];
    isStartingCarry = json['IsStartingCarry'];
    tillInterest = json['TillInterest'];
    monthInterset = json['MonthInterset'];
    tillMonth = json['TillMonth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UniqueId'] = uniqueId;
    data['ProductCnt'] = productCnt;
    data['GirviId'] = girviId;
    data['GivenAmt'] = givenAmt;
    data['DueDate'] = dueDate;
    data['PaidAmount'] = paidAmount;
    data['PaidInterestAmt'] = paidInterestAmt;
    data['TranDate'] = tranDate;
    data['TillDate'] = tillDate;
    data['GirviDate'] = girviDate;
    data['GivenMonth'] = givenMonth;
    data['Interest'] = interest;
    data['Month'] = month;
    data['Balance'] = balance;
    data['CustName'] = custName;
    data['IsStartingCarry'] = isStartingCarry;
    data['TillInterest'] = tillInterest;
    data['MonthInterset'] = monthInterset;
    data['TillMonth'] = tillMonth;
    return data;
  }
}
