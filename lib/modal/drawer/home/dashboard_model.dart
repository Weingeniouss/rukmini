class DashboardModel {
  bool? status;
  String? message;
  DashboardData? data;

  DashboardModel({this.status, this.message, this.data});

  DashboardModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null && json['data'] is Map<String, dynamic>) {
      data = DashboardData.fromJson(json['data']);
    } else {
      data = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class DashboardData {
  int? totalCust;
  String? totalGirvi;
  int? totalKarkit;
  int? totalSold;
  String? totalDueGirvi;
  String? totalDueOverGirvi;
  List<LockerList>? lockerList;
  String? totalPendingProduct;
  String? totalReturnProduct;

  DashboardData(
      {this.totalCust,
      this.totalGirvi,
      this.totalKarkit,
      this.totalSold,
      this.totalDueGirvi,
      this.totalDueOverGirvi,
      this.lockerList,
      this.totalPendingProduct,
      this.totalReturnProduct});

  DashboardData.fromJson(Map<String, dynamic> json) {
    totalCust = json['TotalCust'];
    totalGirvi = json['TotalGirvi'];
    totalKarkit = json['TotalKarkit'];
    totalSold = json['TotalSold'];
    totalDueGirvi = json['TotalDueGirvi'];
    totalDueOverGirvi = json['TotalDueOverGirvi'];
    if (json['LockerList'] != null) {
      lockerList = <LockerList>[];
      json['LockerList'].forEach((v) {
        lockerList!.add(LockerList.fromJson(v));
      });
    }
    totalPendingProduct = json['TotalPendingProduct'];
    totalReturnProduct = json['TotalReturnProduct'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TotalCust'] = totalCust;
    data['TotalGirvi'] = totalGirvi;
    data['TotalKarkit'] = totalKarkit;
    data['TotalSold'] = totalSold;
    data['TotalDueGirvi'] = totalDueGirvi;
    data['TotalDueOverGirvi'] = totalDueOverGirvi;
    if (lockerList != null) {
      data['LockerList'] = lockerList!.map((v) => v.toJson()).toList();
    }
    data['TotalPendingProduct'] = totalPendingProduct;
    data['TotalReturnProduct'] = totalReturnProduct;
    return data;
  }
}

class LockerList {
  String? lockerId;
  String? comName;
  String? lockerCode;
  String? isDefault;
  String? totalAmt;

  LockerList(
      {this.lockerId,
      this.comName,
      this.lockerCode,
      this.isDefault,
      this.totalAmt});

  LockerList.fromJson(Map<String, dynamic> json) {
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
