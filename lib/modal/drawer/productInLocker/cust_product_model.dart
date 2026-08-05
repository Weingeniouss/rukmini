class CustProductModel {
  bool? status;
  String? message;
  Data? data;

  CustProductModel({this.status, this.message, this.data});

  CustProductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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

class Data {
  List<CustList>? custList;
  List<ProductList>? productList;

  Data({this.custList, this.productList});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['CustList'] != null) {
      custList = <CustList>[];
      json['CustList'].forEach((v) {
        custList!.add(CustList.fromJson(v));
      });
    }
    if (json['ProductList'] != null) {
      productList = <ProductList>[];
      json['ProductList'].forEach((v) {
        productList!.add(ProductList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (custList != null) {
      data['CustList'] = custList!.map((v) => v.toJson()).toList();
    }
    if (productList != null) {
      data['ProductList'] = productList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustList {
  String? custId;
  String? name;
  String? custCode;
  String? address;
  List<PhoneList>? phoneList;
  List<ProductList>? productList;

  CustList(
      {this.custId,
      this.name,
      this.custCode,
      this.address,
      this.phoneList,
      this.productList});

  CustList.fromJson(Map<String, dynamic> json) {
    custId = json['CustId'];
    name = json['Name'];
    custCode = json['CustCode'];
    address = json['Address'];
    if (json['PhoneList'] != null) {
      phoneList = <PhoneList>[];
      json['PhoneList'].forEach((v) {
        phoneList!.add(PhoneList.fromJson(v));
      });
    }
    if (json['ProductList'] != null) {
      productList = <ProductList>[];
      json['ProductList'].forEach((v) {
        productList!.add(ProductList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CustId'] = custId;
    data['Name'] = name;
    data['CustCode'] = custCode;
    data['Address'] = address;
    if (phoneList != null) {
      data['PhoneList'] = phoneList!.map((v) => v.toJson()).toList();
    }
    if (productList != null) {
      data['ProductList'] = productList!.map((v) => v.toJson()).toList();
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

  PhoneList({this.phoneId, this.custId, this.phone, this.status, this.isDefault});

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

class ProductList {
  String? productId;
  String? girviId;
  String? pieces;
  String? weight;
  String? givenAmount;
  String? prodType;
  String? metalName;
  String? custName;
  String? custId;
  String? catName;
  String? productImg;
  String? prodLockerId;
  String? lockerCode;
  String? balance;
  String? girviDate;
  String? lockerDate;
  String? code;
  String? uniqueId;
  String? status;

  ProductList(
      {this.productId,
      this.girviId,
      this.pieces,
      this.weight,
      this.givenAmount,
      this.prodType,
      this.metalName,
      this.custName,
      this.custId,
      this.catName,
      this.productImg,
      this.prodLockerId,
      this.lockerCode,
      this.balance,
      this.girviDate,
      this.lockerDate,
      this.code,
      this.uniqueId,
      this.status});

  ProductList.fromJson(Map<String, dynamic> json) {
    productId = json['ProductId'];
    girviId = json['GirviId'];
    pieces = json['Pieces'];
    weight = json['Weight'];
    givenAmount = json['GivenAmount'];
    prodType = json['ProdType'];
    metalName = json['MetalName'];
    custName = json['CustName'];
    custId = json['CustId'];
    catName = json['CatName'];
    productImg = json['ProductImg'];
    prodLockerId = json['ProdLockerId'];
    lockerCode = json['LockerCode'];
    balance = json['Balance'];
    girviDate = json['GirviDate'];
    lockerDate = json['LockerDate'];
    code = json['Code'];
    uniqueId = json['UniqueId'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ProductId'] = productId;
    data['GirviId'] = girviId;
    data['Pieces'] = pieces;
    data['Weight'] = weight;
    data['GivenAmount'] = givenAmount;
    data['ProdType'] = prodType;
    data['MetalName'] = metalName;
    data['CustName'] = custName;
    data['CustId'] = custId;
    data['CatName'] = catName;
    data['ProductImg'] = productImg;
    data['ProdLockerId'] = prodLockerId;
    data['LockerCode'] = lockerCode;
    data['Balance'] = balance;
    data['GirviDate'] = girviDate;
    data['LockerDate'] = lockerDate;
    data['Code'] = code;
    data['UniqueId'] = uniqueId;
    data['Status'] = status;
    return data;
  }
}
