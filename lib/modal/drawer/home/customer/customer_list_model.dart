class CustomerListModel {
  bool? status;
  String? search;
  int? custCount;
  String? message;
  List<CustomerData>? data;

  CustomerListModel({
    this.status,
    this.search,
    this.custCount,
    this.message,
    this.data,
  });

  CustomerListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    search = json['Search'];
    custCount = json['CustCount'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CustomerData>[];
      json['data'].forEach((v) {
        data!.add(CustomerData.fromJson(v));
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

class CustomerData {
  String? name;
  String? custCode;
  String? address;
  String? gender;
  String? custId;
  String? status;
  String? image;
  String? imagePath;
  String? gracePeriod;
  List<PhoneList>? phoneList;
  List<CustType>? custType;

  CustomerData({
    this.name,
    this.custCode,
    this.address,
    this.gender,
    this.custId,
    this.status,
    this.image,
    this.imagePath,
    this.gracePeriod,
    this.phoneList,
    this.custType,
  });

  CustomerData.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    custCode = json['CustCode'];
    address = json['Address'];
    gender = json['Gender'];
    custId = json['CustId'];
    status = json['Status'];
    image = json['Image'];
    imagePath = json['ImagePath'];
    gracePeriod = json['GracePeriod'];
    if (json['PhoneList'] != null) {
      phoneList = <PhoneList>[];
      json['PhoneList'].forEach((v) {
        phoneList!.add(PhoneList.fromJson(v));
      });
    }
    if (json['CustType'] != null) {
      custType = <CustType>[];
      json['CustType'].forEach((v) {
        custType!.add(CustType.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Name'] = name;
    data['CustCode'] = custCode;
    data['Address'] = address;
    data['Gender'] = gender;
    data['CustId'] = custId;
    data['Status'] = status;
    data['Image'] = image;
    data['ImagePath'] = imagePath;
    data['GracePeriod'] = gracePeriod;
    if (phoneList != null) {
      data['PhoneList'] = phoneList!.map((v) => v.toJson()).toList();
    }
    if (custType != null) {
      data['CustType'] = custType!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PhoneList {
  String? phoneId;
  String? custId;
  String? phone;
  String? status;
  String? isDefault;

  PhoneList({
    this.phoneId,
    this.custId,
    this.phone,
    this.status,
    this.isDefault,
  });

  PhoneList.fromJson(Map<String, dynamic> json) {
    phoneId = json['PhoneId'];
    custId = json['CustId'];
    phone = json['Phone'];
    status = json['Status'];
    isDefault = json['IsDefault'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PhoneId'] = phoneId;
    data['CustId'] = custId;
    data['Phone'] = phone;
    data['Status'] = status;
    data['IsDefault'] = isDefault;
    return data;
  }
}

class CustType {
  String? custDelId;
  String? custId;
  String? typeId;
  String? typeName;
  String? status;

  CustType({
    this.custDelId,
    this.custId,
    this.typeId,
    this.typeName,
    this.status,
  });

  CustType.fromJson(Map<String, dynamic> json) {
    custDelId = json['CustDelId'];
    custId = json['CustId'];
    typeId = json['TypeId'];
    typeName = json['TypeName'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CustDelId'] = custDelId;
    data['CustId'] = custId;
    data['TypeId'] = typeId;
    data['TypeName'] = typeName;
    data['Status'] = status;
    return data;
  }
}
