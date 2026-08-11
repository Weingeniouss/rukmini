class LockerDetailModal {
  bool? status;
  LockerDetailData? data;
  dynamic message;

  LockerDetailModal({this.status, this.data, this.message});

  LockerDetailModal.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? LockerDetailData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class LockerDetailData {
  List<ProductListDetail>? productList;
  List<dynamic>? transList;
  TransObj? transObj;

  LockerDetailData({this.productList, this.transList, this.transObj});

  LockerDetailData.fromJson(Map<String, dynamic> json) {
    if (json['productList'] != null) {
      productList = <ProductListDetail>[];
      json['productList'].forEach((v) {
        productList!.add(ProductListDetail.fromJson(v));
      });
    }
    if (json['transList'] != null) {
      transList = <dynamic>[];
      // json['transList'].forEach((v) { transList!.add(new dynamic.fromJson(v)); });
    }
    transObj = json['transObj'] != null ? TransObj.fromJson(json['transObj']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (productList != null) {
      data['productList'] = productList!.map((v) => v.toJson()).toList();
    }
    if (transList != null) {
      data['transList'] = transList!.map((v) => v.toJson()).toList();
    }
    if (transObj != null) {
      data['transObj'] = transObj!.toJson();
    }
    return data;
  }
}

class ProductListDetail {
  String? productId;
  String? productStatus;
  String? karkitDate;
  String? girviId;
  String? productTypeId;
  String? pieces;
  String? weight;
  String? categoryId;
  String? metalId;
  String? todayRate;
  String? origAmount;
  String? givenAmount;
  String? isDiamond;
  String? isGemStone;
  String? isReturn;
  String? returnDate;
  String? badDept;
  String? prodType;
  String? metalName;
  String? catName;
  List<dynamic>? diamondList;
  List<dynamic>? galleryList;
  List<LockerSubList>? lockerList;
  List<dynamic>? karkitList;

  ProductListDetail(
      {this.productId,
      this.productStatus,
      this.karkitDate,
      this.girviId,
      this.productTypeId,
      this.pieces,
      this.weight,
      this.categoryId,
      this.metalId,
      this.todayRate,
      this.origAmount,
      this.givenAmount,
      this.isDiamond,
      this.isGemStone,
      this.isReturn,
      this.returnDate,
      this.badDept,
      this.prodType,
      this.metalName,
      this.catName,
      this.diamondList,
      this.galleryList,
      this.lockerList,
      this.karkitList});

  ProductListDetail.fromJson(Map<String, dynamic> json) {
    productId = json['ProductId'];
    productStatus = json['ProductStatus'];
    karkitDate = json['KarkitDate'];
    girviId = json['GirviId'];
    productTypeId = json['ProductTypeId'];
    pieces = json['Pieces'];
    weight = json['Weight'];
    categoryId = json['CategoryId'];
    metalId = json['MetalId'];
    todayRate = json['TodayRate'];
    origAmount = json['OrigAmount'];
    givenAmount = json['GivenAmount'];
    isDiamond = json['IsDiamond'];
    isGemStone = json['IsGemStone'];
    isReturn = json['IsReturn'];
    returnDate = json['ReturnDate'];
    badDept = json['BadDept'];
    prodType = json['ProdType'];
    metalName = json['MetalName'];
    catName = json['CatName'];
    if (json['DiamondList'] != null) {
      diamondList = <dynamic>[];
    }
    if (json['GalleryList'] != null) {
      galleryList = <dynamic>[];
    }
    if (json['LockerList'] != null) {
      lockerList = <LockerSubList>[];
      json['LockerList'].forEach((v) {
        lockerList!.add(LockerSubList.fromJson(v));
      });
    }
    if (json['KarkitList'] != null) {
      karkitList = <dynamic>[];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ProductId'] = productId;
    data['ProductStatus'] = productStatus;
    data['KarkitDate'] = karkitDate;
    data['GirviId'] = girviId;
    data['ProductTypeId'] = productTypeId;
    data['Pieces'] = pieces;
    data['Weight'] = weight;
    data['CategoryId'] = categoryId;
    data['MetalId'] = metalId;
    data['TodayRate'] = todayRate;
    data['OrigAmount'] = origAmount;
    data['GivenAmount'] = givenAmount;
    data['IsDiamond'] = isDiamond;
    data['IsGemStone'] = isGemStone;
    data['IsReturn'] = isReturn;
    data['ReturnDate'] = returnDate;
    data['BadDept'] = badDept;
    data['ProdType'] = prodType;
    data['MetalName'] = metalName;
    data['CatName'] = catName;
    if (diamondList != null) {
      data['DiamondList'] = diamondList!.map((v) => v.toJson()).toList();
    }
    if (galleryList != null) {
      data['GalleryList'] = galleryList!.map((v) => v.toJson()).toList();
    }
    if (lockerList != null) {
      data['LockerList'] = lockerList!.map((v) => v.toJson()).toList();
    }
    if (karkitList != null) {
      data['KarkitList'] = karkitList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LockerSubList {
  String? prodLockerId;
  String? productId;
  String? lockerId;
  String? interestRate;
  String? givenAmt;
  String? isReturn;
  String? returnDate;
  String? lockerCode;
  String? code;
  String? isCarried;
  String? lockerDate;

  LockerSubList(
      {this.prodLockerId,
      this.productId,
      this.lockerId,
      this.interestRate,
      this.givenAmt,
      this.isReturn,
      this.returnDate,
      this.lockerCode,
      this.code,
      this.isCarried,
      this.lockerDate});

  LockerSubList.fromJson(Map<String, dynamic> json) {
    prodLockerId = json['ProdLockerId'];
    productId = json['ProductId'];
    lockerId = json['LockerId'];
    interestRate = json['InterestRate'];
    givenAmt = json['GivenAmt'];
    isReturn = json['IsReturn'];
    returnDate = json['ReturnDate'];
    lockerCode = json['LockerCode'];
    code = json['Code'];
    isCarried = json['IsCarried'];
    lockerDate = json['LockerDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ProdLockerId'] = prodLockerId;
    data['ProductId'] = productId;
    data['LockerId'] = lockerId;
    data['InterestRate'] = interestRate;
    data['GivenAmt'] = givenAmt;
    data['IsReturn'] = isReturn;
    data['ReturnDate'] = returnDate;
    data['LockerCode'] = lockerCode;
    data['Code'] = code;
    data['IsCarried'] = isCarried;
    data['LockerDate'] = lockerDate;
    return data;
  }
}

class TransObj {
  String? givenAmt;
  String? lockerId;
  String? code;
  String? interestRate;
  String? lockerDate;
  String? lockerCode;
  num? balance;
  num? origBalance;
  num? tillInterest;
  num? monthInterset;
  String? tillDate;
  num? tillMonth;
  num? cRDR;
  num? totalPaidAmt;
  num? paidInterset;

  TransObj(
      {this.givenAmt,
      this.lockerId,
      this.code,
      this.interestRate,
      this.lockerDate,
      this.lockerCode,
      this.balance,
      this.origBalance,
      this.tillInterest,
      this.monthInterset,
      this.tillDate,
      this.tillMonth,
      this.cRDR,
      this.totalPaidAmt,
      this.paidInterset});

  TransObj.fromJson(Map<String, dynamic> json) {
    givenAmt = json['GivenAmt'];
    lockerId = json['LockerId'];
    code = json['Code'];
    interestRate = json['InterestRate'];
    lockerDate = json['LockerDate'];
    lockerCode = json['LockerCode'];
    balance = json['Balance'];
    origBalance = json['OrigBalance'];
    tillInterest = json['TillInterest'];
    monthInterset = json['MonthInterset'];
    tillDate = json['TillDate'];
    tillMonth = json['TillMonth'];
    cRDR = json['CR_DR'];
    totalPaidAmt = json['TotalPaidAmt'];
    paidInterset = json['PaidInterset'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['GivenAmt'] = givenAmt;
    data['LockerId'] = lockerId;
    data['Code'] = code;
    data['InterestRate'] = interestRate;
    data['LockerDate'] = lockerDate;
    data['LockerCode'] = lockerCode;
    data['Balance'] = balance;
    data['OrigBalance'] = origBalance;
    data['TillInterest'] = tillInterest;
    data['MonthInterset'] = monthInterset;
    data['TillDate'] = tillDate;
    data['TillMonth'] = tillMonth;
    data['CR_DR'] = cRDR;
    data['TotalPaidAmt'] = totalPaidAmt;
    data['PaidInterset'] = paidInterset;
    return data;
  }
}
