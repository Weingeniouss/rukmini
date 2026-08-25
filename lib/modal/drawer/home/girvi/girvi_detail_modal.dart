class GiriviDetailModal {
  bool? status;
  String? message;
  GiriviDetailData? data;

  GiriviDetailModal({this.status, this.message, this.data});

  GiriviDetailModal.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? GiriviDetailData.fromJson(json['data']) : null;
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

class GiriviDetailData {
  String? girviId;
  String? custId;
  String? custName;
  String? custPhone;
  String? uniqueId;
  String? girviDate;
  String? givenMonth;
  String? dueDate;
  String? interest;
  String? givenAmt;
  String? totalCunt;
  String? discAmt;
  String? badDept;
  num? balance;
  String? isClosed;
  String? tranDate;
  String? tranTillDate;
  String? custProfile;
  String? address;
  String? interestAmt;
  String? gracePeriod;
  String? actualAmt;
  String? actualDate;
  String? isStartingCarry;
  Nominee? nominee;
  List<ProductDetail>? productDetail;
  List<dynamic>? tranHistory;
  num? totalPaidAmt;
  num? paidInterset;
  num? cRDR;
  num? tillInterest;
  num? monthInterset;
  String? tillDate;
  num? tillMonth;

  GiriviDetailData(
      {this.girviId,
      this.custId,
      this.custName,
      this.custPhone,
      this.uniqueId,
      this.girviDate,
      this.givenMonth,
      this.dueDate,
      this.interest,
      this.givenAmt,
      this.totalCunt,
      this.discAmt,
      this.badDept,
      this.balance,
      this.isClosed,
      this.tranDate,
      this.tranTillDate,
      this.custProfile,
      this.address,
      this.interestAmt,
      this.gracePeriod,
      this.actualAmt,
      this.actualDate,
      this.isStartingCarry,
      this.nominee,
      this.productDetail,
      this.tranHistory,
      this.totalPaidAmt,
      this.paidInterset,
      this.cRDR,
      this.tillInterest,
      this.monthInterset,
      this.tillDate,
      this.tillMonth});

  GiriviDetailData.fromJson(Map<String, dynamic> json) {
    girviId = json['GirviId'];
    custId = json['CustId'];
    custName = json['CustName'];
    custPhone = json['CustPhone'];
    uniqueId = json['UniqueId'];
    girviDate = json['GirviDate'];
    givenMonth = json['GivenMonth'];
    dueDate = json['DueDate'];
    interest = json['Interest'];
    givenAmt = json['GivenAmt'];
    totalCunt = json['TotalCunt'];
    discAmt = json['DiscAmt'];
    badDept = json['BadDept'];
    balance = json['Balance'];
    isClosed = json['IsClosed'];
    tranDate = json['TranDate'];
    tranTillDate = json['TranTillDate'];
    custProfile = json['CustProfile'];
    address = json['Address'];
    interestAmt = json['InterestAmt'];
    gracePeriod = json['GracePeriod'];
    actualAmt = json['ActualAmt'];
    actualDate = json['ActualDate'];
    isStartingCarry = json['IsStartingCarry'];
    nominee =
        json['Nominee'] != null ? Nominee.fromJson(json['Nominee']) : null;
    if (json['ProductDetail'] != null) {
      productDetail = <ProductDetail>[];
      json['ProductDetail'].forEach((v) {
        productDetail!.add(ProductDetail.fromJson(v));
      });
    }
    if (json['TranHistory'] != null) {
      tranHistory = <dynamic>[];
      // json['TranHistory'].forEach((v) { tranHistory!.add(new dynamic.fromJson(v)); });
    }
    totalPaidAmt = json['TotalPaidAmt'];
    paidInterset = json['PaidInterset'];
    cRDR = json['CR_DR'];
    tillInterest = json['TillInterest'];
    monthInterset = json['MonthInterset'];
    tillDate = json['TillDate'];
    tillMonth = json['TillMonth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['GirviId'] = girviId;
    data['CustId'] = custId;
    data['CustName'] = custName;
    data['CustPhone'] = custPhone;
    data['UniqueId'] = uniqueId;
    data['GirviDate'] = girviDate;
    data['GivenMonth'] = givenMonth;
    data['DueDate'] = dueDate;
    data['Interest'] = interest;
    data['GivenAmt'] = givenAmt;
    data['TotalCunt'] = totalCunt;
    data['DiscAmt'] = discAmt;
    data['BadDept'] = badDept;
    data['Balance'] = balance;
    data['IsClosed'] = isClosed;
    data['TranDate'] = tranDate;
    data['TranTillDate'] = tranTillDate;
    data['CustProfile'] = custProfile;
    data['Address'] = address;
    data['InterestAmt'] = interestAmt;
    data['GracePeriod'] = gracePeriod;
    data['ActualAmt'] = actualAmt;
    data['ActualDate'] = actualDate;
    data['IsStartingCarry'] = isStartingCarry;
    if (nominee != null) {
      data['Nominee'] = nominee!.toJson();
    }
    if (productDetail != null) {
      data['ProductDetail'] = productDetail!.map((v) => v.toJson()).toList();
    }
    if (tranHistory != null) {
      data['TranHistory'] = tranHistory!.map((v) => v.toJson()).toList();
    }
    data['TotalPaidAmt'] = totalPaidAmt;
    data['PaidInterset'] = paidInterset;
    data['CR_DR'] = cRDR;
    data['TillInterest'] = tillInterest;
    data['MonthInterset'] = monthInterset;
    data['TillDate'] = tillDate;
    data['TillMonth'] = tillMonth;
    return data;
  }
}

class Nominee {
  Nominee();

  Nominee.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    return data;
  }
}

class ProductDetail {
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
  String? isHallmark;
  String? isGemStone;
  String? isReturn;
  String? returnDate;
  String? badDept;
  String? prodType;
  String? metalName;
  String? catName;
  List<dynamic>? diamondList;
  List<dynamic>? galleryList;
  List<LockerList>? lockerList;
  List<dynamic>? karkitList;

  ProductDetail(
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
      this.isHallmark,
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

  ProductDetail.fromJson(Map<String, dynamic> json) {
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
    isHallmark = json['IsHallmark'];
    isGemStone = json['IsGemStone'];
    isReturn = json['IsReturn'];
    returnDate = json['ReturnDate'];
    badDept = json['BadDept'];
    prodType = json['ProdType'];
    metalName = json['MetalName'];
    catName = json['CatName'];
    if (json['DiamondList'] != null) {
      diamondList = <dynamic>[];
      // json['DiamondList'].forEach((v) { diamondList!.add(new dynamic.fromJson(v)); });
    }
    if (json['GalleryList'] != null) {
      galleryList = <dynamic>[];
      // json['GalleryList'].forEach((v) { galleryList!.add(new dynamic.fromJson(v)); });
    }
    if (json['LockerList'] != null) {
      lockerList = <LockerList>[];
      json['LockerList'].forEach((v) {
        lockerList!.add(LockerList.fromJson(v));
      });
    }
    if (json['KarkitList'] != null) {
      karkitList = <dynamic>[];
      // json['KarkitList'].forEach((v) { karkitList!.add(new dynamic.fromJson(v)); });
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
    data['IsHallmark'] = isHallmark;
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

class LockerList {
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

  LockerList(
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

  LockerList.fromJson(Map<String, dynamic> json) {
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
    data['GirviDate'] = lockerDate;
    return data;
  }
}
